{ config, lib, pkgs, ... }:

with lib;

let

  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.deepin;

in

{
  options = {

    services.xserver.desktopManager.deepin.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the Deepin Desktop Environment";
    };

  };


  config = mkIf (xcfg.enable && cfg.enable) {

    #services.xserver.displayManager.extraSessionFilePackages = [ pkgs.deepin.startdde ];

    services.xserver.desktopManager.session = singleton {
      name = "deepin";
      start = ''
        echo ================================
        echo PATH="''${PATH//:/$'\n'}"
        echo ================================

        exec ${pkgs.deepin.startdde}/sbin/startdde
      '';
    };

    programs.dconf.enable = true;

    services.gnome3.gnome-keyring.enable = true;

    #services.upower.enable = config.powerManagement.enable;

    networking.networkmanager.enable = true;

    fonts.fonts = with pkgs; [ noto-fonts ];

    environment.systemPackages = with pkgs; [
      #deepin.startdde
      #deepin.dde-session-ui
      #deepin.deepin-desktop-schemas

      deepin.dbus-factory
      deepin.dde-api
      deepin.dde-calendar
      deepin.dde-daemon
      deepin.dde-dock
      deepin.dde-file-manager
      deepin.dde-network-utils
      deepin.dde-polkit-agent
      deepin.dde-qt-dbus-factory
      deepin.dde-session-ui
      deepin.deepin-anything
      deepin.deepin-desktop-base
      deepin.deepin-desktop-schemas
      deepin.deepin-gettext-tools
      deepin.deepin-gtk-theme
      deepin.deepin-icon-theme
      deepin.deepin-image-viewer
      deepin.deepin-menu
      deepin.deepin-metacity
      deepin.deepin-movie-reborn
      deepin.deepin-mutter
      deepin.deepin-shortcut-viewer
      deepin.deepin-sound-theme
      deepin.deepin-terminal
      deepin.deepin-turbo
      deepin.deepin-wallpapers
      deepin.deepin-wm
      deepin.dpa-ext-gnomekeyring
      deepin.dtkcore
      deepin.dtkwm
      deepin.dtkwidget
      deepin.go-dbus-factory
      deepin.go-dbus-generator
      deepin.go-gir-generator
      deepin.go-lib
      deepin.qt5dxcb-plugin
      deepin.qt5integration
      deepin.startdde
    ];

    # environment.etc = singleton
    #   { source = xcfg.xkbDir;
    #     target = "X11/xkb";
    #   };

    # Link some extra directories in /run/current-system/software/share
    environment.pathsToLink = [
      #"/share/deepin"
      # FIXME: modules should link subdirs of `/share` rather than relying on this
      "/share"
      #"/bin"
    ];

    users.groups.deepin-daemon = { };
    users.users.deepin-daemon = {
      description = "Deepin daemon user";
      isSystemUser = true;
      group = "deepin-daemon";
    };

    users.groups.deepin-sound-player = { };
    users.users.deepin-sound-player = {
      description = "Deepin sound player";
      isSystemUser = true;
      group = "deepin-sound-player";
    };
  };
}
