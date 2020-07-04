import ./make-test-python.nix ({ pkgs, lib, ... }:

with lib;

{
  name = "xautolock";
  meta.maintainers = with pkgs.stdenv.lib.maintainers; [ ma27 ];

  nodes.machine = {
    imports = [ ./common/x11.nix ./common/user-account.nix ];

    test-support.displayManager.auto.user = "bob";
    services.xserver.xautolock.enable = true;
    services.xserver.xautolock.time = 1;
  };

  testScript = ''
    machine.start()
    machine.wait_for_x()
    machine.fail("pgrep xlock")
    machine.sleep(120)
    machine.succeed("pgrep xlock")
  '';
})
