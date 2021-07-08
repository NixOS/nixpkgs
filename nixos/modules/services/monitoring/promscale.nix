{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.promscale;

in

{

  options = {

    services.promscale = {

      enable = mkEnableOption "promscale service";

      package = mkOption {
        type = types.package;
        default = pkgs.promscale;
        defaultText = "pkgs.promscale";
        description = "The promscale package to use.";
      };

      asyncAcks = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = ''
          Ack before data is written to DB. [TS_PROM_ASYNC_ACKS] (-async-acks)
        '';
      };

      database.connectRetries = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = ''
          How many times to retry connecting to the database. [TS_PROM_DB_CONNECT_RETRIES] (-db-connect-retries)
        '';
      };

      database.connectionsMax = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = ''
          Maximum connections that can be open at once, defaults to 80% of the max the DB can handle. [TS_PROM_DB_CONNECTIONS_MAX] (default -1) (-db-connections-max)
        '';
      };

      database.host = mkOption {
        type = types.str;
        default = "localhost";
        description = ''
          The TimescaleDB host. [TS_PROM_DB_HOST] (-db-host)
        '';
      };

      database.name = mkOption {
        type = types.str;
        default = "timescale";
        description = ''
          The TimescaleDB database. [TS_PROM_DB_NAME] (-db-name)
        '';
      };

      database.passwordFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/run/keys/promscale.db-password";
        description = ''
          The TimescaleDB password. [TS_PROM_DB_PASSWORD] (-db-password)
        '';
      };

      database.port = mkOption {
        type = types.port;
        default = 5432;
        description = ''
          The TimescaleDB port. [TS_PROM_DB_PORT] (-db-port)
        '';
      };

      database.sslMode = mkOption {
        type = types.enum [ "disable" "allow" "prefer" "require" "verify-ca" "verify-full" ];
        default = "disable";
        description = ''
          The TimescaleDB connection ssl mode. [ "disable" "allow" "prefer" "require" "verify-ca" "verify-full" ] [TS_PROM_DB_SSL_MODE] (-db-ssl-mode)
        '';
      };

      database.user = mkOption {
        type = types.str;
        default = "postgres";
        description = ''
          The TimescaleDB user. [TS_PROM_DB_USER] (-db-user)
        '';
      };

      installTimescaledb = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = ''
          Install or update the TimescaleDB extension. [TS_PROM_INSTALL_TIMESCALEDB] (-install-timescaledb)
        '';
      };

      labelsCacheSize = mkOption {
        type = types.int;
        default = 10000;
        description = ''
          Maximum number of labels to cache. [TS_PROM_LABELS_CACHE_SIZE] (-labels-cache-size)
        '';
      };

      leaderElection.pg.advisoryLockId = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = ''
          Unique advisory lock id per adapter high-availability group. Set it if you want to use leader election implementation based on PostgreSQL advisory lock. [TS_PROM_LEADER_ELECTION_PG_ADVISORY_LOCK_ID] (-leader-election-pg-advisory-lock-id)
        '';
      };

      leaderElection.pg.advisoryLockPrometheusTimeout = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Adapter will resign if there are no requests from Prometheus within a given timeout (0 means no timeout). Note: make sure that only one Prometheus instance talks to the adapter. Timeout value should be co-related with Prometheus scrape interval but add enough slack to prevent random flips. [TS_PROM_LEADER_ELECTION_PG_ADVISORY_LOCK_PROMETHEUS_TIMEOUT] (-leader-election-pg-advisory-lock-prometheus-timeout)
        '';
      };

      leaderElection.rest = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = ''
          Enable REST interface for the leader election. [TS_PROM_LEADER_ELECTION_REST] (-leader-election-rest)
        '';
      };

      leaderElection.scheduledElectionInterval = mkOption {
        type = types.nullOr types.str;
        default = "5s";
        example = "50s";
        description = ''
          Interval at which scheduled election runs. This is used to select a leader and confirm that we still holding the advisory lock. [TS_PROM_SCHEDULED_ELECTION_INTERVAL] (-scheduled-election-interval)
        '';
      };

      logLevel = mkOption {
        type = with types; nullOr (enum [ "error" "warn" "info" "debug" ]);
        default = "debug";
        description = ''
          The log level [ "error", "warn", "info", "debug" ] to use. [TS_PROM_LOG_LEVEL] (-log-level)
        '';
      };

      metricsCacheSize = mkOption {
        type = types.nullOr types.int;
        default = 10000;
        description = ''
          Maximum number of metric names to cache. [TS_PROM_METRICS_CACHE_SIZE] (-metrics-cache-size)
        '';
      };

      migrate = mkOption {
        type = types.enum [ "true" "false" "only" ];
        default = "true";
        description = ''
          Update the Prometheus SQL to the latest version. [ "true" "false" "only" ] [TS_PROM_MIGRATE] (-migrate)
        '';
      };

      tputReport = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = ''
          Interval in seconds at which throughput should be reported. [TS_PROM_TPUT_REPORT] (-tput-report)
        '';
      };

      useSchemaVersionLease = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = ''
          Prevent race conditions during migration [TS_PROM_USE_SCHEMA_VERSION_LEASE] (-use-schema-version-lease)
        '';
      };

      web.listenAddress = mkOption {
        type = types.str;
        default = "localhost"; # default is listen to all addresses.
        example = literalExample ''
          "0.0.0.0"
          "[::1]"
          "127.0.0.1"
        '';
        description = ''
          Address to listen on for web endpoints. Address portion of [TS_PROM_WEB_LISTEN_ADDRESS] (-web-listen-address)
        '';
      };

      web.listenPort = mkOption {
        type = types.port;
        default = 9201;
        description = ''
          Port to listen on for web endpoints. Port partion of [TS_PROM_WEB_LISTEN_ADDRESS] (-web-listen-address)
        '';
      };

      web.telemetryPath = mkOption {
        type = types.str;
        default = "/metrics";
        description = ''
          Address to listen on for web endpoints. [TS_PROM_WEB_TELEMETRY_PATH] (-web-telemetry-path)
        '';
      };

      extraOptions = mkOption {
        default = [];
        type = types.listOf types.str;
        example = literalExample ''
          [ "-async-acks"
          ]
        '';
        description = ''
          Extra command line arguments to pass to promscale.
        '';
      };

    };

  };

  config = mkIf cfg.enable {

    meta.maintainers = with lib.maintainers; [ _0x4A6F ];

    assertions = [
      {
        assertion = !((cfg.database.host == "localhost" || cfg.database.host == "::1" || cfg.database.host == "127.0.0.1")) -> (cfg.database.passwordFile != null);
        message = ''
          When `services.promscale.database.host` is changed from "localhost", `services.promscale.database.passwordFile` must be set!
        '';
      }
      {
        assertion = (cfg.leaderElection.pg.advisoryLockId != null || cfg.leaderElection.pg.advisoryLockPrometheusTimeout != null) -> (cfg.leaderElection.pg.advisoryLockId != null && cfg.leaderElection.pg.advisoryLockPrometheusTimeout != null);
        message = ''
          Both `services.promscale.leaderElection.pg.advisoryLockId` and `services.promscale.leaderElection.pg.advisoryLockPrometheusTimeout` must be set!
        '';
      }
      {
        assertion = (cfg.leaderElection.rest == true) -> (cfg.leaderElection.pg.advisoryLockId == null && cfg.leaderElection.pg.advisoryLockPrometheusTimeout == null);
        message = ''
          When `services.promscale.leaderElection.rest` is set, following must *NOT* be set:
            - `services.promscale.leaderElection.pg.advisoryLockId`
            - `services.promscale.leaderElection.pg.advisoryLockPrometheusTimeout`
        '';
      }
    ];

    systemd.services.promscale = {

      description = "promscale: Timescale-Prometheus connector";
      wantedBy = [ "multi-user.target" ];
      requires = mkIf ((cfg.database.host == "localhost" || cfg.database.host == "::1" || cfg.database.host == "127.0.0.1")) [ "postgresql.service" ];
      after =  mkIf ((cfg.database.host == "localhost" || cfg.database.host == "::1" || cfg.database.host == "127.0.0.1")) [ "postgresql.service" ];

      serviceConfig = {
        User = "promscale";
        Group = "promscale";
        DynamicUser = "yes";
        RuntimeDirectory = "promscale";
        StateDirectory = "promscale";
        StateDirectoryMode = "0700";
        PrivateDevices = true;
        # Sandboxing
        CapabilityBoundingSet = [ "CAP_NET_RAW" "CAP_NET_ADMIN" ];
        ExecStart = ''
          ${cfg.package}/bin/promscale ${lib.concatStringsSep " " cfg.extraOptions} \
            ${optionalString (cfg.asyncAcks != null) "-async-acks=${boolToString cfg.asyncAcks}"} \
            ${optionalString (cfg.installTimescaledb != null) "-install-timescaledb=${boolToString cfg.installTimescaledb}"} \
            ${optionalString (cfg.labelsCacheSize != null) "-labels-cache-size ${toString cfg.labelsCacheSize}"} \
            ${optionalString (cfg.useSchemaVersionLease != null) "-use-schema-version-lease=${boolToString cfg.useSchemaVersionLease}"} \
            ${optionalString (cfg.leaderElection.pg.advisoryLockId != null) "-leader-election-pg-advisory-lock-id ${toString cfg.leaderElection.pg.advisoryLockId}"} \
            ${optionalString (cfg.leaderElection.pg.advisoryLockPrometheusTimeout != null) "-leader-election-pg-advisory-lock-prometheus-timeout ${cfg.leaderElection.pg.advisoryLockPrometheusTimeout}"} \
            ${optionalString (cfg.leaderElection.rest != null) "-leader-election-rest=${boolToString cfg.leaderElection.rest}"} \
            ${optionalString (cfg.leaderElection.scheduledElectionInterval != null) "-scheduled-election-interval ${cfg.leaderElection.scheduledElectionInterval}"} \
            ${optionalString (cfg.logLevel != null) "-log-level ${cfg.logLevel}"} \
            ${optionalString (cfg.metricsCacheSize != null) "-metrics-cache-size ${toString cfg.metricsCacheSize}"} \
            ${optionalString (cfg.migrate != null) "-migrate ${cfg.migrate}"} \
            ${optionalString (cfg.tputReport != null) "-tput-report ${toString cfg.tputReport}"} \
            ${optionalString (cfg.web.listenPort != null) "-web-listen-address ${cfg.web.listenAddress}:${toString cfg.web.listenPort}"} \
            ${optionalString (cfg.web.telemetryPath != null) "-web-telemetry-path ${cfg.web.telemetryPath}"} \
            ${optionalString (cfg.database.connectRetries != null) "-db-connect-retries ${toString cfg.database.connectRetries}"} \
            ${optionalString (cfg.database.connectionsMax != null) "-db-connections-max ${toString cfg.database.connectionsMax}"} \
            ${optionalString (cfg.database.host != null) "-db-host ${cfg.database.host}"} \
            ${optionalString (cfg.database.name != null) "-db-name ${cfg.database.name}"} \
            ${optionalString (cfg.database.port != null) "-db-port ${toString cfg.database.port}"} \
            ${optionalString (cfg.database.user != null) "-db-user ${cfg.database.user}"} \
            ${optionalString (cfg.database.sslMode != null) "-db-ssl-mode ${cfg.database.sslMode}"} \
            ${optionalString (cfg.database.passwordFile != null) "-db-password $(head -n 1 ${cfg.database.passwordFile})"}
        '';
      };

    };

  };

}
