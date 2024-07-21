{ config, lib, pkgs, ... }:
with lib;
let
  runXdgAutostart = config.services.xserver.desktopManager.runXdgAutostartIfNone;
in
{
  options = {
    services.xserver.desktopManager.runXdgAutostartIfNone = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to run XDG autostart files for sessions without a desktop manager
        (with only a window manager), these sessions usually don't handle XDG
        autostart files by default.

        Some services like {option}`i18n.inputMethod` and
        {option}`service.earlyoom` use XDG autostart files to start.
        If this option is not set to `true` and you are using
        a window manager without a desktop manager, you need to manually start
        them or running `dex` somewhere.
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
        before = [ "xdg-desktop-autostart.target" "graphical-session.target" ];
        bindsTo = [ "graphical-session.target" ];
      };
    })
  ];
}
