import ./make-test-python.nix ({ lib, ... }:

<<<<<<< HEAD
{
  name = "lidarr";
  meta.maintainers = with lib.maintainers; [ etu ];
=======
with lib;

{
  name = "lidarr";
  meta.maintainers = with maintainers; [ etu ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nodes.machine =
    { pkgs, ... }:
    { services.lidarr.enable = true; };

  testScript = ''
    start_all()

    machine.wait_for_unit("lidarr.service")
    machine.wait_for_open_port(8686)
    machine.succeed("curl --fail http://localhost:8686/")
  '';
})
