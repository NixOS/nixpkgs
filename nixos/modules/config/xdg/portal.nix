{ config, pkgs ,lib ,... }:

with lib;

{
  imports = [
    (mkRenamedOptionModule [ "services" "flatpak" "extraPortals" ] [ "xdg" "portal" "extraPortals" ])
  ];

  options.xdg.portal = {
    enable =
      mkEnableOption "<link xlink:href='https://github.com/flatpak/xdg-desktop-portal'>xdg desktop integration</link>"//{
        default = false;
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

    gtkUsePortal = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Sets environment variable <literal>GTK_USE_PORTAL</literal> to <literal>1</literal>.
        This is needed for packages ran outside Flatpak to respect and use XDG Desktop Portals.
        For example, you'd need to set this for non-flatpak Firefox to use native filechoosers.
        Defaults to <literal>false</literal> to respect its opt-in nature.
      '';
    };
  };

  config =
    let
      cfg = config.xdg.portal;
      packages = [ pkgs.xdg-desktop-portal ] ++ cfg.extraPortals;

    in mkIf cfg.enable {

      assertions = [
        { assertion = (cfg.gtkUsePortal -> cfg.extraPortals != []);
          message = "Setting xdg.portal.gtkUsePortal to true requires a portal implementation in xdg.portal.extraPortals such as xdg-desktop-portal-gtk or xdg-desktop-portal-kde.";
        }
      ];

      services.dbus.packages  = packages;
      systemd.packages = packages;

      environment.variables = {
        GTK_USE_PORTAL = mkIf cfg.gtkUsePortal "1";
        XDG_DESKTOP_PORTAL_PATH = map (p: "${p}/share/xdg-desktop-portal/portals") cfg.extraPortals;
      };
    };
}
