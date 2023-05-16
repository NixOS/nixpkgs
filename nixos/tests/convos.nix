import ./make-test-python.nix ({ lib, pkgs, ... }:

<<<<<<< HEAD

=======
with lib;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
let
  port = 3333;
in
{
  name = "convos";
<<<<<<< HEAD
  meta.maintainers = with lib.maintainers; [ sgo ];
=======
  meta = with pkgs.lib.maintainers; {
    maintainers = [ sgo ];
  };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
