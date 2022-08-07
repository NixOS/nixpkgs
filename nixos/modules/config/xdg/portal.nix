{ config, pkgs, lib, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkRenamedOptionModule
    teams
    types;
in

{
  imports = [
    (mkRenamedOptionModule [ "services" "flatpak" "extraPortals" ] [ "xdg" "portal" "extraPortals" ])

    ({ config, lib, options, ... }:
      let
        from = [ "xdg" "portal" "gtkUsePortal" ];
        fromOpt = lib.getAttrFromPath from options;
      in
      {
        warnings = lib.mkIf config.xdg.portal.gtkUsePortal [
          "The option `${lib.showOption from}' defined in ${lib.showFiles fromOpt.files} has been deprecated. Setting the variable globally with `environment.sessionVariables' NixOS option can have unforseen side-effects."
        ];
      }
    )
  ];

  meta = {
    maintainers = teams.freedesktop.members;
  };

  options.xdg.portal = {
    enable =
      mkEnableOption ''<link xlink:href="https://github.com/flatpak/xdg-desktop-portal">xdg desktop integration</link>'' // {
        default = false;
      };

    extraPortals = mkOption {
      type = types.listOf types.package;
      default = [ ];
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
      visible = false;
      default = false;
      description = ''
        Sets environment variable <literal>GTK_USE_PORTAL</literal> to <literal>1</literal>.
        This will force GTK-based programs ran outside Flatpak to respect and use XDG Desktop Portals
        for features like file chooser but it is an unsupported hack that can easily break things.
        Defaults to <literal>false</literal> to respect its opt-in nature.
      '';
    };
  };

  config =
    let
      cfg = config.xdg.portal;
      packages = [ pkgs.xdg-desktop-portal ] ++ cfg.extraPortals;
      joinedPortals = pkgs.buildEnv {
        name = "xdg-portals";
        paths = packages;
        pathsToLink = [ "/share/xdg-desktop-portal/portals" "/share/applications" ];
      };

    in
    mkIf cfg.enable {

      assertions = [
        {
          assertion = cfg.extraPortals != [ ];
          message = "Setting xdg.portal.enable to true requires a portal implementation in xdg.portal.extraPortals such as xdg-desktop-portal-gtk or xdg-desktop-portal-kde.";
        }
      ];

      services.dbus.packages = packages;
      systemd.packages = packages;

      environment = {
        # fixes screen sharing on plasmawayland on non-chromium apps by linking
        # share/applications/*.desktop files
        # see https://github.com/NixOS/nixpkgs/issues/145174
        systemPackages = [ joinedPortals ];
        pathsToLink = [ "/share/applications" ];

        sessionVariables = {
          GTK_USE_PORTAL = mkIf cfg.gtkUsePortal "1";
          XDG_DESKTOP_PORTAL_DIR = "${joinedPortals}/share/xdg-desktop-portal/portals";
        };
      };
    };
}
