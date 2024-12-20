import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "snmpd";

    nodes.snmpd = {
      environment.systemPackages = with pkgs; [
        net-snmp
      ];

      services.snmpd = {
        enable = true;
        configText = ''
          rocommunity public
        '';
      };
    };

    testScript = ''
      start_all();
      machine.wait_for_unit("snmpd.service")
      machine.succeed("snmpwalk -v 2c -c public localhost | grep SNMPv2-MIB::sysName.0");
    '';

  }
)
