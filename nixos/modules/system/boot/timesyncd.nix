{ config, lib, ... }:

with lib;

{

  options = {

    services.timesyncd = {
      enable = mkOption {
        default = !config.boot.isContainer;
        defaultText = literalExpression "!config.boot.isContainer";
        type = types.bool;
        description = ''
          Enables the systemd NTP client daemon.
        '';
      };
      servers = mkOption {
        default = config.networking.timeServers;
        defaultText = literalExpression "config.networking.timeServers";
        type = types.listOf types.str;
        description = ''
          The set of NTP servers from which to synchronise.
          Note if this is set to an empty list, the defaults systemd itself is
          compiled with ({0..4}.nixos.pool.ntp.org) apply,
          In case you want to disable timesyncd altogether, use the `enable` option.
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
      # systemd-timesyncd disables DNSSEC validation in the nss-resolve module by setting SYSTEMD_NSS_RESOLVE_VALIDATE to 0 in the unit file.
      # This is required in order to solve the chicken-and-egg problem when DNSSEC validation needs the correct time to work, but to set the
      # correct time, we need to connect to an NTP server, which usually requires resolving its hostname.
      # In order for nss-resolve to be able to read this environment variable we patch systemd-timesyncd to disable NSCD and use NSS modules directly.
      # This means that systemd-timesyncd needs to have NSS modules path in LD_LIBRARY_PATH. When systemd-resolved is disabled we still need to set
      # NSS module path so that systemd-timesyncd keeps using other NSS modules that are configured in the system.
      environment.LD_LIBRARY_PATH = config.system.nssModules.path;

      preStart = (
        # Ensure that we have some stored time to prevent
        # systemd-timesyncd to resort back to the fallback time.  If
        # the file doesn't exist we assume that our current system
        # clock is good enough to provide an initial value.
        ''
          if ! [ -f /var/lib/systemd/timesync/clock ]; then
            test -d /var/lib/systemd/timesync || mkdir -p /var/lib/systemd/timesync
            touch /var/lib/systemd/timesync/clock
          fi
        ''
        +
          # workaround an issue of systemd-timesyncd not starting due to upstream systemd reverting their dynamic users changes
          #  - https://github.com/NixOS/nixpkgs/pull/61321#issuecomment-492423742
          #  - https://github.com/systemd/systemd/issues/12131
          (lib.optionalString (versionOlder config.system.stateVersion "19.09") ''
            if [ -L /var/lib/systemd/timesync ]; then
              rm /var/lib/systemd/timesync
              mv /var/lib/private/systemd/timesync /var/lib/systemd/timesync
            fi
          '')
      );
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
  };
}
