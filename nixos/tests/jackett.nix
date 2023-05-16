import ./make-test-python.nix ({ lib, ... }:

<<<<<<< HEAD
{
  name = "jackett";
  meta.maintainers = with lib.maintainers; [ etu ];
=======
with lib;

{
  name = "jackett";
  meta.maintainers = with maintainers; [ etu ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nodes.machine =
    { pkgs, ... }:
    { services.jackett.enable = true; };

  testScript = ''
    machine.start()
    machine.wait_for_unit("jackett.service")
    machine.wait_for_open_port(9117)
    machine.succeed("curl --fail http://localhost:9117/")
  '';
})
