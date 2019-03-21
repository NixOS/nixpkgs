import ./make-test.nix ({ pkgs, lib, ... }:

with lib;

{
  name = "xss-lock";
  meta.maintainers = with pkgs.stdenv.lib.maintainers; [ ma27 ];

  machine = {
    imports = [ ./common/x11.nix ./common/user-account.nix ];
    programs.xss-lock.enable = true;
    services.xserver.displayManager.auto.user = "alice";
  };

  testScript = ''
    $machine->start;
    $machine->waitForX;
    $machine->waitForUnit("xss-lock.service", "alice");

    $machine->fail("pgrep xlock");
    $machine->succeed("su -l alice -c 'xset dpms force standby'");
    $machine->waitUntilSucceeds("pgrep i3lock");
  '';
})
