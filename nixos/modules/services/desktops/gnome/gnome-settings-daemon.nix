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

    systemd.user.targets."gnome-session-initialized".wants = [
      "gsd-color.target"
      "gsd-datetime.target"
      "gsd-keyboard.target"
      "gsd-media-keys.target"
      "gsd-print-notifications.target"
      "gsd-rfkill.target"
      "gsd-screensaver-proxy.target"
      "gsd-sharing.target"
      "gsd-smartcard.target"
      "gsd-sound.target"
      "gsd-wacom.target"
      "gsd-wwan.target"
      "gsd-a11y-settings.target"
      "gsd-housekeeping.target"
      "gsd-power.target"
    ];

    systemd.user.targets."gnome-session-x11-services".wants = [
      "gsd-xsettings.target"
    ];

  };

}
