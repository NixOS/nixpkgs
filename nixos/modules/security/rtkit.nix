# A module for ‘rtkit’, a DBus system service that hands out realtime
# scheduling priority to processes that ask for it.

{ config, pkgs, ... }:

with pkgs.lib;

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

    environment.systemPackages = [ pkgs.rtkit ];

    services.dbus.packages = [ pkgs.rtkit ];

    users.extraUsers = singleton
      { name = "rtkit";
        uid = config.ids.uids.rtkit;
        description = "RealtimeKit daemon";
      };

  };

}
