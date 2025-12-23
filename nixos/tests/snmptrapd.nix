{ pkgs, lib, ... }:
{
  name = "snmptrapd";

  nodes.snmptrapd = {
    environment.systemPackages = with pkgs; [
      net-snmp
    ];

    services.snmptrapd.enable = true;
  };

  testScript = ''
    start_all();
    machine.wait_for_unit("snmptrapd.service")

    machine.succeed("snmptrap -v 2c -c public localhost \'\' 1.3.6.1.4.1.8072.2.3.0.1 1.3.6.1.2.1.1.6.0 s 'Just here'");
    machine.wait_until_succeeds("journalctl -u snmptrapd -n 200 -o cat | grep -F 'Just here'");
  '';

}
