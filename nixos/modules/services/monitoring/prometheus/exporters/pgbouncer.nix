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
    lib.mkOption
    mkPackageOption
    types
    lib.optionals
    getExe
    escapeShellArg
    concatStringsSep
    ;
in
{
  port = 9127;
  extraOpts = {
    package = lib.mkPackageOption pkgs "prometheus-pgbouncer-exporter" { };

    telemetryPath = lib.mkOption {
      type = lib.types.str;
      default = "/metrics";
      description = ''
        Path under which to expose metrics.
      '';
    };

    connectionString = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "postgres://admin:@localhost:6432/pgbouncer?sslmode=require";
      description = ''
        Connection string for accessing pgBouncer.

        NOTE: You MUST keep pgbouncer as database name (special internal db)!!!

        NOTE: ignore_startup_parameters MUST contain "extra_float_digits".

        NOTE: Admin user (with password or passwordless) MUST exist in the
        auth_file if auth_type other than "any" is used.

        WARNING: this secret is stored in the world-readable Nix store!
        Use [](#opt-services.prometheus.exporters.pgbouncer.connectionEnvFile) if the
        URL contains a secret.
      '';
    };

    connectionEnvFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
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

    pidFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
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

    webSystemdSocket = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Use systemd socket activation listeners instead of port listeners (Linux only).
      '';
    };

    logLevel = lib.mkOption {
      type = lib.types.enum [
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

    logFormat = lib.mkOption {
      type = lib.types.enum [
        "logfmt"
        "json"
      ];
      default = "logfmt";
      description = ''
        Output format of log messages. One of: [logfmt, json]
      '';
    };

    webConfigFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to configuration file that can enable TLS or authentication.
      '';
    };

    extraFlags = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Extra commandline options when launching Prometheus.
      '';
    };

  };

  serviceOpts = {
    after = [ "pgbouncer.service" ];
    script = concatStringsSep " " (
      [
        "exec -- ${lib.escapeShellArg (getExe cfg.package)}"
        "--web.listen-address ${cfg.listenAddress}:${toString cfg.port}"
      ]
      ++ lib.optionals (cfg.connectionString != null) [
        "--pgBouncer.connectionString ${lib.escapeShellArg cfg.connectionString}"
      ]
      ++ lib.optionals (cfg.telemetryPath != null) [
        "--web.telemetry-path ${lib.escapeShellArg cfg.telemetryPath}"
      ]
      ++ lib.optionals (cfg.pidFile != null) [
        "--pgBouncer.pid-file ${lib.escapeShellArg cfg.pidFile}"
      ]
      ++ lib.optionals (cfg.logLevel != null) [
        "--log.level ${lib.escapeShellArg cfg.logLevel}"
      ]
      ++ lib.optionals (cfg.logFormat != null) [
        "--log.format ${lib.escapeShellArg cfg.logFormat}"
      ]
      ++ lib.optionals (cfg.webSystemdSocket != false) [
        "--web.systemd-socket ${lib.escapeShellArg cfg.webSystemdSocket}"
      ]
      ++ lib.optionals (cfg.webConfigFile != null) [
        "--web.config.file ${lib.escapeShellArg cfg.webConfigFile}"
      ]
      ++ cfg.extraFlags
    );

    serviceConfig.RestrictAddressFamilies = [
      "AF_INET"
      "AF_INET6"
      "AF_UNIX"
    ];
    serviceConfig.EnvironmentFile = lib.mkIf (cfg.connectionEnvFile != null) [
      cfg.connectionEnvFile
    ];
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
