library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_MISC.or_reduce;

entity simple is

port (
    CLK, RESET : in std_ulogic;
    DATA_OUT : out std_ulogic_vector(7 downto 0);
    DONE_OUT : out std_ulogic
);
end simple;

architecture beh of simple is

signal data : std_ulogic_vector(7 downto 0);
signal done: std_ulogic;

begin

proc_ctr : process(CLK)
begin
if (CLK = '1' and CLK'event) then
    if (RESET = '1') then
        data <= "01011111";
        done <= '0';
    else
    case data is
        when "00100000" =>  data <= "01001110";
        when "01001110" =>  data <= "01101001";
        when "01101001" =>  data <= "01111000";
        when "01111000" =>  data <= "01001111";
        when "01001111" =>  data <= "01010011";
        when others =>  data <= "00100000";
    end case;
    done <= not or_reduce(data xor "01010011");
    end if;
end if;
end process;

DATA_OUT <= data;
DONE_OUT <= done;

end beh;
