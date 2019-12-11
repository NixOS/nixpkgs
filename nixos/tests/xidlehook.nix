import ./make-test-python.nix ({ pkgs, lib, ... }:

with lib;

{
  name = "xidlehook";
  meta.maintainers = with pkgs.stdenv.lib.maintainers; [ chkno ];

  nodes.machine = {
    imports = [ ./common/x11.nix ./common/user-account.nix ];

    services.xserver.displayManager.auto.user = "bob";
    services.xserver.xidlehook.enable = true;
    services.xserver.xidlehook.time = 1;
  };

  testScript = ''
    machine.start()
    machine.wait_for_x()
    machine.fail("pgrep xlock")
    machine.sleep(120)
    machine.succeed("pgrep xlock")
  '';
})
