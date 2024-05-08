# GNOME Settings Daemon

{ config, lib, pkgs, ... }:

let

  cfg = config.services.gnome.gnome-settings-daemon;

in

{

  meta = {
    maintainers = lib.teams.gnome.members;
  };

  ###### interface

  options = {

    services.gnome.gnome-settings-daemon = {

      enable = lib.mkEnableOption "GNOME Settings Daemon";

    };

  };


  ###### implementation

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [
      pkgs.gnome.gnome-settings-daemon
    ];

    services.udev.packages = [
      pkgs.gnome.gnome-settings-daemon
    ];

    systemd.packages = [
      pkgs.gnome.gnome-settings-daemon
    ];

    systemd.user.targets."gnome-session-x11-services".wants = [
      "org.gnome.SettingsDaemon.XSettings.service"
    ];

    systemd.user.targets."gnome-session-x11-services-ready".wants = [
      "org.gnome.SettingsDaemon.XSettings.service"
    ];

  };

}
