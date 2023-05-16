import ./make-test-python.nix ({ lib, ... }:

<<<<<<< HEAD
=======
with lib;

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
let
  port = 42069;
in
{
  name = "bazarr";
<<<<<<< HEAD
  meta.maintainers = with lib.maintainers; [ d-xo ];
=======
  meta.maintainers = with maintainers; [ d-xo ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nodes.machine =
    { pkgs, ... }:
    {
      services.bazarr = {
        enable = true;
        listenPort = port;
      };
    };

  testScript = ''
    machine.wait_for_unit("bazarr.service")
    machine.wait_for_open_port(${toString port})
    machine.succeed("curl --fail http://localhost:${toString port}/")
  '';
})
