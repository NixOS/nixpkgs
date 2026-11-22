{ pkgs, lib, ... }:
let
  port = 6000;
in
{
  name = "ddns-updater";

  meta.maintainers = with lib.maintainers; [ delliott ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.ddns-updater = {
        enable = true;
        environment = {
          LISTENING_ADDRESS = ":" + (toString port);
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("ddns-updater.service")
    machine.wait_for_open_port(${toString port})
    machine.succeed("curl --fail http://localhost:${toString port}/")
  '';
}
