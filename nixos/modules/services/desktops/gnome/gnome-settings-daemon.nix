# GNOME Settings Daemon

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.gnome.gnome-settings-daemon;

in

{

  meta = {
    maintainers = teams.gnome.members;
  };

  imports = [
    (mkRemovedOptionModule
      ["services" "gnome3" "gnome-settings-daemon" "package"]
      "")

    # Added 2021-05-07
    (mkRenamedOptionModule
      [ "services" "gnome3" "gnome-settings-daemon" "enable" ]
      [ "services" "gnome" "gnome-settings-daemon" "enable" ]
    )
  ];

  ###### interface

  options = {

    services.gnome.gnome-settings-daemon = {

      enable = mkEnableOption "GNOME Settings Daemon";

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

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
