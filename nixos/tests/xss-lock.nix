import ./make-test.nix ({ pkgs, lib, ... }:

with lib;

{
  name = "xss-lock";
  meta.maintainers = with pkgs.stdenv.lib.maintainers; [ ma27 ];

  nodes = {
    simple = {
      imports = [ ./common/x11.nix ./common/user-account.nix ];
      programs.xss-lock.enable = true;
      services.xserver.displayManager.auto.user = "alice";
    };

    custom_lockcmd = { pkgs, ... }: {
      imports = [ ./common/x11.nix ./common/user-account.nix ];
      services.xserver.displayManager.auto.user = "alice";

      programs.xss-lock = {
        enable = true;
        extraOptions = [ "-n" "${pkgs.libnotify}/bin/notify-send 'About to sleep!'"];
        lockerCommand = "${pkgs.xlockmore}/bin/xlock -mode ant";
      };
    };
  };

  testScript = ''
    startAll;

    ${concatStringsSep "\n" (mapAttrsToList (name: lockCmd: ''
      ${"$"+name}->start;
      ${"$"+name}->waitForX;
      ${"$"+name}->waitForUnit("xss-lock.service", "alice");
      ${"$"+name}->fail("pgrep ${lockCmd}");
      ${"$"+name}->succeed("su -l alice -c 'xset dpms force standby'");
      ${"$"+name}->waitUntilSucceeds("pgrep ${lockCmd}");
    '') { simple = "i3lock"; custom_lockcmd = "xlock"; })}
  '';
})
