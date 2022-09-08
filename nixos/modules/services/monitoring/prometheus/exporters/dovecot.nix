{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.dovecot;
in
{
  port = 9166;
  extraOpts = {
    telemetryPath = mkOption {
      type = types.str;
      default = "/metrics";
      description = lib.mdDoc ''
        Path under which to expose metrics.
      '';
    };
    socketPath = mkOption {
      type = types.path;
      default = "/var/run/dovecot/stats";
      example = "/var/run/dovecot2/old-stats";
      description = lib.mdDoc ''
        Path under which the stats socket is placed.
        The user/group under which the exporter runs,
        should be able to access the socket in order
        to scrape the metrics successfully.

        Please keep in mind that the stats module has changed in
        [Dovecot 2.3+](https://wiki2.dovecot.org/Upgrading/2.3) which
        is not [compatible with this exporter](https://github.com/kumina/dovecot_exporter/issues/8).

        The following extra config has to be passed to Dovecot to ensure that recent versions
        work with this exporter:
        ```
        {
          services.prometheus.exporters.dovecot.enable = true;
          services.prometheus.exporters.dovecot.socketPath = "/var/run/dovecot2/old-stats";
          services.dovecot2.mailPlugins.globally.enable = [ "old_stats" ];
          services.dovecot2.extraConfig = '''
            service old-stats {
              unix_listener old-stats {
                user = dovecot-exporter
                group = dovecot-exporter
                mode = 0660
              }
              fifo_listener old-stats-mail {
                mode = 0660
                user = dovecot
                group = dovecot
              }
              fifo_listener old-stats-user {
                mode = 0660
                user = dovecot
                group = dovecot
              }
            }
            plugin {
              old_stats_refresh = 30 secs
              old_stats_track_cmds = yes
            }
          ''';
        }
        ```
      '';
    };
    scopes = mkOption {
      type = types.listOf types.str;
      default = [ "user" ];
      example = [ "user" "global" ];
      description = lib.mdDoc ''
        Stats scopes to query.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      DynamicUser = false;
      ExecStart = ''
        ${pkgs.prometheus-dovecot-exporter}/bin/dovecot_exporter \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          --web.telemetry-path ${cfg.telemetryPath} \
          --dovecot.socket-path ${escapeShellArg cfg.socketPath} \
          --dovecot.scopes ${concatStringsSep "," cfg.scopes} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
      RestrictAddressFamilies = [
        # Need AF_UNIX to collect data
        "AF_UNIX"
      ];
    };
  };
}
