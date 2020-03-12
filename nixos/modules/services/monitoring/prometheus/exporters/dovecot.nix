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
      description = ''
        Path under which to expose metrics.
      '';
    };
    socketPath = mkOption {
      type = types.path;
      default = "/var/run/dovecot/stats";
      example = "/var/run/dovecot2/old-stats";
      description = ''
        Path under which the stats socket is placed.
        The user/group under which the exporter runs,
        should be able to access the socket in order
        to scrape the metrics successfully.

        Please keep in mind that the stats module has changed in
        <link xlink:href="https://wiki2.dovecot.org/Upgrading/2.3">Dovecot 2.3+</link> which
        is not <link xlink:href="https://github.com/kumina/dovecot_exporter/issues/8">compatible with this exporter</link>.

        The following extra config has to be passed to Dovecot to ensure that recent versions
        work with this exporter:
        <programlisting>
        {
          <xref linkend="opt-services.prometheus.exporters.dovecot.enable" /> = true;
          <xref linkend="opt-services.prometheus.exporters.dovecot.socketPath" /> = "/var/run/dovecot2/old-stats";
          <xref linkend="opt-services.dovecot2.extraConfig" /> = '''
            mail_plugins = $mail_plugins old_stats
            service old-stats {
              unix_listener old-stats {
                user = dovecot-exporter
                group = dovecot-exporter
              }
            }
          ''';
        }
        </programlisting>
      '';
    };
    scopes = mkOption {
      type = types.listOf types.str;
      default = [ "user" ];
      example = [ "user" "global" ];
      description = ''
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
    };
  };
}
