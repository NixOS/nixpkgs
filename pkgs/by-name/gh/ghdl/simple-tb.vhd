library ieee;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

library STD;
use STD.textio.all;

entity tb is
end tb;

architecture beh of tb is

component simple
port (
    CLK, RESET : in std_ulogic;
    DATA_OUT : out std_ulogic_vector(7 downto 0);
    DONE_OUT : out std_ulogic
);
end component;

signal data : std_ulogic_vector(7 downto 0) := "00100000";
signal clk : std_ulogic;
signal RESET : std_ulogic := '0';
signal done : std_ulogic := '0';
signal cyclecount : integer := 0;

constant cycle_time_c : time := 200 ms;
constant maxcycles : integer := 100;

begin

simple1 : simple
port map (
    CLK => clk,
    RESET => RESET,
    DATA_OUT => data,
    DONE_OUT => done
);

clk_process : process
begin
    clk <= '0';
    wait for cycle_time_c/2;
    clk <= '1';
    wait for cycle_time_c/2;
end process;

count_process : process(CLK)
begin
    if (CLK'event and CLK ='1') then
    if (RESET = '1') then
        cyclecount <= 0;
    else
        cyclecount <= cyclecount + 1;
    end if;
    end if;
end process;

test : process

begin

RESET <= '1';
wait until (clk'event and clk='1');
wait until (clk'event and clk='1');
RESET <= '0';
wait until (clk'event and clk='1');
for cyclecnt in 1 to maxcycles loop
    exit when done = '1';
    wait until (clk'event and clk='1');
    report integer'image(to_integer(unsigned(data)));
end loop;
wait until (clk'event and clk='1');

report "All tests passed." severity NOTE;
wait;
end process;
end beh;
