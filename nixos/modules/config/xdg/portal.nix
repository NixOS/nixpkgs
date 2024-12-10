{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkRenamedOptionModule
    teams
    types
    ;

  associationOptions =
    with types;
    attrsOf (coercedTo (either (listOf str) str) (x: lib.concatStringsSep ";" (lib.toList x)) str);
in

{
  imports = [
    (mkRenamedOptionModule [ "services" "flatpak" "extraPortals" ] [ "xdg" "portal" "extraPortals" ])

    (
      {
        config,
        lib,
        options,
        ...
      }:
      let
        from = [
          "xdg"
          "portal"
          "gtkUsePortal"
        ];
        fromOpt = lib.getAttrFromPath from options;
      in
      {
        warnings = lib.mkIf config.xdg.portal.gtkUsePortal [
          "The option `${lib.showOption from}' defined in ${lib.showFiles fromOpt.files} has been deprecated. Setting the variable globally with `environment.sessionVariables' NixOS option can have unforeseen side-effects."
        ];
      }
    )
  ];

  meta = {
    maintainers = teams.freedesktop.members;
  };

  options.xdg.portal = {
    enable =
      mkEnableOption ''[xdg desktop integration](https://github.com/flatpak/xdg-desktop-portal)''
      // {
        default = false;
      };

    extraPortals = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = ''
        List of additional portals to add to path. Portals allow interaction
        with system, like choosing files or taking screenshots. At minimum,
        a desktop portal implementation should be listed. GNOME and KDE already
        adds `xdg-desktop-portal-gtk`; and
        `xdg-desktop-portal-kde` respectively. On other desktop
        environments you probably want to add them yourself.
      '';
    };

    gtkUsePortal = mkOption {
      type = types.bool;
      visible = false;
      default = false;
      description = ''
        Sets environment variable `GTK_USE_PORTAL` to `1`.
        This will force GTK-based programs ran outside Flatpak to respect and use XDG Desktop Portals
        for features like file chooser but it is an unsupported hack that can easily break things.
        Defaults to `false` to respect its opt-in nature.
      '';
    };

    xdgOpenUsePortal = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Sets environment variable `NIXOS_XDG_OPEN_USE_PORTAL` to `1`
        This will make `xdg-open` use the portal to open programs, which resolves bugs involving
        programs opening inside FHS envs or with unexpected env vars set from wrappers.
        See [#160923](https://github.com/NixOS/nixpkgs/issues/160923) for more info.
      '';
    };

    config = mkOption {
      type = types.attrsOf associationOptions;
      default = { };
      example = {
        x-cinnamon = {
          default = [
            "xapp"
            "gtk"
          ];
        };
        pantheon = {
          default = [
            "pantheon"
            "gtk"
          ];
          "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
        };
        common = {
          default = [ "gtk" ];
        };
      };
      description = ''
        Sets which portal backend should be used to provide the implementation
        for the requested interface. For details check {manpage}`portals.conf(5)`.

        Configs will be linked to `/etc/xdg/xdg-desktop-portal/` with the name `$desktop-portals.conf`
        for `xdg.portal.config.$desktop` and `portals.conf` for `xdg.portal.config.common`
        as an exception.
      '';
    };

    configPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      example = lib.literalExpression "[ pkgs.gnome.gnome-session ]";
      description = ''
        List of packages that provide XDG desktop portal configuration, usually in
        the form of `share/xdg-desktop-portal/$desktop-portals.conf`.

        Note that configs in `xdg.portal.config` will be preferred if set.
      '';
    };
  };

  config =
    let
      cfg = config.xdg.portal;
      packages = [ pkgs.xdg-desktop-portal ] ++ cfg.extraPortals;
    in
    mkIf cfg.enable {
      warnings = lib.optional (cfg.configPackages == [ ] && cfg.config == { }) ''
        xdg-desktop-portal 1.17 reworked how portal implementations are loaded, you
        should either set `xdg.portal.config` or `xdg.portal.configPackages`
        to specify which portal backend to use for the requested interface.

        https://github.com/flatpak/xdg-desktop-portal/blob/1.18.1/doc/portals.conf.rst.in

        If you simply want to keep the behaviour in < 1.17, which uses the first
        portal implementation found in lexicographical order, use the following:

        xdg.portal.config.common.default = "*";
      '';

      assertions = [
        {
          assertion = cfg.extraPortals != [ ];
          message = "Setting xdg.portal.enable to true requires a portal implementation in xdg.portal.extraPortals such as xdg-desktop-portal-gtk or xdg-desktop-portal-kde.";
        }
      ];

      services.dbus.packages = packages;
      systemd.packages = packages;

      environment = {
        systemPackages = packages ++ cfg.configPackages;
        pathsToLink = [
          # Portal definitions and upstream desktop environment portal configurations.
          "/share/xdg-desktop-portal"
          # .desktop files to register fallback icon and app name.
          "/share/applications"
        ];

        sessionVariables = {
          GTK_USE_PORTAL = mkIf cfg.gtkUsePortal "1";
          NIXOS_XDG_OPEN_USE_PORTAL = mkIf cfg.xdgOpenUsePortal "1";
          NIX_XDG_DESKTOP_PORTAL_DIR = "/run/current-system/sw/share/xdg-desktop-portal/portals";
        };

        etc = lib.concatMapAttrs (
          desktop: conf:
          lib.optionalAttrs (conf != { }) {
            "xdg/xdg-desktop-portal/${
              lib.optionalString (desktop != "common") "${desktop}-"
            }portals.conf".text =
              lib.generators.toINI { } { preferred = conf; };
          }
        ) cfg.config;
      };
    };
}
