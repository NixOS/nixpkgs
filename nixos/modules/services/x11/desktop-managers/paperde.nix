{ config, lib, pkgs, ... }:

with lib;

let

  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.paperde;

in

{
  options = {

    services.xserver.desktopManager.paperde.enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc "Enable the Paperde desktop manager";
    };

    services.xserver.desktopManager.paperde.apps.enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc "Install all CuboCore packages";
    };

  };


  config = mkIf cfg.enable {

    services.xserver.displayManager.sessionPackages = [
      pkgs.paperde.paper-desktop
    ];

    environment.systemPackages =
      pkgs.paperde.corePackages ++ [
        pkgs.qt5ct
        pkgs.breeze-icons
        pkgs.wayfire
        pkgs.xdg-desktop-portal # runtime
        pkgs.xdg-desktop-portal-kde # runtime
        pkgs.xdg-desktop-portal-gtk # runtime
        pkgs.xdg-desktop-portal-wlr # runtime
      ] ++ lib.optionals config.services.xserver.desktopManager.paperde.apps.enable (
        builtins.attrValues (
          builtins.removeAttrs (pkgs.CuboCore.packages pkgs.CuboCore) [ "libcsys" "libcprime" ]
        )
      );

    environment.sessionVariables.WAYFIRE_CONFIG_FILE = "${pkgs.paperde.paper-desktop}/share/paperde/wayfire.ini";
    environment.sessionVariables.QT_QPA_PLATFORM = "wayland";
    qt.platformTheme = "qt5ct";

    # Link some extra directories in /run/current-system/software/share
    environment.pathsToLink = [
      # FIXME: modules should link subdirs of `/share` rather than relying on this
      "/share"
    ];
  };
}
