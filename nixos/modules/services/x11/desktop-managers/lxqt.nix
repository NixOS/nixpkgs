{ config, lib, pkgs, ... }:

with lib;

let

  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.lxqt;

in

{
  options = {

    services.xserver.desktopManager.lxqt.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the LXQt desktop manager";
    };

  };


  config = mkIf (xcfg.enable && cfg.enable) {

    services.xserver.desktopManager.session = singleton {
      name = "lxqt";
      bgSupport = true;
      start = ''
        exec ${pkgs.lxqt.lxqt-common}/bin/startlxqt
      '';
    };

    environment.systemPackages = [
      pkgs.kde5.kwindowsystem # provides some QT5 plugins needed by lxqt-panel
      pkgs.kde5.libkscreen # provides plugins for screen management software
      pkgs.kde5.oxygen-icons5 # default icon theme
      pkgs.libfm
      pkgs.libfm-extra
      pkgs.lxmenu-data
      pkgs.lxqt.compton-conf
      pkgs.lxqt.libfm-qt
      pkgs.lxqt.liblxqt
      pkgs.lxqt.libqtxdg
      pkgs.lxqt.libsysstat
      pkgs.lxqt.lximage-qt
      pkgs.lxqt.lxqt-about
      pkgs.lxqt.lxqt-admin
      pkgs.lxqt.lxqt-common
      pkgs.lxqt.lxqt-config
      pkgs.lxqt.lxqt-globalkeys
      pkgs.lxqt.lxqt-l10n
      pkgs.lxqt.lxqt-notificationd
      pkgs.lxqt.lxqt-openssh-askpass
      pkgs.lxqt.lxqt-panel
      pkgs.lxqt.lxqt-policykit
      pkgs.lxqt.lxqt-powermanagement
      pkgs.lxqt.lxqt-qtplugin
      pkgs.lxqt.lxqt-runner
      pkgs.lxqt.lxqt-session
      pkgs.lxqt.lxqt-sudo
      pkgs.lxqt.obconf-qt
      pkgs.lxqt.pavucontrol-qt
      pkgs.lxqt.pcmanfm-qt
      pkgs.lxqt.qlipper
      pkgs.lxqt.qps
      pkgs.lxqt.qterminal
      pkgs.lxqt.qtermwidget
      pkgs.lxqt.screengrab
      pkgs.menu-cache
      pkgs.openbox # default window manager
      pkgs.qt5.qtsvg # provides QT5 plugins for svg icons
      pkgs.xscreensaver
    ];

    # Link some extra directories in /run/current-system/software/share
    environment.pathsToLink = [
      "/share/desktop-directories"
      "/share/icons"
      "/share/lxqt"
    ];

  };
}
