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
      description = "Enable the lxqt 0.9 desktop manager.";
    };

  };


  config = mkIf (xcfg.enable && cfg.enable) {

    services.xserver.desktopManager.session = singleton
      { name = "lxqt";
        start = ''
          exec ${pkgs.lxqt.lxqt-common}/bin/startlxqt
        '';
      };

    environment.systemPackages = [
      pkgs.kde5.oxygen-icons
      pkgs.lxqt.lxqt-libfm-extras
      pkgs.lxqt.menu-cache
      pkgs.lxqt.lxmenu-data
      pkgs.lxqt.lxqt-libfm
      pkgs.lxqt.libqtxdg
      pkgs.lxqt.liblxqt
      pkgs.lxqt.liblxqt-mount
      pkgs.lxqt.libsysstat
      pkgs.lxqt.lxqt-session
      pkgs.lxqt.lxqt-qtplugin
      pkgs.lxqt.lxqt-globalkeys
      pkgs.lxqt.lxqt-notificationd
      pkgs.lxqt.lxqt-about
      pkgs.lxqt.lxqt-common
      pkgs.lxqt.lxqt-config
      pkgs.lxqt.lxqt-openssh-askpass
      pkgs.lxqt.lxqt-panel
      pkgs.lxqt.lxqt-polkit_qt_1
      pkgs.lxqt.lxqt-policykit
      pkgs.lxqt.lxqt-powermanagement
      pkgs.lxqt.lxqt-runner
      pkgs.lxqt.lxqt-pcmanfm-qt
      #pkgs.lxqt.compton-conf
      pkgs.lxqt.lximage-qt
    ];

    # Link some extra directories in /run/current-system/software/share
    environment.pathsToLink =
      [ "/share/lxqt" "/share/desktop-directories" ];

  };

# TODOs:
# - [ ] Let user select icon theme, rather than default to oxygen-icons, and then change etc/xdg/lxqt/lxqt.conf appropriately
}
