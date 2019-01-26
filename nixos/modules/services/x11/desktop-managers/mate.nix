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
      example = literalExample "[ pkgs.mate.mate-terminal pkgs.mate.pluma ]";
      type = types.listOf types.package;
      description = "Which MATE packages to exclude from the default environment";
    };

  };

  config = mkIf (xcfg.enable && cfg.enable) {

    services.xserver.desktopManager.session = singleton {
      name = "mate";
      bgSupport = true;
      start = ''
        # Set GTK_DATA_PREFIX so that GTK+ can find the themes
        export GTK_DATA_PREFIX=${config.system.path}

        # Find theme engines
        export GTK_PATH=${config.system.path}/lib/gtk-3.0:${config.system.path}/lib/gtk-2.0

        export XDG_MENU_PREFIX=mate-

        # Find the mouse
        export XCURSOR_PATH=~/.icons:${config.system.path}/share/icons

        # Let caja find extensions
        export CAJA_EXTENSION_DIRS=$CAJA_EXTENSION_DIRS''${CAJA_EXTENSION_DIRS:+:}${config.system.path}/lib/caja/extensions-2.0

        # Let caja extensions find gsettings schemas
        ${concatMapStrings (p: ''
          if [ -d "${p}/lib/caja/extensions-2.0" ]; then
            ${addToXDGDirs p}
          fi
          '')
          config.environment.systemPackages
        }

        # Let mate-panel find applets
        export MATE_PANEL_APPLETS_DIR=$MATE_PANEL_APPLETS_DIR''${MATE_PANEL_APPLETS_DIR:+:}${config.system.path}/share/mate-panel/applets
        export MATE_PANEL_EXTRA_MODULES=$MATE_PANEL_EXTRA_MODULES''${MATE_PANEL_EXTRA_MODULES:+:}${config.system.path}/lib/mate-panel/applets

        # Add mate-control-center paths to some XDG variables because its schemas are needed by mate-settings-daemon, and mate-settings-daemon is a dependency for mate-control-center (that is, they are mutually recursive)
        ${addToXDGDirs pkgs.mate.mate-control-center}

        # Update user dirs as described in http://freedesktop.org/wiki/Software/xdg-user-dirs/
        ${pkgs.xdg-user-dirs}/bin/xdg-user-dirs-update

        ${pkgs.mate.mate-session-manager}/bin/mate-session ${optionalString cfg.debug "--debug"} &
        waitPID=$!
      '';
    };

    environment.systemPackages =
      pkgs.mate.basePackages ++
      (pkgs.gnome3.removePackagesByName
        pkgs.mate.extraPackages
        config.environment.mate.excludePackages);

    services.dbus.packages = [
      pkgs.gnome3.dconf
      pkgs.at-spi2-core
    ];

    services.gnome3.gnome-keyring.enable = true;
    services.upower.enable = config.powerManagement.enable;

    security.pam.services."mate-screensaver".unixAuth = true;

    environment.pathsToLink = [ "/share" ];
  };

}
