import ./make-test-python.nix ({ pkgs, lib, ... }:

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
    def perform_xsslock_test(machine, lockCmd):
        machine.start()
        machine.wait_for_x()
        machine.wait_for_unit("xss-lock.service", "alice")
        machine.fail(f"pgrep {lockCmd}")
        machine.succeed("su -l alice -c 'xset dpms force standby'")
        machine.wait_until_succeeds(f"pgrep {lockCmd}")


    with subtest("simple"):
        perform_xsslock_test(simple, "i3lock")

    with subtest("custom_cmd"):
        perform_xsslock_test(custom_lockcmd, "xlock")
  '';
})
