{ lib, ... }:
let
  port = 6000;
in
{
  name = "gokapi";

  meta.maintainers = with lib.maintainers; [ delliott ];

  nodes.machine = {
    services.gokapi = {
      enable = true;
      environment.GOKAPI_PORT = port;
    };
  };

  testScript = ''
    machine.wait_for_unit("gokapi.service")
    machine.wait_for_open_port(${toString port})
    machine.succeed("curl --fail http://localhost:${toString port}/")
  '';
}
