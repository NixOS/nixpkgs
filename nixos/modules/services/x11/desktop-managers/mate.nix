{ config, lib, pkgs, ... }:

with lib;

let

  # Remove packages of ys from xs, based on their names
  removePackagesByName = xs: ys:
    let
      pkgName = drv: (builtins.parseDrvName drv.name).name;
      ysNames = map pkgName ys;
    in
      filter (x: !(builtins.elem (pkgName x) ysNames)) xs;

  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.mate;

in

{
  options = {

    services.xserver.desktopManager.mate.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the MATE desktop environment";
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

        export XDG_MENU_PREFIX=mate

        # Find the mouse
        export XCURSOR_PATH=~/.icons:${config.system.path}/share/icons

        # Update user dirs as described in http://freedesktop.org/wiki/Software/xdg-user-dirs/
        ${pkgs.xdg-user-dirs}/bin/xdg-user-dirs-update

        ${pkgs.mate.mate-session-manager}/bin/mate-session &
        waitPID=$!
      '';
    };

    environment.systemPackages =
      pkgs.mate.basePackages ++
      (removePackagesByName
        pkgs.mate.extraPackages
        config.environment.mate.excludePackages);

    services.dbus.packages = [
      pkgs.gnome3.dconf
      pkgs.at_spi2_core
    ];

    services.gnome3.gnome-keyring.enable = true;
    services.upower.enable = config.powerManagement.enable;

    environment.pathsToLink = [ "/share" ];
  };

}
