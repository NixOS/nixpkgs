{ config, pkgs ,lib ,... }:
with lib;
{
  options.xdg.portal = {
    enable =
      mkEnableOption "<link xlink:href='https://github.com/flatpak/xdg-desktop-portal'>xdg desktop integration</link>"//{
        default = true;
      };

    extraPortals = mkOption {
      type = types.listOf types.package;
      default = [];
      description = ''
        List of additional portals to add to path. Portals allow interaction
        with system, like choosing files or taking screenshots. At minimum,
        a desktop portal implementation should be listed. GNOME and KDE already
        adds <package>xdg-desktop-portal-gtk</package>; and
        <package>xdg-desktop-portal-kde</package> respectively. On other desktop
        environments you probably want to add them yourself.
      '';
    };
  };

  config =
    let
      cfg = config.xdg.portal;
      packages = [ pkgs.xdg-desktop-portal ] ++ cfg.extraPortals;

    in mkIf cfg.enable {

      services.dbus.packages  = packages;
      systemd.packages = packages;
      environment.variables = {
        GTK_USE_PORTAL = "1";
        XDG_DESKTOP_PORTAL_PATH = map (p: "${p}/share/xdg-desktop-portal/portals") cfg.extraPortals;
      };
    };
}
