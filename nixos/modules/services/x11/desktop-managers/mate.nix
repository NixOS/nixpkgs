{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let

  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.mate;

in

{
  options = {

    services.xserver.desktopManager.mate = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the MATE desktop environment";
      };

      debug = lib.mkEnableOption "mate-session debug messages";

      extraPanelApplets = lib.mkOption {
        default = [ ];
        example = lib.literalExpression "with pkgs.mate; [ mate-applets ]";
        type = lib.types.listOf lib.types.package;
        description = "Extra applets to add to mate-panel.";
      };

      extraCajaExtensions = lib.mkOption {
        default = [ ];
        example = lib.literalExpression "with pkgs.mate; [ caja-extensions ]";
        type = lib.types.listOf lib.types.package;
        description = "Extra extensions to add to caja.";
      };

      enableWaylandSession = lib.mkEnableOption "MATE Wayland session";
    };

    environment.mate.excludePackages = lib.mkOption {
      default = [ ];
      example = lib.literalExpression "[ pkgs.mate.mate-terminal pkgs.mate.pluma ]";
      type = lib.types.listOf lib.types.package;
      description = "Which MATE packages to exclude from the default environment";
    };

  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.enable || cfg.enableWaylandSession) {
      services.displayManager.sessionPackages = [
        pkgs.mate.mate-session-manager
      ];

      # Debugging
      environment.sessionVariables.MATE_SESSION_DEBUG = lib.mkIf cfg.debug "1";

      environment.systemPackages = utils.removePackagesByName (
        pkgs.mate.basePackages
        ++ pkgs.mate.extraPackages
        ++ [
          (pkgs.mate.caja-with-extensions.override {
            extensions = cfg.extraCajaExtensions;
          })
          (pkgs.mate.mate-panel-with-applets.override {
            applets = cfg.extraPanelApplets;
          })
          pkgs.desktop-file-utils
          pkgs.glib
          pkgs.gtk3.out
          pkgs.shared-mime-info
          pkgs.xdg-user-dirs # Update user dirs as described in https://freedesktop.org/wiki/Software/xdg-user-dirs/
          pkgs.yelp # for 'Contents' in 'Help' menus
        ]
      ) config.environment.mate.excludePackages;

      programs.dconf.enable = true;
      # Shell integration for VTE terminals
      programs.bash.vteIntegration = lib.mkDefault true;
      programs.zsh.vteIntegration = lib.mkDefault true;

      # Mate uses this for printing
      programs.system-config-printer.enable = (
        lib.mkIf config.services.printing.enable (lib.mkDefault true)
      );

      services.gnome.at-spi2-core.enable = true;
      services.gnome.glib-networking.enable = true;
      services.gnome.gnome-keyring.enable = true;
      services.udev.packages = [ pkgs.mate.mate-settings-daemon ];
      services.gvfs.enable = true;
      services.upower.enable = config.powerManagement.enable;
      services.libinput.enable = lib.mkDefault true;

      security.pam.services.mate-screensaver.unixAuth = true;

      xdg.portal.configPackages = lib.mkDefault [ pkgs.mate.mate-desktop ];

      environment.pathsToLink = [ "/share" ];
    })
    (lib.mkIf cfg.enableWaylandSession {
      programs.wayfire.enable = true;
      programs.wayfire.plugins = [ pkgs.wayfirePlugins.firedecor ];

      environment.sessionVariables.NIX_GSETTINGS_OVERRIDES_DIR = "${pkgs.mate.mate-gsettings-overrides}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas";

      environment.systemPackages = [ pkgs.mate.mate-wayland-session ];
      services.displayManager.sessionPackages = [ pkgs.mate.mate-wayland-session ];
    })
  ];
}
