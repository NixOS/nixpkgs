{ config, lib, ... }:

with lib;

{

  options = {

    services.timesyncd = {
      enable = mkOption {
        default = !config.boot.isContainer;
        defaultText = literalExpression "!config.boot.isContainer";
        type = types.bool;
        description = lib.mdDoc ''
          Enables the systemd NTP client daemon.
        '';
      };
      servers = mkOption {
        default = config.networking.timeServers;
        defaultText = literalExpression "config.networking.timeServers";
        type = types.listOf types.str;
        description = lib.mdDoc ''
          The set of NTP servers from which to synchronise.
        '';
      };
      extraConfig = mkOption {
        default = "";
        type = types.lines;
        example = ''
          PollIntervalMaxSec=180
        '';
        description = lib.mdDoc ''
          Extra config options for systemd-timesyncd. See
          [
          timesyncd.conf(5)](https://www.freedesktop.org/software/systemd/man/timesyncd.conf.html) for available options.
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

    system.activationScripts.systemd-timesyncd-migration =
      # workaround an issue of systemd-timesyncd not starting due to upstream systemd reverting their dynamic users changes
      #  - https://github.com/NixOS/nixpkgs/pull/61321#issuecomment-492423742
      #  - https://github.com/systemd/systemd/issues/12131
      mkIf (versionOlder config.system.stateVersion "19.09") ''
        if [ -L /var/lib/systemd/timesync ]; then
          rm /var/lib/systemd/timesync
          mv /var/lib/private/systemd/timesync /var/lib/systemd/timesync
        fi
      '';
    system.activationScripts.systemd-timesyncd-init-clock =
      # Ensure that we have some stored time to prevent systemd-timesyncd to
      # resort back to the fallback time.
      # If the file doesn't exist we assume that our current system clock is
      # good enough to provide an initial value.
      ''
      if ! [ -f /var/lib/systemd/timesync/clock ]; then
        test -d /var/lib/systemd/timesync || mkdir -p /var/lib/systemd/timesync
        touch /var/lib/systemd/timesync/clock
      fi
      '';
  };

}
