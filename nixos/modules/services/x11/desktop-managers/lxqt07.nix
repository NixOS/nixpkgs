{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.xserver.desktopManager.lxqt07;

in

{
  options = {

    services.xserver.desktopManager.lxqt07.enable = mkOption {
      default = false;
      example = false;
      description = "Enable the lxqt 0.7 desktop manager.";
    };

  };

  config = mkIf (config.services.xserver.enable && cfg.enable) {

    services.xserver.desktopManager.session = singleton
      { name = "lxqt07";
        start = ''
          exec ${pkgs.lxqt07.lxqt-common}/bin/startlxqt
        '';
      };

    environment.systemPackages = [
      pkgs.lxqt07.compton-conf
      pkgs.lxqt07.lximage-qt
      pkgs.lxqt07.lxqt-about
      pkgs.lxqt07.lxqt-globalkeys
      pkgs.lxqt07.lxqt-notificationd
      pkgs.lxqt07.lxqt-openssh-askpass
      pkgs.lxqt07.lxqt-panel
      pkgs.lxqt07.lxqt-policykit
      pkgs.lxqt07.lxqt-powermanagement
      pkgs.lxqt07.lxqt-qtplugin
      pkgs.lxqt07.lxqt-runner
      pkgs.lxqt07.lxqt-session
      pkgs.lxqt07.lxqt-common
      pkgs.lxqt07.lxqt-config
      pkgs.lxqt07.lxqt-config-randr
      pkgs.lxqt07.lxmenu-data
      pkgs.lxqt07.menu-cache
      pkgs.lxqt07.pcmanfm-qt
    ];

    # Link some extra directories in /run/current-system/software/share
    environment.pathsToLink =
      [ "/share/lxqt" "/share/desktop-directories" ];

  };

}
