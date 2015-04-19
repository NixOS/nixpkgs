{ config, lib, pkgs, ... }:

with lib;

{

  options = {

    services.timesyncd.enable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Enables the systemd NTP client daemon.
      '';
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
      NTP=${concatStringsSep " " config.services.ntp.servers}
    '';

    systemd.services.ntpd.enable = false;

    users.extraUsers.systemd-timesync.uid = config.ids.uids.systemd-timesync;
    users.extraGroups.systemd-timesync.gid = config.ids.gids.systemd-timesync;

  };

}
