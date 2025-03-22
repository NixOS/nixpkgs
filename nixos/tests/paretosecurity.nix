{ lib, ... }:
{
  name = "paretosecurity";
  meta.maintainers = [ lib.maintainers.zupo ];

  nodes.terminal =
    { config, pkgs, ... }:
    {
      imports = [ ./common/user-account.nix ];

      services.paretosecurity.enable = true;
    };

  nodes.xfce =
    { config, pkgs, ... }:
    {
      imports = [ ./common/user-account.nix ];

      services.paretosecurity = {
        enable = true;
        trayIcon = true;
      };

      services.xserver.enable = true;
      services.xserver.displayManager.lightdm.enable = true;
      services.xserver.desktopManager.xfce.enable = true;

      services.displayManager.autoLogin = {
        enable = true;
        user = "alice";
      };

      environment.systemPackages = [ pkgs.xdotool ];
      environment.variables.XAUTHORITY = "/home/alice/.Xauthority";

    };

  enableOCR = true;

  testScript = ''
    terminal.succeed(
      "su -- alice -c 'paretosecurity check"
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

    xfce.wait_for_x()
    xfce.succeed("xdotool mousemove 850 10")
    xfce.wait_for_text("Pareto Security")
    xfce.succeed("xdotool click 1")
    xfce.wait_for_text("Run Checks")
  '';
}
