{ config, lib, pkgs, utils, ... }:

with lib;

let

  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.mate;

in

{
  options = {

    services.xserver.desktopManager.mate = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Enable the MATE desktop environment";
      };

      debug = mkEnableOption (lib.mdDoc "mate-session debug messages");
    };

    environment.mate.excludePackages = mkOption {
      default = [];
      example = literalExpression "[ pkgs.mate.mate-terminal pkgs.mate.pluma ]";
      type = types.listOf types.package;
      description = lib.mdDoc "Which MATE packages to exclude from the default environment";
    };

  };

  config = mkIf cfg.enable {

    services.xserver.displayManager.sessionPackages = [
      pkgs.mate.mate-session-manager
    ];

    # Let caja find extensions
    environment.sessionVariables.CAJA_EXTENSION_DIRS = [ "${config.system.path}/lib/caja/extensions-2.0" ];

    # Let mate-panel find applets
    environment.sessionVariables."MATE_PANEL_APPLETS_DIR" = "${config.system.path}/share/mate-panel/applets";
    environment.sessionVariables."MATE_PANEL_EXTRA_MODULES" = "${config.system.path}/lib/mate-panel/applets";

    # Debugging
    environment.sessionVariables.MATE_SESSION_DEBUG = mkIf cfg.debug "1";

    environment.systemPackages = utils.removePackagesByName
      (pkgs.mate.basePackages ++
      pkgs.mate.extraPackages ++
      [
        pkgs.desktop-file-utils
        pkgs.glib
        pkgs.gtk3.out
        pkgs.shared-mime-info
        pkgs.xdg-user-dirs # Update user dirs as described in https://freedesktop.org/wiki/Software/xdg-user-dirs/
        pkgs.yelp # for 'Contents' in 'Help' menus
      ])
      config.environment.mate.excludePackages;

    programs.dconf.enable = true;
    # Shell integration for VTE terminals
    programs.bash.vteIntegration = mkDefault true;
    programs.zsh.vteIntegration = mkDefault true;

    # Mate uses this for printing
    programs.system-config-printer.enable = (mkIf config.services.printing.enable (mkDefault true));

    services.gnome.at-spi2-core.enable = true;
    services.gnome.gnome-keyring.enable = true;
    services.udev.packages = [ pkgs.mate.mate-settings-daemon ];
    services.gvfs.enable = true;
    services.upower.enable = config.powerManagement.enable;
    services.xserver.libinput.enable = mkDefault true;

    security.pam.services.mate-screensaver.unixAuth = true;

    environment.pathsToLink = [ "/share" ];
  };

}
