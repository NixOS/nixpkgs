# A module for ‘rtkit’, a DBus system service that hands out realtime
# scheduling priority to processes that ask for it.

{
  config,
  lib,
  pkgs,
  ...
}:

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

    services.dbus.packages = [ pkgs.rtkit ];

    users.users.rtkit = {
      isSystemUser = true;
      group = "rtkit";
      description = "RealtimeKit daemon";
    };
    users.groups.rtkit = { };

  };

}
