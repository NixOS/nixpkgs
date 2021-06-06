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

    # TODO perhaps LoadCredential would be more appropriate
    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/root/prometheus-postgres-exporter.env";
      description = ''
        Environment file as defined in <citerefentry>
        <refentrytitle>systemd.exec</refentrytitle><manvolnum>5</manvolnum>
        </citerefentry>.

        Secrets may be passed to the service without adding them to the
        world-readable Nix store, by specifying placeholder variables as
        the option value in Nix and setting these variables accordingly in the
        environment file.

        Environment variables from this file will be interpolated into the
        config file using envsubst with this syntax:
        <literal>$ENVIRONMENT ''${VARIABLE}</literal>

        The main use is to set the DATA_SOURCE_NAME that contains the
        postgres password

        note that contents from this file will override dataSourceName
        if you have set it from nix.

        <programlisting>
          # Content of the environment file
          DATA_SOURCE_NAME=postgresql://username:password@localhost:5432/postgres?sslmode=disable
        </programlisting>

        Note that this file needs to be available on the host on which
        this exporter is running.
      '';
    };

  };
  serviceOpts = {
    environment.DATA_SOURCE_NAME = cfg.dataSourceName;
    serviceConfig = {
      DynamicUser = false;
      User = mkIf cfg.runAsLocalSuperUser (mkForce "postgres");
      EnvironmentFile = mkIf (cfg.environmentFile != null) [ cfg.environmentFile ];
      ExecStart = ''
        ${pkgs.prometheus-postgres-exporter}/bin/postgres_exporter \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          --web.telemetry-path ${cfg.telemetryPath} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
