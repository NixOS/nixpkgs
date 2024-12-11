# A module for ‘rtkit’, a DBus system service that hands out realtime
# scheduling priority to processes that ask for it.

{ config, lib, pkgs, ... }:

with lib;

{

  options = {

    security.rtkit.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable the RealtimeKit system service, which hands
        out realtime scheduling priority to user processes on
        demand. For example, the PulseAudio server uses this to
        acquire realtime priority.
      '';
    };

  };


  config = mkIf config.security.rtkit.enable {

    security.polkit.enable = true;

    # To make polkit pickup rtkit policies
    environment.systemPackages = [ pkgs.rtkit ];

    systemd.packages = [ pkgs.rtkit ];

    # Stop spamming the log and fix sd_notify().
    # This bind-mounts the notify socket so the `Status` line
    # in `systemctl status` work which makes the constant debug
    # logging redundant.
    # See also:
    # - https://github.com/heftig/rtkit/issues/22
    # - https://github.com/heftig/rtkit/issues/27
    systemd.services.rtkit-daemon = {
      environment.NOTIFY_SOCKET = "/fs/sd-notify";
      serviceConfig = {
        BindPaths = "/run/systemd/notify:/proc/fs/sd-notify";
        TemporaryFileSystem = "/proc/fs";
        # Only log LOG_INFO and higher
        LogLevelMax = 6;
      };
    };

    services.dbus.packages = [ pkgs.rtkit ];

    users.users.rtkit =
      {
        isSystemUser = true;
        group = "rtkit";
        description = "RealtimeKit daemon";
      };
    users.groups.rtkit = {};

  };

}
