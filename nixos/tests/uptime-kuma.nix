import ./make-test-python.nix ({ lib, ... }:

<<<<<<< HEAD
{
  name = "uptime-kuma";
  meta.maintainers = with lib.maintainers; [ julienmalka ];
=======
with lib;

{
  name = "uptime-kuma";
  meta.maintainers = with maintainers; [ julienmalka ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nodes.machine =
    { pkgs, ... }:
    { services.uptime-kuma.enable = true; };

  testScript = ''
    machine.start()
    machine.wait_for_unit("uptime-kuma.service")
    machine.wait_for_open_port(3001)
    machine.succeed("curl --fail http://localhost:3001/")
  '';
})
