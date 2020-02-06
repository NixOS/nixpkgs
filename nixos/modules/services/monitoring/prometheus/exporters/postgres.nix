{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.postgres;
in
{
  port = 9187;
  extraOpts = {
    telemetryPath = mkOption {
      type = types.str;
      default = "/metrics";
      description = ''
        Path under which to expose metrics.
      '';
    };
    dataSourceName = mkOption {
      type = types.str;
      default = "user=postgres database=postgres host=/run/postgresql sslmode=disable";
      example = "postgresql://username:password@localhost:5432/postgres?sslmode=disable";
      description = ''
        Accepts PostgreSQL URI form and key=value form arguments.
      '';
    };
    runAsLocalSuperUser = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to run the exporter as the local 'postgres' super user.
      '';
    };
  };
  serviceOpts = {
    environment.DATA_SOURCE_NAME = cfg.dataSourceName;
    serviceConfig = {
      DynamicUser = false;
      User = mkIf cfg.runAsLocalSuperUser (mkForce "postgres");
      ExecStart = ''
        ${pkgs.prometheus-postgres-exporter}/bin/postgres_exporter \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          --web.telemetry-path ${cfg.telemetryPath} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
