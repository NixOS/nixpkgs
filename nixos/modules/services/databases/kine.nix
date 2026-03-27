{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.kine;

  useSqlite = cfg.database.type == "sqlite";
  usePostgresql = cfg.database.type == "postgres";
  useMysql = cfg.database.type == "mysql";
  useNats = cfg.database.type == "nats";

  passwordPlaceholder = "__KINE_DB_PASSWORD__";

  userPart =
    if cfg.database.passwordFile != null then
      "${cfg.database.user}:${passwordPlaceholder}"
    else
      cfg.database.user;

  useEndpointFile = cfg.endpointFile != null;

  endpointTemplate =
    if cfg.endpoint != null then
      cfg.endpoint
    else if useSqlite then
      "sqlite://${cfg.database.path}"
    else if usePostgresql then
      let
        hostPart =
          if cfg.database.socket != null then
            "/${cfg.database.name}?host=${cfg.database.socket}"
          else
            "${cfg.database.host}:${toString cfg.database.port}/${cfg.database.name}";
      in
      "postgres://${userPart}@${hostPart}"
    else if useMysql then
      let
        hostPart =
          if cfg.database.socket != null then
            "unix(${cfg.database.socket})"
          else
            "tcp(${cfg.database.host}:${toString cfg.database.port})";
      in
      "mysql://${userPart}@${hostPart}/${cfg.database.name}"
    else
      "nats://${cfg.database.host}:${toString cfg.database.port}";

  envFile = "/run/kine/env";
in
{

  options.services.kine = {
    enable = lib.mkEnableOption "kine, an etcdshim that translates etcd API to RDMS";

    package = lib.mkPackageOption pkgs "kine" { };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0:2379";
      description = "Address and port on which kine will listen for client connections.";
    };

    endpoint = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "postgres://user@localhost:5432/kine";
      description = ''
        Raw storage backend endpoint URI. When set, this takes precedence over
        all `database.*` options.

        ::: {.warning}
        This value is embedded in the Nix store. Do not include credentials here.
        Use {option}`endpointFile` for endpoints containing secrets.
        :::
      '';
    };

    endpointFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/kine-endpoint";
      description = ''
        Path to a file containing the raw storage backend endpoint URI.
        The file is read at runtime via systemd's `LoadCredential`, keeping
        secrets out of the Nix store. When set, this takes precedence over
        {option}`endpoint` and all `database.*` options.
      '';
    };

    database = {
      type = lib.mkOption {
        type = lib.types.enum [
          "sqlite"
          "postgres"
          "mysql"
          "nats"
        ];
        default = "sqlite";
        example = "postgres";
        description = "Database engine to use as kine's storage backend.";
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "Database host address.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default =
          if usePostgresql then
            config.services.postgresql.settings.port
          else if useMysql then
            config.services.mysql.settings.mysqld.port
          else if useNats then
            config.services.nats.port
          else
            2379;
        defaultText = lib.literalExpression ''
          if config.services.kine.database.type == "postgres" then config.services.postgresql.settings.port
          else if config.services.kine.database.type == "mysql" then config.services.mysql.settings.mysqld.port
          else if config.services.kine.database.type == "nats" then config.services.nats.port
          else 2379
        '';
        description = "Database host port. Not used for SQLite.";
      };

      name = lib.mkOption {
        type = lib.types.str;
        default = "kine";
        description = "Database name.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "kine";
        description = "Database user.";
      };

      passwordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/run/secrets/kine-db-pass";
        description = ''
          Path to a file containing the database password.
          The password will be spliced into the endpoint URI at runtime.
        '';
      };

      socket = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default =
          if (cfg.database.createLocally && usePostgresql) then
            "/run/postgresql"
          else if (cfg.database.createLocally && useMysql) then
            "/run/mysqld/mysqld.sock"
          else
            null;
        defaultText = lib.literalExpression "null";
        example = "/run/mysqld/mysqld.sock";
        description = ''
          Path to the Unix socket for database connections.
          When set, the connection uses the socket instead of host:port.
          Automatically configured when `createLocally` is enabled for PostgreSQL or MySQL.
        '';
      };

      path = lib.mkOption {
        type = lib.types.str;
        default = "${cfg.dataDir}/db";
        defaultText = lib.literalExpression ''"''${config.services.kine.dataDir}/db"'';
        description = "Path to the SQLite database file.";
      };

      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to automatically provision the database locally.
          When enabled, the appropriate database service (PostgreSQL, MySQL, or NATS)
          is configured with the necessary database, user, and permissions.
          For SQLite, no extra provisioning is needed.
        '';
      };
    };

    metricsBindAddress = lib.mkOption {
      type = lib.types.str;
      default = ":8080";
      description = "Bind address for the Prometheus metrics endpoint.";
    };

    caFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "CA certificate file for backend database TLS.";
    };

    certFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Client certificate file for backend database TLS.";
    };

    keyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Client key file for backend database TLS.";
    };

    serverCertFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "TLS certificate file for the kine server (etcd API).";
    };

    serverKeyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "TLS key file for the kine server (etcd API).";
    };

    trustedCaFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "CA certificate file used to verify client certificates connecting to the kine server.";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/kine";
      description = "Directory for kine state data (used by SQLite backend).";
    };

    debug = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable trace-level debug logging.";
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "--compact-interval=10m"
        "--slow-sql-threshold=2s"
      ];
      description = "Extra command-line arguments to pass to kine.";
    };

  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.database.createLocally -> useSqlite || useNats || cfg.database.user == "kine";
        message = "services.kine.database.user must be \"kine\" if the database is to be automatically provisioned";
      }
      {
        assertion = cfg.database.createLocally && usePostgresql -> cfg.database.user == cfg.database.name;
        message = ''
          When creating a PostgreSQL database via NixOS, the db user and db name must be equal.
          If you already have an existing database, set `services.kine.database.createLocally` to `false`.
        '';
      }
      {
        assertion = !(cfg.endpoint != null && cfg.endpointFile != null);
        message = "`services.kine.endpoint` and `services.kine.endpointFile` are mutually exclusive.";
      }
      {
        assertion = cfg.database.passwordFile != null -> (cfg.endpoint == null && !useEndpointFile);
        message = "`services.kine.database.passwordFile` can only be used with structured `database.*` options, not with `endpoint` or `endpointFile`.";
      }
      {
        assertion =
          (cfg.endpoint != null || useEndpointFile) -> !(cfg.database.createLocally && !useSqlite);
        message = ''
          When using a raw endpoint (via `endpoint` or `endpointFile`), set `database.createLocally`
          to `false` to avoid provisioning a local database that won't be used.
        '';
      }
    ];

    services.postgresql = lib.optionalAttrs (usePostgresql && cfg.database.createLocally) {
      enable = lib.mkDefault true;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensureDBOwnership = true;
        }
      ];
    };

    services.mysql = lib.optionalAttrs (useMysql && cfg.database.createLocally) {
      enable = lib.mkDefault true;
      package = lib.mkDefault pkgs.mariadb;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensurePermissions = {
            "${cfg.database.name}.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    services.nats = lib.optionalAttrs (useNats && cfg.database.createLocally) {
      enable = lib.mkDefault true;
      jetstream = lib.mkDefault true;
    };

    systemd.tmpfiles.settings."10-kine".${cfg.dataDir}.d = {
      user = "kine";
      mode = "0700";
    };

    systemd.services.kine = {
      description = "Kine - etcd API to RDMS translation layer";
      after = [
        "network-online.target"
      ]
      ++ lib.optional (cfg.database.createLocally && usePostgresql) "postgresql.service"
      ++ lib.optional (cfg.database.createLocally && useMysql) "mysql.service"
      ++ lib.optional (cfg.database.createLocally && useNats) "nats.service";
      wants = [ "network-online.target" ];
      requires =
        lib.optional (cfg.database.createLocally && usePostgresql) "postgresql.service"
        ++ lib.optional (cfg.database.createLocally && useMysql) "mysql.service"
        ++ lib.optional (cfg.database.createLocally && useNats) "nats.service";
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        umask 0077
        ${
          if useEndpointFile then
            ''
              endpoint="$(< "$CREDENTIALS_DIRECTORY/endpoint")"
            ''
          else
            ''
              endpoint=${lib.escapeShellArg endpointTemplate}
              ${lib.optionalString (cfg.database.passwordFile != null) ''
                password="$(< "$CREDENTIALS_DIRECTORY/db-password")"
                endpoint="''${endpoint//${passwordPlaceholder}/$password}"
              ''}
            ''
        }
        printf '%s' "$endpoint" > ${envFile}
      '';

      serviceConfig = {
        ExecStart =
          let
            args = [
              "--listen-address=${cfg.listenAddress}"
              "--metrics-bind-address=${cfg.metricsBindAddress}"
            ]
            ++ lib.optionals (cfg.caFile != null) [ "--ca-file=${cfg.caFile}" ]
            ++ lib.optionals (cfg.certFile != null) [ "--cert-file=${cfg.certFile}" ]
            ++ lib.optionals (cfg.keyFile != null) [ "--key-file=${cfg.keyFile}" ]
            ++ lib.optionals (cfg.serverCertFile != null) [ "--server-cert-file=${cfg.serverCertFile}" ]
            ++ lib.optionals (cfg.serverKeyFile != null) [ "--server-key-file=${cfg.serverKeyFile}" ]
            ++ lib.optionals (cfg.trustedCaFile != null) [ "--trusted-ca-file=${cfg.trustedCaFile}" ]
            ++ lib.optionals cfg.debug [ "--debug" ]
            ++ cfg.extraArgs;
          in
          "${pkgs.writeShellScript "kine-start" ''
            set -euo pipefail
            export KINE_ENDPOINT="$(< ${envFile})"
            exec ${lib.getBin cfg.package}/bin/kine ${lib.escapeShellArgs args}
          ''}";
        LoadCredential =
          lib.optional (cfg.database.passwordFile != null) "db-password:${cfg.database.passwordFile}"
          ++ lib.optional useEndpointFile "endpoint:${cfg.endpointFile}";
        RuntimeDirectory = "kine";
        RuntimeDirectoryMode = "0700";
        Restart = "on-failure";
        RestartSec = "15s";
        User = "kine";
        WorkingDirectory = cfg.dataDir;
        StateDirectory = lib.removePrefix "/var/lib/" cfg.dataDir;
        LimitNOFILE = 40000;
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [ cfg.dataDir ];
      };
    };

    users.users.kine = {
      isSystemUser = true;
      group = "kine";
      description = "Kine daemon user";
      home = cfg.dataDir;
    };
    users.groups.kine = { };
  };

  meta.maintainers = pkgs.kine.meta.maintainers;

}
