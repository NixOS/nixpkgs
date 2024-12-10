{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.pgbouncer;
  inherit (lib)
    mkOption
    types
    optionals
    getExe
    escapeShellArg
    concatStringsSep
    ;
in
{
  port = 9127;
  extraOpts = {

    telemetryPath = mkOption {
      type = types.str;
      default = "/metrics";
      description = ''
        Path under which to expose metrics.
      '';
    };

    connectionString = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "postgres://admin:@localhost:6432/pgbouncer?sslmode=require";
      description = ''
        Connection string for accessing pgBouncer.

        NOTE: You MUST keep pgbouncer as database name (special internal db)!!!

        NOTE: Admin user (with password or passwordless) MUST exist
        in the services.pgbouncer.authFile if authType other than any is used.

        WARNING: this secret is stored in the world-readable Nix store!
        Use [](#opt-services.prometheus.exporters.pgbouncer.connectionEnvFile) if the
        URL contains a secret.
      '';
    };

    connectionEnvFile = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        File that must contain the environment variable
        `PGBOUNCER_EXPORTER_CONNECTION_STRING` which is set to the connection
        string used by pgbouncer. I.e. the format is supposed to look like this:

        ```
        PGBOUNCER_EXPORTER_CONNECTION_STRING="postgres://admin@localhost:6432/pgbouncer?sslmode=require"
        ```

        NOTE: You MUST keep pgbouncer as database name (special internal db)!
        NOTE: `services.pgbouncer.settings.pgbouncer.ignore_startup_parameters`
        MUST contain "extra_float_digits".

        Mutually exclusive with [](#opt-services.prometheus.exporters.pgbouncer.connectionString).
      '';
    };

    pidFile = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Path to PgBouncer pid file.

        If provided, the standard process metrics get exported for the PgBouncer
        process, prefixed with 'pgbouncer_process_...'. The pgbouncer_process exporter
        needs to have read access to files owned by the PgBouncer process. Depends on
        the availability of /proc.

        https://prometheus.io/docs/instrumenting/writing_clientlibs/#process-metrics.

      '';
    };

    webSystemdSocket = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Use systemd socket activation listeners instead of port listeners (Linux only).
      '';
    };

    logLevel = mkOption {
      type = types.enum [
        "debug"
        "info"
        "warn"
        "error"
      ];
      default = "info";
      description = ''
        Only log messages with the given severity or above.
      '';
    };

    logFormat = mkOption {
      type = types.enum [
        "logfmt"
        "json"
      ];
      default = "logfmt";
      description = ''
        Output format of log messages. One of: [logfmt, json]
      '';
    };

    webConfigFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Path to configuration file that can enable TLS or authentication.
      '';
    };

    extraFlags = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Extra commandline options when launching Prometheus.
      '';
    };

  };

  serviceOpts = {
    after = [ "pgbouncer.service" ];
    serviceConfig =
      let
        startScript = pkgs.writeShellScriptBin "pgbouncer-start" "${concatStringsSep " " (
          [
            "${pkgs.prometheus-pgbouncer-exporter}/bin/pgbouncer_exporter"
            "--web.listen-address ${cfg.listenAddress}:${toString cfg.port}"
          ]
          ++ optionals (cfg.connectionString != null) [
            "--pgBouncer.connectionString ${escapeShellArg cfg.connectionString}"
          ]
          ++ optionals (cfg.telemetryPath != null) [
            "--web.telemetry-path ${escapeShellArg cfg.telemetryPath}"
          ]
          ++ optionals (cfg.pidFile != null) [
            "--pgBouncer.pid-file= ${escapeShellArg cfg.pidFile}"
          ]
          ++ optionals (cfg.logLevel != null) [
            "--log.level ${escapeShellArg cfg.logLevel}"
          ]
          ++ optionals (cfg.logFormat != null) [
            "--log.format ${escapeShellArg cfg.logFormat}"
          ]
          ++ optionals (cfg.webSystemdSocket != false) [
            "--web.systemd-socket ${escapeShellArg cfg.webSystemdSocket}"
          ]
          ++ optionals (cfg.webConfigFile != null) [
            "--web.config.file ${escapeShellArg cfg.webConfigFile}"
          ]
          ++ cfg.extraFlags
        )}";
      in
      {
        ExecStart = "${startScript}/bin/pgbouncer-start";
        EnvironmentFile = lib.mkIf (cfg.connectionEnvFile != null) [
          cfg.connectionEnvFile
        ];
      };
  };

  imports = [
    (lib.mkRemovedOptionModule [ "connectionStringFile" ] ''
      As replacement, the option `services.prometheus.exporters.pgbouncer.connectionEnvFile`
      has been added. In contrast to `connectionStringFile` it must be an environment file
      with the connection string being set to `PGBOUNCER_EXPORTER_CONNECTION_STRING`.

      The change was necessary since the former option wrote the contents of the file
      into the cmdline of the exporter making the connection string effectively
      world-readable.
    '')
    ({
      options.warnings = options.warnings;
      options.assertions = options.assertions;
    })
  ];
}
