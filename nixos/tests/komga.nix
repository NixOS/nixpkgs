import ./make-test-python.nix ({ lib, ... }:

<<<<<<< HEAD
{
  name = "komga";
  meta.maintainers = with lib.maintainers; [ govanify ];
=======
with lib;

{
  name = "komga";
  meta.maintainers = with maintainers; [ govanify ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nodes.machine =
    { pkgs, ... }:
    { services.komga = {
        enable = true;
        port = 1234;
      };
    };

  testScript = ''
    machine.wait_for_unit("komga.service")
    machine.wait_for_open_port(1234)
    machine.succeed("curl --fail http://localhost:1234/")
  '';
})
