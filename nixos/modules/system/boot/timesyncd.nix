{ config, lib, ... }:

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
      extraConfig = mkOption {
        default = "";
        type = types.lines;
        example = ''
          PollIntervalMaxSec=180
        '';
        description = ''
          Extra config options for systemd-timesyncd. See
          <link xlink:href="https://www.freedesktop.org/software/systemd/man/timesyncd.conf.html">
          timesyncd.conf(5)</link> for available options.
        '';
      };
    };
  };

  config = mkIf config.services.timesyncd.enable {

    systemd.additionalUpstreamSystemUnits = [ "systemd-timesyncd.service" ];

    systemd.services.systemd-timesyncd = {
      wantedBy = [ "sysinit.target" ];
      aliases = [ "dbus-org.freedesktop.timesync1.service" ];
      restartTriggers = [ config.environment.etc."systemd/timesyncd.conf".source ];
    };

    environment.etc."systemd/timesyncd.conf".text = ''
      [Time]
      NTP=${concatStringsSep " " config.services.timesyncd.servers}
      ${config.services.timesyncd.extraConfig}
    '';

    users.users.systemd-timesync = {
      uid = config.ids.uids.systemd-timesync;
      group = "systemd-timesync";
    };
    users.groups.systemd-timesync.gid = config.ids.gids.systemd-timesync;

    system.activationScripts.systemd-timesyncd-migration = mkIf (versionOlder config.system.stateVersion "19.09") ''
      # workaround an issue of systemd-timesyncd not starting due to upstream systemd reverting their dynamic users changes
      #  - https://github.com/NixOS/nixpkgs/pull/61321#issuecomment-492423742
      #  - https://github.com/systemd/systemd/issues/12131
      if [ -L /var/lib/systemd/timesync ]; then
        rm /var/lib/systemd/timesync
        mv /var/lib/private/systemd/timesync /var/lib/systemd/timesync
      fi
    '';
  };

}
