{ config, lib, pkgs, ... }:

with lib;

{

  options = {

    services.timesyncd = {
      enable = mkOption {
        default = !config.boot.isContainer;
        type = types.bool;
        description = ''
          Enables the systemd NTP client daemon.
        '';
      };
      servers = mkOption {
        default = config.networking.timeServers;
        description = ''
          The set of NTP servers from which to synchronise.
        '';
      };
    };
  };

  config = mkIf config.services.timesyncd.enable {

    systemd.additionalUpstreamSystemUnits = [ "systemd-timesyncd.service" ];

    systemd.services.systemd-timesyncd = {
      wantedBy = [ "sysinit.target" ];
      restartTriggers = [ config.environment.etc."systemd/timesyncd.conf".source ];
    };

    environment.etc."systemd/timesyncd.conf".text = ''
      [Time]
      NTP=${concatStringsSep " " config.services.timesyncd.servers}
    '';

    users.extraUsers.systemd-timesync.uid = config.ids.uids.systemd-timesync;
    users.extraGroups.systemd-timesync.gid = config.ids.gids.systemd-timesync;

  };

}
