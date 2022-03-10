{ config, lib, pkgs, ... }:

with lib;

let

  addToXDGDirs = p: ''
    if [ -d "${p}/share/gsettings-schemas/${p.name}" ]; then
      export XDG_DATA_DIRS=$XDG_DATA_DIRS''${XDG_DATA_DIRS:+:}${p}/share/gsettings-schemas/${p.name}
    fi

    if [ -d "${p}/lib/girepository-1.0" ]; then
      export GI_TYPELIB_PATH=$GI_TYPELIB_PATH''${GI_TYPELIB_PATH:+:}${p}/lib/girepository-1.0
      export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}${p}/lib
    fi
  '';

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
    };

    environment.mate.excludePackages = mkOption {
      default = [];
      example = literalExpression "[ pkgs.mate.mate-terminal pkgs.mate.pluma ]";
      type = types.listOf types.package;
      description = "Which MATE packages to exclude from the default environment";
    };

  };

  config = mkIf cfg.enable {

    services.xserver.displayManager.sessionPackages = [
      pkgs.mate.mate-session-manager
    ];

    services.xserver.displayManager.sessionCommands = ''
      if test "$XDG_CURRENT_DESKTOP" = "MATE"; then
          export XDG_MENU_PREFIX=mate-

          # Let caja find extensions
          export CAJA_EXTENSION_DIRS=$CAJA_EXTENSION_DIRS''${CAJA_EXTENSION_DIRS:+:}${config.system.path}/lib/caja/extensions-2.0

          # Let caja extensions find gsettings schemas
          ${concatMapStrings (p: ''
          if [ -d "${p}/lib/caja/extensions-2.0" ]; then
              ${addToXDGDirs p}
          fi
          '') config.environment.systemPackages}

          # Add mate-control-center paths to some XDG variables because its schemas are needed by mate-settings-daemon, and mate-settings-daemon is a dependency for mate-control-center (that is, they are mutually recursive)
          ${addToXDGDirs pkgs.mate.mate-control-center}
      fi
    '';

    # Let mate-panel find applets
    environment.sessionVariables."MATE_PANEL_APPLETS_DIR" = "${config.system.path}/share/mate-panel/applets";
    environment.sessionVariables."MATE_PANEL_EXTRA_MODULES" = "${config.system.path}/lib/mate-panel/applets";

    # Debugging
    environment.sessionVariables.MATE_SESSION_DEBUG = mkIf cfg.debug "1";

    environment.systemPackages = pkgs.gnome.removePackagesByName
      (pkgs.mate.basePackages ++
      pkgs.mate.extraPackages ++
      [
        pkgs.desktop-file-utils
        pkgs.glib
        pkgs.gtk3.out
        pkgs.shared-mime-info
        pkgs.xdg-user-dirs # Update user dirs as described in https://freedesktop.org/wiki/Software/xdg-user-dirs/
        pkgs.mate.mate-settings-daemon
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

    security.pam.services.mate-screensaver.unixAuth = true;

    environment.pathsToLink = [ "/share" ];
  };

}
