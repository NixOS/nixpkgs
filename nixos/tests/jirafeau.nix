import ./make-test-python.nix ({ lib, ... }:

<<<<<<< HEAD
{
  name = "jirafeau";
  meta.maintainers = with lib.maintainers; [ davidtwco ];
=======
with lib;

{
  name = "jirafeau";
  meta.maintainers = with maintainers; [ davidtwco ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nodes.machine = { pkgs, ... }: {
    services.jirafeau = {
      enable = true;
    };
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("phpfpm-jirafeau.service")
    machine.wait_for_unit("nginx.service")
    machine.wait_for_open_port(80)
    machine.succeed("curl -sSfL http://localhost/ | grep 'Jirafeau'")
  '';
})
