import ./make-test-python.nix ({ lib, ... }:

<<<<<<< HEAD
{
  name = "prowlarr";
  meta.maintainers = with lib.maintainers; [ jdreaver ];
=======
with lib;

{
  name = "prowlarr";
  meta.maintainers = with maintainers; [ jdreaver ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nodes.machine =
    { pkgs, ... }:
    { services.prowlarr.enable = true; };

  testScript = ''
    machine.wait_for_unit("prowlarr.service")
    machine.wait_for_open_port(9696)
    machine.succeed("curl --fail http://localhost:9696/")
  '';
})
