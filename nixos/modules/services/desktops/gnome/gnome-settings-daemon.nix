# GNOME Settings Daemon

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.gnome.gnome-settings-daemon;

  pkg = pkgs.gnome.gnome-settings-daemon.override { inherit (cfg) disabled-plugins; };

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

      enable = mkEnableOption (lib.mdDoc "GNOME Settings Daemon");

      disabled-plugins = mkOption {
        type = types.listOf types.str;
        default = [];
        description = lib.mdDoc ''
          Which of the gnome-settings-daemon plugins to disable.
          Each of those plugins runs a user-level systemd service
          called "org.gnome.SettingsDaemon.<x>".

          As of Gnome 45, the plugins were:

            a11y-settings,       GNOME accessibility (impacts keyboard shortcuts)
            color,               GNOME color management (impacts night shift)
            datetime,            GNOME date & time
            power,               GNOME power management
            housekeeping,        GNOME maintenance of expirable data
            keyboard,            GNOME keyboard configuration
            media-keys,          GNOME keyboard shortcuts
            screensaver-proxy,   GNOME FreeDesktop screensaver
            sharing,             GNOME file sharing
            sound,               GNOME sound sample caching
            usb-protection,      GNOME USB protection
            xsettings,           GNOME XSettings
            smartcard,           GNOME smartcard
            wacom,               GNOME Wacom tablet support
            print-notifications, GNOME printer notifications
            rfkill,              GNOME RFKill support
            wwan,                GNOME WWan support
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkg ];

    services.udev.packages = [ pkg ];

    systemd.packages = [ pkg ];

    systemd.user.targets."gnome-session-x11-services".wants = [
      "org.gnome.SettingsDaemon.XSettings.service"
    ];

    systemd.user.targets."gnome-session-x11-services-ready".wants = [
      "org.gnome.SettingsDaemon.XSettings.service"
    ];

  };

}
