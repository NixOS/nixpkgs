import ./make-test-python.nix ({ lib, ... }:

<<<<<<< HEAD
{
  name = "sonarr";
  meta.maintainers = with lib.maintainers; [ etu ];
=======
with lib;

{
  name = "sonarr";
  meta.maintainers = with maintainers; [ etu ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nodes.machine =
    { pkgs, ... }:
    { services.sonarr.enable = true; };

  testScript = ''
    machine.wait_for_unit("sonarr.service")
    machine.wait_for_open_port(8989)
    machine.succeed("curl --fail http://localhost:8989/")
  '';
})
