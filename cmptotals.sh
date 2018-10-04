#!/usr/bin/ksh
#This shell compares totals from two tables. If the total are equal, then insert then in a new table.

umask 111
. $HOME/ .bash_profile

# executing the Oracle statement, PL/SQL, ans store the result in a variable

COUNT1 =`sqlplus -silent ${OracleConxInf} << eof
    set feedback off echo off heading off
    
    SELECT sum(total) FROM (
        SELECT COLUMN_A, COLUMN_B, count(*) as total FROM SCHEMA.TABLE_A
        WHERE COLUMN_A = 'YO'
        GROUP BY COLUMN_A, COLUMN_B
        ORDER BY COLUMN_A, COLUMN_B)
    /
    eof`



COUNT2 =`sqlplus -silent ${OracleConxInf} << eof
    set feedback off echo off heading off
    
    SELECT sum(total) FROM (
        SELECT COLUMN_A, COLUMN_B, count(*) as total FROM SCHEMA.TABLE_B
        WHERE COLUMN_A = 'BOY'
        GROUP BY COLUMN_A, COLUMN_B
        ORDER BY COLUMN_A, COLUMN_B)
    /
    eof`



echo count 1 = $COUNT1
echo count 2 = $COUNT2

# comparing numbers, if they are the same, then insert in a new table. (TABLE_C)

if ["$COUNT1" == "COUNT2"]; THEN
    echo "count1 is equal to count2"

    temp=`sqlplus -silent ${OracleConxInf} << eof
    set feedback off echo off heading off
    INSERT INTO SCHEMA.TABLE_C
    (COLUMN_A, COLUMN_B) VALUES (3, 5)
    /
    eof
`
EXIT 0
ELSE
    echo "count1 is not equal to count2"
    EXIT 1
fi