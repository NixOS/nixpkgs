import ./make-test-python.nix (
  { pkgs, ... }:

  {
    name = "plasma5";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ ttuegel ];
    };

    nodes.machine =
      { ... }:

      {
        imports = [ ./common/user-account.nix ];
        services.xserver.enable = true;
        services.displayManager.sddm.enable = true;
        services.displayManager.defaultSession = "plasma";
        services.xserver.desktopManager.plasma5.enable = true;
        environment.plasma5.excludePackages = [ pkgs.plasma5Packages.elisa ];
        services.displayManager.autoLogin = {
          enable = true;
          user = "alice";
        };
      };

    testScript =
      { nodes, ... }:
      let
        user = nodes.machine.users.users.alice;
        xdo = "${pkgs.xdotool}/bin/xdotool";
      in
      ''
        with subtest("Wait for login"):
            start_all()
            machine.wait_for_file("/tmp/xauth_*")
            machine.succeed("xauth merge /tmp/xauth_*")

        with subtest("Check plasmashell started"):
            machine.wait_until_succeeds("pgrep plasmashell")
            machine.wait_for_window("^Desktop ")

        with subtest("Check that KDED is running"):
            machine.succeed("pgrep kded5")

        with subtest("Check that logging in has given the user ownership of devices"):
            machine.succeed("getfacl -p /dev/snd/timer | grep -q ${user.name}")

        with subtest("Ensure Elisa is not installed"):
            machine.fail("which elisa")

        machine.succeed("su - ${user.name} -c 'xauth merge /tmp/xauth_*'")

        with subtest("Run Dolphin"):
            machine.execute("su - ${user.name} -c 'DISPLAY=:0.0 dolphin >&2 &'")
            machine.wait_for_window(" Dolphin")

        with subtest("Run Konsole"):
            machine.execute("su - ${user.name} -c 'DISPLAY=:0.0 konsole >&2 &'")
            machine.wait_for_window("Konsole")

        with subtest("Run systemsettings"):
            machine.execute("su - ${user.name} -c 'DISPLAY=:0.0 systemsettings5 >&2 &'")
            machine.wait_for_window("Settings")

        with subtest("Wait to get a screenshot"):
            machine.execute(
                "${xdo} key Alt+F1 sleep 10"
            )
            machine.screenshot("screen")
      '';
  }
)
