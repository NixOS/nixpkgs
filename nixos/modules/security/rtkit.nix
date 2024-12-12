# A module for ‘rtkit’, a DBus system service that hands out realtime
# scheduling priority to processes that ask for it.

{ config, lib, pkgs, utils, ... }:

with lib;

let
  cfg = config.security.rtkit;
  package = pkgs.rtkit;

in {

  options = {

    security.rtkit.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable the RealtimeKit system service, which hands
        out realtime scheduling priority to user processes on
        demand. For example, PulseAudio and PipeWire use this to
        acquire realtime priority.
      '';
    };

    security.rtkit.args = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        Command-line options for `rtkit-daemon`.
      '';
      example = [
        "--our-realtime-priority=29"
        "--max-realtime-priority=28"
      ];
    };

  };


  config = mkIf cfg.enable {

    security.polkit.enable = true;

    # To make polkit pickup rtkit policies
    environment.systemPackages = [ package ];

    services.dbus.packages = [ package ];

    systemd.packages = [ package ];

    systemd.services.rtkit-daemon = {
      serviceConfig.ExecStart = [
        ""  # Resets command from upstream unit.
        "${package}/libexec/rtkit-daemon ${utils.escapeSystemdExecArgs cfg.args}"
      ];
    };

    users.users.rtkit =
      {
        isSystemUser = true;
        group = "rtkit";
        description = "RealtimeKit daemon";
      };
    users.groups.rtkit = {};

  };

}
