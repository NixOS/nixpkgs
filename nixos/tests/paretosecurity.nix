{ lib, ... }:
{
  name = "paretosecurity";
  meta.maintainers = [ lib.maintainers.zupo ];

  nodes.terminal =
    { pkgs, ... }:
    {
      imports = [ ./common/user-account.nix ];

      services.paretosecurity.enable = true;
      services.paretosecurity.users.alice.inviteId = "test-invite-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
    };

  nodes.xfce =
    { pkgs, ... }:
    {
      imports = [ ./common/user-account.nix ];

      services.paretosecurity.enable = true;

      services.xserver.enable = true;
      services.xserver.displayManager.lightdm.enable = true;
      services.xserver.desktopManager.xfce.enable = true;

      services.displayManager.autoLogin = {
        enable = true;
        user = "alice";

      };

      virtualisation.resolution = {
        x = 640;
        y = 480;
      };

      environment.systemPackages = [ pkgs.xdotool ];
      environment.variables.XAUTHORITY = "/home/alice/.Xauthority";
    };

  enableOCR = true;

  testScript = ''
    # Test setup
    terminal.succeed("su - alice -c 'mkdir -p /home/alice/.config'")
    terminal.systemctl("start network-online.target")
    terminal.wait_for_unit("network-online.target")

    with subtest("Test the systemd socket is installed & enabled"):
      terminal.succeed('systemctl is-enabled paretosecurity.socket')

    with subtest("Test running checks"):
      terminal.succeed(
        "su - alice -c 'paretosecurity check"
        # Disable some checks that need intricate test setup so that this test
        # remains simple and fast. Tests for all checks and edge cases available
        # at https://github.com/ParetoSecurity/agent/tree/main/test/integration
        + " --skip c96524f2-850b-4bb9-abc7-517051b6c14e"  # SecureBoot
        + " --skip 37dee029-605b-4aab-96b9-5438e5aa44d8"  # Screen lock
        + " --skip 21830a4e-84f1-48fe-9c5b-beab436b2cdb"  # Disk encryption
        + " --skip 44e4754a-0b42-4964-9cc2-b88b2023cb1e"  # Pareto Security is up to date
        + " --skip f962c423-fdf5-428a-a57a-827abc9b253e"  # Password manager installed
        + "'"
      )

    with subtest("Test linking to Pareto Cloud"):
      # The linking service will fail because there is no Internet,
      # but we can check that it tried
      terminal.succeed('systemctl list-units --type=service | grep paretosecurity-link-alice')
      terminal.succeed('journalctl -u paretosecurity-link-alice.service | grep "Linking device to Pareto Cloud for user alice"')

    with subtest("Test 3: Test the tray icon"):
      xfce.wait_for_x()
      for unit in [
          'paretosecurity-trayicon',
          'paretosecurity-user',
          'paretosecurity-user.timer'
      ]:
          status, out = xfce.systemctl("is-enabled " + unit, "alice")
          assert status == 0, f"Unit {unit} is not enabled (status: {status}): {out}"
      xfce.succeed("xdotool mousemove 460 10")
      xfce.wait_for_text("Pareto Security")
      xfce.succeed("xdotool click 1")
      xfce.wait_for_text("Run Checks")

    with subtest("Test 4: Desktop entry"):
      xfce.succeed("xdotool mousemove 10 10")
      xfce.succeed("xdotool click 1")  # hide the tray icon window
      xfce.succeed("xdotool click 1")  # show the Applications menu
      xfce.succeed("xdotool mousemove 10 200")
      xfce.succeed("xdotool click 1")
      xfce.wait_for_text("Pareto Security")

    with subtest("Test 5: paretosecurity:// URL handler is registered"):
      xfce.succeed("su - alice -c 'xdg-open paretosecurity://foo'")
  '';
}
