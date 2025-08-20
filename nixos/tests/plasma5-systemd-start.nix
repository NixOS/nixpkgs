import ./make-test-python.nix (
  { pkgs, ... }:

  {
    name = "plasma5-systemd-start";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ oxalica ];
    };

    nodes.machine =
      { ... }:

      {
        imports = [ ./common/user-account.nix ];
        services.xserver = {
          enable = true;
          desktopManager.plasma5.enable = true;
          desktopManager.plasma5.runUsingSystemd = true;
        };

        services.displayManager = {
          sddm.enable = true;
          defaultSession = "plasma";
          autoLogin = {
            enable = true;
            user = "alice";
          };
        };
      };

    testScript =
      { nodes, ... }:
      ''
        with subtest("Wait for login"):
            start_all()
            machine.wait_for_file("/tmp/xauth_*")
            machine.succeed("xauth merge /tmp/xauth_*")

        with subtest("Check plasmashell started"):
            machine.wait_until_succeeds("pgrep plasmashell")
            machine.wait_for_window("^Desktop ")

        status, result = machine.systemctl('--no-pager show plasma-plasmashell.service', user='alice')
        assert status == 0, 'Service not found'
        assert 'ActiveState=active' in result.split('\n'), 'Systemd service not active'
      '';
  }
)
