import ./make-test-python.nix ({ lib, ... }:

<<<<<<< HEAD
{
  name = "fluidd";
  meta.maintainers = with lib.maintainers; [ vtuan10 ];
=======
with lib;

{
  name = "fluidd";
  meta.maintainers = with maintainers; [ vtuan10 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nodes.machine = { pkgs, ... }: {
    services.fluidd = {
      enable = true;
    };
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("nginx.service")
    machine.wait_for_open_port(80)
    machine.succeed("curl -sSfL http://localhost/ | grep 'fluidd'")
  '';
})
