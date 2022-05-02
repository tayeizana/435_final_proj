clear all

%{
Modeling people schedule for the project.
- There are 27 stops on the 4 bee line bus in yonkers.
- Each stop will take 2 mins
- The bus will go for 18 hrs back and forth.
- Bus duration one-way = 54
- Pick about 250 random PT riders  and asuume that all use PT for work.

- To start work at 9, they must be on the bus from 7:36 - 8:30
%}

%Modeling morning schedule.
%Morning bus starts at 4:00am.
pop9 = 175;
nifi = zeros(pop9,27*20);
num_of_stops9 = randi([1,27],pop9,1);
startstop9 = zeros(pop9,1);
for i=1:pop9
    startstop9(i) = randi([0,27-num_of_stops9(i)])+1;
end

for i=1:pop9
    for j=3*27:4*27
        if j==(3*27+startstop9(i))
         nifi(i,(3*27+startstop9(i):3*27+startstop9(i)+num_of_stops9(i)-1)) = 1;
        break
        end
    end
end
    

%Modeling Lunch schedule.
%{ 
- Assume that 50% of people that start work at 9 got to luch using the bus.
- according to bus schedule, people can start leaving work at 12:06pm. And
be back by 1:54.
%}

num_of_stopsl9 = randi([1,27],pop9,1);
startstopl9 = zeros(pop9,1);

for i=1:pop9
    startstopl9(i) = randi([0,27-num_of_stopsl9(i)])+1;
end

for i=1:pop9
    for j=8*27:9*27
        if j==(8*27+startstopl9(i))
         nifi(i,(8*27+startstopl9(i):8*27+startstopl9(i)+num_of_stopsl9(i)-1)) = 1;
         nifi(i,(9*27+startstopl9(i):9*27+startstopl9(i)+num_of_stopsl9(i)-1)) = 1;
        break
        end
    end
end


%Modeling coming back.
%{ 
- Assume that all 9am come back after 8 hours ... starting around 5.
- According to bus schedule, they can start leaving at 5:30.
%}

for i=1:pop9
    startstop9(i) = randi([0,27-num_of_stops9(i)])+1;
end

for i=1:pop9
    for j=14*27:15*27
        if j==(14*27+startstop9(i))
         nifi(i,(14*27+startstop9(i):14*27+startstop9(i)+num_of_stops9(i)-1)) = 1;
        break
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Modeling the randos

popr = 75;
nifir = zeros(popr,27*20);


num = 1:2*75;
num0 = num(mod(num,20)+1);
num0 = num0(rem(num0,2)==1);
num0 = num0';
start_roundr = num0(randperm(75),:);
end_roundr = zeros(75,1);

for i=1:75
    s = randi([mod(start_roundr(i)+4,20), 20]);
    if mod(s,2) == 1 && s ~=19
        s = mod(s+1,20);
    elseif s ==19
        s = 2;
    end
    
    end_roundr(i) = s;
end
    
roundsr(:,1) = start_roundr; roundsr(:,2) = end_roundr; roundsr(:,3) = zeros(75,01);

for i = 1:75
    if roundsr(i,1) < roundsr(i,2) && roundsr(i,2) - roundsr(i,1) >= 8
        roundsr(i,3) = 1;
    end
end



num_of_stopsr = randi([1,27],popr,1);




for i=1:popr
    stopsrwhen(i) = randi([0,27-num_of_stopsr(i)])+1;
end

for i=1:popr
    for j=(roundsr(i,1)-1)*27:(roundsr(i,1))*27
        if j==((roundsr(i,1)-1)*27+stopsrwhen(i))
         nifir(i,((roundsr(i,1)-1)*27+stopsrwhen(i):(roundsr(i,1)-1)*27+stopsrwhen(i)+num_of_stopsr(i)-1)) = 1;
         nifir(i,(((roundsr(i,2)-1)*27)+(27-num_of_stopsr(i)-stopsrwhen(i)):((roundsr(i,2)-1)*27)+(27-stopsrwhen(i)))) = 1;
         
         if roundsr(i,3) == 1
            
             if mod(roundsr(i,2) - roundsr(i,1),2) == 0
                 s = (roundsr(i,2) - roundsr(i,1))/2;
             elseif mod(roundsr(i,2) - roundsr(i,1),2) == 1
                 s = (roundsr(i,2) - roundsr(i,1) + 1)/2;
             end
             
             nifir(i,((roundsr(i,1) + s)*27+stopsrwhen(i):(roundsr(i,1) + s)*27+stopsrwhen(i)+num_of_stopsr(i)-1)) = 1;
             nifir(i,(((roundsr(i,1)+s-1)*27)+(27-num_of_stopsr(i)-stopsrwhen(i)):((roundsr(i,1)+s-1)*27)+(27-stopsrwhen(i)))) = 1;
         end
             
             
        break
        end
    end
end

ormatrix = [nifi;nifir];
A = ormatrix(randperm(250),:);

%The matrix A consists of 250 people, with 70% starting work at 9:00, and
%the rest starting at a random time. All employees that work 8 or more hrs,
%take luch at some point and use PT.

%All employees in A make it back home using the same PT.



