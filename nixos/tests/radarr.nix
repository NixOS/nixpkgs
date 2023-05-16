import ./make-test-python.nix ({ lib, ... }:

<<<<<<< HEAD
{
  name = "radarr";
  meta.maintainers = with lib.maintainers; [ etu ];
=======
with lib;

{
  name = "radarr";
  meta.maintainers = with maintainers; [ etu ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nodes.machine =
    { pkgs, ... }:
    { services.radarr.enable = true; };

  testScript = ''
    machine.wait_for_unit("radarr.service")
    machine.wait_for_open_port(7878)
    machine.succeed("curl --fail http://localhost:7878/")
  '';
})
