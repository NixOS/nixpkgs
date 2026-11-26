{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.cleanuparr;

  # Mirrors Cleanuparr.Shared.Helpers.BasePathValidator: must start with '/', contain no dots or double slashes, no trailing slash, and only letters/numbers/hyphens/underscores per path segment.
  basePathValid = p: p == null || builtins.match "/[a-zA-Z0-9_-]+(/[a-zA-Z0-9_-]+)*" p != null;
in
{
  options.services.cleanuparr = {
    enable = lib.mkEnableOption "Cleanuparr, an advanced download queue cleaner for the *arr ecosystem";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.cleanuparr;
      defaultText = lib.literalExpression "pkgs.cleanuparr";
      description = "Package to use for Cleanuparr.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the firewall for the configured port.";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/cleanuparr";
      description = "Directory for Cleanuparr's persistent state.";
    };

    logsDir = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "/var/log/cleanuparr";
      description = "Directory for log files; `null` uses Cleanuparr's default.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "cleanuparr";
      description = "User account under which Cleanuparr runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "cleanuparr";
      description = "Group under which Cleanuparr runs.";
    };

    settings = {
      port = lib.mkOption {
        type = lib.types.port;
        default = 11011;
        description = "TCP port used by Cleanuparr's web UI and API.";
      };

      bindAddress = lib.mkOption {
        type = lib.types.str;
        default = "0.0.0.0";
        example = "127.0.0.1";
        description = "IP address or wildcard address on which Cleanuparr listens.";
      };

      basePath = lib.mkOption {
        type = lib.types.nullOr (lib.types.addCheck lib.types.str basePathValid);
        default = null;
        example = "/cleanuparr";
        description = "URL path prefix under which Cleanuparr is served.";
      };

      database = {
        provider = lib.mkOption {
          type = lib.types.enum [
            "sqlite"
            "postgres"
          ];
          default = "sqlite";
          description = "Database backend used by Cleanuparr.";
        };

        createLocally = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Whether to provision a local PostgreSQL instance when using PostgreSQL.";
        };

        host = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "localhost";
          description = "Host for an externally managed PostgreSQL instance.";
        };

        port = lib.mkOption {
          type = lib.types.nullOr lib.types.port;
          default = null;
          example = 5432;
          description = "Port for an externally managed PostgreSQL instance.";
        };

        user = lib.mkOption {
          type = lib.types.str;
          default = "cleanuparr";
          description = "PostgreSQL username.";
        };

        database = lib.mkOption {
          type = lib.types.str;
          default = "cleanuparr";
          example = "cleanuparr";
          description = "PostgreSQL database name.";
        };

        passwordFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "File containing the password for an external PostgreSQL instance.";
        };

        extraParams = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "SSL Mode=Require;Trust Server Certificate=true";
          description = "Additional PostgreSQL connection-string parameters.";
        };
      };
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Environment file for additional service variables.";
    };

    extraEnvironment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = lib.literalExpression ''
        {
          DOTNET_GCConserveMemory = "5";
          TZ = "Australia/Melbourne";
        }
      '';
      description = "Additional non-secret environment variables for Cleanuparr.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions =
      let
        pg = cfg.settings.database;
        isPg = pg.provider == "postgres";
      in
      [
        {
          assertion = isPg && !pg.createLocally -> pg.host != null;
          message = "services.cleanuparr.settings.database.host must be set when provider is \"postgres\" and createLocally is false.";
        }
        {
          assertion = isPg && !pg.createLocally -> pg.passwordFile != null;
          message = "services.cleanuparr.settings.database.passwordFile must be set when provider is \"postgres\" and createLocally is false.";
        }
        {
          assertion = isPg && pg.createLocally -> pg.host == null;
          message = "services.cleanuparr.settings.database.host is ignored (and must be unset) when createLocally is true.";
        }
        {
          assertion = isPg && pg.createLocally -> pg.passwordFile == null;
          message = "services.cleanuparr.settings.database.passwordFile is ignored (and must be unset) when createLocally is true — peer auth needs no password.";
        }
        {
          assertion = isPg && pg.createLocally -> pg.user == cfg.user;
          message = "services.cleanuparr.settings.database.user must match services.cleanuparr.user when createLocally is true, since peer authentication matches on OS username.";
        }
      ];

    users.users = lib.mkIf (cfg.user == "cleanuparr") {
      cleanuparr = {
        isSystemUser = true;
        group = cfg.group;
        home = cfg.dataDir;
      };
    };

    users.groups = lib.mkIf (cfg.group == "cleanuparr") {
      cleanuparr = { };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.settings.port ];

    # Fully self-provisioned local Postgres: role + database matching
    # `settings.database.user`/`.database`, connected to over the Unix
    # socket via peer auth (NixOS's default `local all all peer` rule
    # already covers this — no extra pg_hba entry needed).
    services.postgresql =
      lib.mkIf (cfg.settings.database.provider == "postgres" && cfg.settings.database.createLocally)
        {
          enable = lib.mkDefault true;
          ensureDatabases = [ cfg.settings.database.database ];
          ensureUsers = [
            {
              name = cfg.settings.database.user;
              ensureDBOwnership = true;
            }
          ];
        };

    # Owns dataDir/logsDir regardless of whether they're left at their
    # defaults or pointed somewhere custom by the user.
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0750 ${cfg.user} ${cfg.group} - -"
    ]
    ++ lib.optional (cfg.logsDir != null) "d ${cfg.logsDir} 0750 ${cfg.user} ${cfg.group} - -";

    systemd.services.cleanuparr =
      let
        pg = cfg.settings.database;
        isPg = pg.provider == "postgres";
        # Npgsql treats a Host starting with '/' as a Unix socket
        # directory; NixOS's postgresql module defaults to /run/postgresql.
        pgHost = if pg.createLocally then "/run/postgresql" else pg.host;
      in
      {
        description = "Cleanuparr";
        after = [ "network.target" ] ++ lib.optional (isPg && pg.createLocally) "postgresql.service";
        wantedBy = [ "multi-user.target" ];

        environment = {
          PORT = toString cfg.settings.port;
          BIND_ADDRESS = cfg.settings.bindAddress;
          CLEANUPARR_CONFIG_PATH = cfg.dataDir;
          DATABASE_PROVIDER = pg.provider;
        }
        // lib.optionalAttrs (cfg.settings.basePath != null) {
          BASE_PATH = cfg.settings.basePath;
        }
        // lib.optionalAttrs (cfg.logsDir != null) {
          CLEANUPARR_LOGS_PATH = cfg.logsDir;
        }
        // lib.optionalAttrs isPg (
          {
            POSTGRES_HOST = pgHost;
            POSTGRES_USER = pg.user;
            POSTGRES_DB = pg.database;
          }
          // lib.optionalAttrs pg.createLocally {
            # Cleanuparr's connection-string builder requires this env
            # var to be present regardless of auth method — it only
            # checks for a non-empty value, never validates it. Under
            # peer auth the Postgres server ignores the password
            # entirely, so this placeholder is not a secret.
            POSTGRES_PASS = "unused-peer-auth";
          }
          // lib.optionalAttrs (!pg.createLocally && pg.port != null) {
            POSTGRES_PORT = toString pg.port;
          }
          // lib.optionalAttrs (pg.extraParams != null) {
            POSTGRES_EXTRA_PARAMS = pg.extraParams;
          }
        )
        // cfg.extraEnvironment;

        # Cleanuparr only reads POSTGRES_PASS as a plain environment
        # variable, not from a credentials-directory path, so the
        # LoadCredential'd file has to be turned into an env var at start.
        # Everything else is set declaratively via `environment` above.
        script =
          if cfg.settings.database.passwordFile != null then
            ''
              export POSTGRES_PASS="$(cat "$CREDENTIALS_DIRECTORY/postgres-pass")"
              exec ${cfg.package}/bin/Cleanuparr
            ''
          else
            ''
              exec ${cfg.package}/bin/Cleanuparr
            '';

        serviceConfig = {
          User = cfg.user;
          Group = cfg.group;
          WorkingDirectory = cfg.dataDir;
          Restart = "on-failure";

          # Hardening
          NoNewPrivileges = true;
          PrivateTmp = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          ReadWritePaths = [ cfg.dataDir ] ++ lib.optional (cfg.logsDir != null) cfg.logsDir;
        }
        // lib.optionalAttrs (cfg.environmentFile != null) {
          EnvironmentFile = cfg.environmentFile;
        }
        // lib.optionalAttrs (cfg.settings.database.passwordFile != null) {
          LoadCredential = [ "postgres-pass:${cfg.settings.database.passwordFile}" ];
        };
      };
  };
  meta = {
    doc = ./cleanuparr.md;
    maintainers = with lib.maintainers; [ mistyttm ];
  };
}
