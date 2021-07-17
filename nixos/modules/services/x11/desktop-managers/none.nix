{ config, lib, pkgs, ... }:
with lib;
let
  runXdgAutostart = config.services.xserver.desktopManager.runXdgAutostartIfNone;
in
{
  options = {
    services.xserver.desktopManager.runXdgAutostartIfNone = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to run XDG autostart files for session without desktop manager
        (with only window manager), which usually doesn't handle them by
        default.

        Some services like <option>i18n.inputMethod</option> and
        <option>service.earlyoom</option> use XDG autostart files to start.
        If this option is set to <literal>false</literal> and you are using
        window manager without desktop manager, you need to manually start
        them or running <package>dex</package> somewhere.
      '';
    };
  };

  config = mkMerge [
    {
      services.xserver.desktopManager.session = [
        {
          name = "none";
          start = optionalString runXdgAutostart ''
            /run/current-system/systemd/bin/systemctl --user start xdg-autostart-if-no-desktop-manager.target
          '';
        }
      ];
    }
    (mkIf runXdgAutostart {
      systemd.user.targets.xdg-autostart-if-no-desktop-manager = {
        description = "Run XDG autostart files";
        # From `plasma-workspace`, `share/systemd/user/plasma-workspace@.target`.
        requires = [ "xdg-desktop-autostart.target" "graphical-session.target" ];
        before = [ "xdg-desktop-autostart.target" "graphical-session.target"  ];
        bindsTo = [ "graphical-session.target"  ];
      };
    })
  ];
}
