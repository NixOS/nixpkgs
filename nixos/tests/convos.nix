import ./make-test-python.nix ({ lib, pkgs, ... }:

with lib;
let
  port = 3333;
in
{
  name = "convos";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ sgo ];
  };

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
    machine.succeed("journalctl -u convos | grep -q 'application available at.*${toString port}'")
    machine.succeed("curl -f http://localhost:${toString port}/")
  '';
})
