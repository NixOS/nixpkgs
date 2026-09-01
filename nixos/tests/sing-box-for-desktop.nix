{ lib, ... }:

{
  name = "sing-box-for-desktop";

  meta.maintainers = with lib.maintainers; [ snemeow ];

  nodes.machine = {
    programs.sing-box-for-desktop = {
      enable = true;

      settings = {
        startAtLogin = true;
        tray = {
          enable = false;
          keepInBackground = false;
        };
        language = "zh-Hans";
        appearance = "dark";
        theme = "#112233";
        terminal = {
          lightTheme = "";
          darkTheme = "Afterglow";
          lightCustomTheme = {
            background = "#ffffff";
            foreground = "#111111";
          };
          darkCustomTheme = {
            background = "#111111";
            foreground = "#eeeeee";
          };
          fontFamily = "Iosevka";
          fontSize = 15;
          alwaysShowSymbolBar = true;
        };
        core.disableDeprecatedWarnings = true;
      };

      profiles = [
        {
          name = "Default";
          configurationPath = "/run/secrets/sing-box.json";
        }
      ];
      defaultProfile = "Default";
    };
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.wait_for_unit("sing-box-daemon.service")
    machine.succeed("test -S /run/sing-box-daemon/sing-box.socket")
    machine.succeed("test -e /etc/polkit-1/actions/io.nekohasekai.sfl.policy")
    machine.succeed("grep -F -- '--start-at-login' /etc/xdg/autostart/sing-box.desktop")

    wrapper = machine.succeed("readlink -f $(command -v sing-box)").strip()
    machine.succeed(f"grep -F SING_BOX_MANAGED_CONFIGURATION {wrapper}")
    machine.succeed(f"grep -F \"SING_BOX_MANAGED_OPEN_AT_LOGIN='true'\" {wrapper}")
  '';
}
