{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.hindsight-api;
  inherit (lib) mkIf mkOption types;
  # Socket URI: explicit role for peer auth (PG role == dynamic service user
  # "hindsight-api"); no ?host= since hindsight percent-encodes query values,
  # breaking alembic. NixOS patches DEFAULT_PGSOCKET_DIR to /run/postgresql.
  dbUri =
    if cfg.database.uri != null then
      cfg.database.uri
    else if cfg.database.createLocally then
      "postgresql://hindsight-api@/${cfg.database.name}"
    else
      null;
in
{
  meta.maintainers = with lib.maintainers; [ gdifolco ];

  options.services.hindsight-api = {
    enable = lib.mkEnableOption "hindsight-api server";

    package = lib.mkPackageOption pkgs [ "python3Packages" "hindsight-api" ] { };

    host = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = ''
        IP address the hindsight-api server binds to.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 8888;
      description = ''
        Port the hindsight-api server listens on.
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Open ports in the firewall for the hindsight-api server.
      '';
    };

    settings = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = ''
        Free-form `HINDSIGHT_API_*` environment variables passed to the server
        (e.g. `HINDSIGHT_API_LLM_PROVIDER`, `HINDSIGHT_API_EMBEDDINGS_PROVIDER`,
        `HINDSIGHT_API_RERANKER_PROVIDER`). Values must be strings; use
        `toString` for numerics.

        The packaged `hindsight-api` ships no local embeddings, reranker or LLM
        runtime, so the upstream default `local` providers cannot be used. Set
        `HINDSIGHT_API_EMBEDDINGS_PROVIDER` (openai/gemini/cohere/tei/…) and
        `HINDSIGHT_API_RERANKER_PROVIDER` (a remote provider, or `none`) plus the
        corresponding API keys. Prefer [](#opt-services.hindsight-api.environmentFile)
        for secrets.
      '';
    };

    environmentFile = mkOption {
      type = types.nullOr types.externalPath;
      default = null;
      description = ''
        Environment file, e.g. for `HINDSIGHT_API_LLM_API_KEY` or a
        `HINDSIGHT_API_DATABASE_URL` containing a password.
      '';
    };

    database = {
      createLocally = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to provision a local PostgreSQL database with the pgvector
          extension for hindsight-api.
        '';
      };

      name = mkOption {
        type = types.str;
        default = "hindsight";
        description = ''
          Name of the local PostgreSQL database. Only used when
          [](#opt-services.hindsight-api.database.createLocally) is enabled.
        '';
      };

      uri = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Database URI overriding the locally derived socket URI. When `null`
          and [](#opt-services.hindsight-api.database.createLocally) is enabled, a
          local peer-authenticated socket URI is derived; otherwise
          `HINDSIGHT_API_DATABASE_URL` must be provided through
          [](#opt-services.hindsight-api.settings) or
          [](#opt-services.hindsight-api.environmentFile).

          An external database must have the `vector` (pgvector) extension
          installed.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion =
          cfg.database.createLocally
          || cfg.database.uri != null
          || cfg.settings ? "HINDSIGHT_API_DATABASE_URL"
          || cfg.environmentFile != null;
        message = "hindsight-api needs a database URL: set services.hindsight-api.database.uri, or HINDSIGHT_API_DATABASE_URL in settings/environmentFile.";
      }
    ];

    services.postgresql = mkIf cfg.database.createLocally {
      enable = true;
      extensions = ps: with ps; [ pgvector ];
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [ { name = "hindsight-api"; } ];
    };

    systemd.services.postgresql-setup.serviceConfig.ExecStartPost =
      let
        sqlFile = pkgs.writeText "hindsight-pgvector.sql" ''
          ALTER DATABASE "${cfg.database.name}" OWNER TO "hindsight-api";
          CREATE EXTENSION IF NOT EXISTS vector;
        '';
      in
      mkIf cfg.database.createLocally [
        ''${lib.getExe' config.services.postgresql.package "psql"} -d "${cfg.database.name}" -f "${sqlFile}"''
      ];

    systemd.services.hindsight-api = {
      description = "hindsight-api server";
      after = [
        "network-online.target"
      ]
      ++ lib.optionals cfg.database.createLocally [
        "postgresql.target"
        "postgresql-setup.service"
      ];
      wants = [
        "network-online.target"
      ]
      ++ lib.optionals cfg.database.createLocally [
        "postgresql.target"
        "postgresql-setup.service"
      ];
      requires = lib.optionals cfg.database.createLocally [
        "postgresql.target"
        "postgresql-setup.service"
      ];
      wantedBy = [ "multi-user.target" ];

      environment =
        cfg.settings
        // {
          HINDSIGHT_API_HOST = cfg.host;
          HINDSIGHT_API_PORT = toString cfg.port;
        }
        // (lib.optionalAttrs (dbUri != null) { HINDSIGHT_API_DATABASE_URL = dbUri; });

      serviceConfig = {
        ExecStart = "${lib.getExe' cfg.package "hindsight-api"}";
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) [ cfg.environmentFile ];
        Type = "simple";
        Restart = "on-failure";
        RestartSec = 5;
        DynamicUser = true;
        StateDirectory = "hindsight-api";
        RuntimeDirectory = "hindsight-api";
        RuntimeDirectoryMode = "0700";

        # Hardening
        CapabilityBoundingSet = "";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        UMask = "0077";
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];
  };
}
