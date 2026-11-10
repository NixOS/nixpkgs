{ lib, pkgs, ... }:

let
  port = 3333;
in
{
  name = "convos";
  meta.maintainers = with lib.maintainers; [ sgo ];

  nodes = {
    machine =
      { pkgs, ... }:
      {
        services.convos = {
          enable = true;
          listenPort = port;
        };
      };
  };

  testScript = ''
    machine.wait_for_unit("convos")
    machine.wait_for_open_port(${toString port})
    machine.succeed("curl -f http://localhost:${toString port}/")
  '';
}
