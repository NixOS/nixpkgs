{
  lib,
  pkgs,
  ...
}:
let
  mainPort = 9445;
  webPort = 9446;
in
{
  name = "meshtasticd";
  meta.maintainers = [ lib.maintainers.drupol ];

  nodes.machine = {
    services.meshtasticd = {
      enable = true;
      port = mainPort;

      settings = {
        Lora = {
          Module = "sim";
          DIO2_AS_RF_SWITCH = false;
          spiSpeed = "2000000";
        };
        Webserver = {
          Port = webPort;
          RootPath = pkgs.meshtastic-web;
        };
        General = {
          MaxNodes = 200;
          MaxMessageQueue = 100;
          MACAddressSource = "eth0";
        };
      };
    };
  };

  testScript = ''
    with subtest("Test meshtasticd service"):
      machine.wait_for_unit("meshtasticd.service")
      machine.wait_for_open_port(${toString mainPort})
      machine.wait_for_open_port(${toString webPort})
      machine.succeed("curl -fvvv -Ls http://localhost:${toString webPort} | grep -q 'Meshtastic Web Client'")
  '';
}
