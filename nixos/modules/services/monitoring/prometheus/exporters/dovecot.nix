{ config, lib, pkgs }:

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
      example = "/var/run/dovecot2/stats";
      description = ''
        Path under which the stats socket is placed.
        The user/group under which the exporter runs,
        should be able to access the socket in order
        to scrape the metrics successfully.
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
      ExecStart = ''
        ${pkgs.prometheus-dovecot-exporter}/bin/dovecot_exporter \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          --web.telemetry-path ${cfg.telemetryPath} \
          --dovecot.socket-path ${cfg.socketPath} \
          --dovecot.scopes ${concatStringsSep "," cfg.scopes} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
