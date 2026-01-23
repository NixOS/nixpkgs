{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

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
        description = "Enable the MATE desktop environment";
      };

      debug = mkEnableOption "mate-session debug messages";

      extraPanelApplets = mkOption {
        default = [ ];
        example = literalExpression "with pkgs.mate; [ mate-applets ]";
        type = types.listOf types.package;
        description = "Extra applets to add to mate-panel.";
      };

      extraCajaExtensions = mkOption {
        default = [ ];
        example = lib.literalExpression "with pkgs.mate; [ caja-extensions ]";
        type = types.listOf types.package;
        description = "Extra extensions to add to caja.";
      };

      enableWaylandSession = mkEnableOption "MATE Wayland session";
    };

    environment.mate.excludePackages = mkOption {
      default = [ ];
      example = literalExpression "[ pkgs.mate.mate-terminal pkgs.mate.pluma ]";
      type = types.listOf types.package;
      description = "Which MATE packages to exclude from the default environment";
    };

  };

  config = mkMerge [
    (mkIf (cfg.enable || cfg.enableWaylandSession) {
      services.displayManager.sessionPackages = [
        pkgs.mate.mate-session-manager
      ];

      environment.extraInit = lib.optionalString config.services.gnome.gcr-ssh-agent.enable ''
        # Hack: https://bugzilla.redhat.com/show_bug.cgi?id=2250704 still
        # applies to sessions not managed by systemd.
        if [ -z "$SSH_AUTH_SOCK" ] && [ -n "$XDG_RUNTIME_DIR" ]; then
          export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"
        fi
      '';

      # Debugging
      environment.sessionVariables.MATE_SESSION_DEBUG = mkIf cfg.debug "1";

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
      programs.bash.vteIntegration = mkDefault true;
      programs.zsh.vteIntegration = mkDefault true;

      # Mate uses this for printing
      programs.system-config-printer.enable = (mkIf config.services.printing.enable (mkDefault true));

      services.gnome.at-spi2-core.enable = true;
      services.gnome.glib-networking.enable = true;
      services.gnome.gnome-keyring.enable = true;
      services.gnome.gcr-ssh-agent.enable = mkDefault true;
      services.udev.packages = [ pkgs.mate.mate-settings-daemon ];
      services.gvfs.enable = true;
      services.upower.enable = config.powerManagement.enable;
      services.libinput.enable = mkDefault true;

      security.pam.services.mate-screensaver.unixAuth = true;

      xdg.portal.configPackages = mkDefault [ pkgs.mate.mate-desktop ];

      environment.pathsToLink = [ "/share" ];
    })
    (mkIf cfg.enableWaylandSession {
      programs.wayfire.enable = true;

      environment.sessionVariables.NIX_GSETTINGS_OVERRIDES_DIR = "${pkgs.mate.mate-gsettings-overrides}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas";

      environment.systemPackages = [ pkgs.mate.mate-wayland-session ];
      services.displayManager.sessionPackages = [ pkgs.mate.mate-wayland-session ];
    })
  ];
}
