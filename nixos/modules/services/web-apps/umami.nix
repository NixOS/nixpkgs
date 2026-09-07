{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    concatStringsSep
    filterAttrs
    getExe
    hasPrefix
    hasSuffix
    isString
    literalExpression
    maintainers
    mapAttrs
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optional
    optionalString
    types
    ;

  cfg = config.services.umami;

  nonFileSettings = filterAttrs (k: _: !hasSuffix "_FILE" k) cfg.settings;
in
{
  options.services.umami = {
    enable = mkEnableOption "umami";

    package = mkPackageOption pkgs "umami" { } // {
      apply =
        pkg:
        pkg.override {
          collectApiEndpoint = optionalString (
            cfg.settings.COLLECT_API_ENDPOINT != null
          ) cfg.settings.COLLECT_API_ENDPOINT;
          trackerScriptNames = cfg.settings.TRACKER_SCRIPT_NAME;
          basePath = cfg.settings.BASE_PATH;
        };
    };

    createPostgresqlDatabase = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = ''
        Whether to automatically create the database for Umami using PostgreSQL.
        Both the database name and username will be `umami`, and the connection is
        made through unix sockets using peer authentication.
      '';
    };

    settings = mkOption {
      description = ''
        Additional configuration (environment variables) for Umami, see
        <https://umami.is/docs/environment-variables> for supported values.
      '';

      type = types.submodule {
        freeformType =
          with types;
          attrsOf (oneOf [
            bool
            int
            str
          ]);

        options = {
          APP_SECRET_FILE = mkOption {
            type = types.nullOr (
              types.str
              // {
                # We don't want users to be able to pass a path literal here but
                # it should look like a path.
                check = it: isString it && types.path.check it;
              }
            );
            default = null;
            example = "/run/secrets/umamiAppSecret";
            description = ''
              A file containing a secure random string. This is used for signing user sessions.
              The contents of the file are read through systemd credentials, therefore the
              user running umami does not need permissions to read the file.
              If you wish to set this to a string instead (not recommended since it will be
              placed world-readable in the Nix store), you can use the APP_SECRET option.
            '';
          };
          DATABASE_URL = mkOption {
            type = types.nullOr (
              types.str
              // {
                check = it: isString it && ((hasPrefix "postgresql://" it) || (hasPrefix "postgres://" it));
              }
            );
            # For some reason, Prisma requires the username in the connection string
            # and can't derive it from the current user.
            default =
              if cfg.createPostgresqlDatabase then
                "postgresql://umami@localhost/umami?host=/run/postgresql"
              else
                null;
            defaultText = literalExpression ''if config.services.umami.createPostgresqlDatabase then "postgresql://umami@localhost/umami?host=/run/postgresql" else null'';
            example = "postgresql://root:root@localhost/umami";
            description = ''
              Connection string for the database. Must start with `postgresql://` or `postgres://`.
            '';
          };
          DATABASE_URL_FILE = mkOption {
            type = types.nullOr (
              types.str
              // {
                # We don't want users to be able to pass a path literal here but
                # it should look like a path.
                check = it: isString it && types.path.check it;
              }
            );
            default = null;
            example = "/run/secrets/umamiDatabaseUrl";
            description = ''
              A file containing a connection string for the database. The connection string
              must start with `postgresql://` or `postgres://`.
              The contents of the file are read through systemd credentials, therefore the
              user running umami does not need permissions to read the file.
            '';
          };
          COLLECT_API_ENDPOINT = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "/api/alternate-send";
            description = ''
              Allows you to send metrics to a location different than the default `/api/send`.
            '';
          };
          TRACKER_SCRIPT_NAME = mkOption {
            type = types.listOf types.str;
            default = [ ];
            example = [ "tracker.js" ];
            description = ''
              Allows you to assign a custom name to the tracker script different from the default `script.js`.
            '';
          };
          BASE_PATH = mkOption {
            type = types.str;
            default = "";
            example = "/analytics";
            description = ''
              Allows you to host Umami under a subdirectory.
              You may need to update your reverse proxy settings to correctly handle the BASE_PATH prefix.
            '';
          };
          DISABLE_UPDATES = mkOption {
            type = types.bool;
            default = true;
            example = false;
            description = ''
              Disables the check for new versions of Umami.
            '';
          };
          DISABLE_TELEMETRY = mkOption {
            type = types.bool;
            default = false;
            example = true;
            description = ''
              Umami collects completely anonymous telemetry data in order help improve the application.
              You can choose to disable this if you don't want to participate.
            '';
          };
          HOSTNAME = mkOption {
            type = types.str;
            default = "127.0.0.1";
            example = "0.0.0.0";
            description = ''
              The address to listen on.
            '';
          };
          PORT = mkOption {
            type = types.port;
            default = 3000;
            example = 3010;
            description = ''
              The port to listen on.
            '';
          };
        };
      };

      default = { };

      example = {
        APP_SECRET_FILE = "/run/secrets/umamiAppSecret";
        DISABLE_TELEMETRY = true;
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = (cfg.settings.APP_SECRET_FILE != null) != (cfg.settings ? APP_SECRET);
        message = "One (and only one) of services.umami.settings.APP_SECRET_FILE and services.umami.settings.APP_SECRET must be set.";
      }
      {
        assertion = (cfg.settings.DATABASE_URL_FILE != null) != (cfg.settings.DATABASE_URL != null);
        message = "One (and only one) of services.umami.settings.DATABASE_URL_FILE and services.umami.settings.DATABASE_URL must be set.";
      }
      {
        assertion =
          cfg.createPostgresqlDatabase
          -> cfg.settings.DATABASE_URL == "postgresql://umami@localhost/umami?host=/run/postgresql";
        message = "The option config.services.umami.createPostgresqlDatabase is enabled, but config.services.umami.settings.DATABASE_URL has been modified.";
      }
      {
        assertion = cfg.settings.DATABASE_TYPE or null != "mysql";
        message = "Umami only supports PostgreSQL as of 3.0.0. Follow migration instructions if you are using MySQL: https://umami.is/docs/guides/migrate-mysql-postgresql";
      }
    ];

    services.postgresql = mkIf cfg.createPostgresqlDatabase {
      enable = true;
      ensureDatabases = [ "umami" ];
      ensureUsers = [
        {
          name = "umami";
          ensureDBOwnership = true;
          ensureClauses.login = true;
        }
      ];
    };

    systemd.services.umami = {
      environment = mapAttrs (_: toString) nonFileSettings;

      description = "Umami: a simple, fast, privacy-focused alternative to Google Analytics";
      after = [ "network.target" ] ++ (optional (cfg.createPostgresqlDatabase) "postgresql.service");
      wantedBy = [ "multi-user.target" ];

      script =
        let
          loadCredentials =
            (optional (
              cfg.settings.APP_SECRET_FILE != null
            ) ''export APP_SECRET="$(systemd-creds cat appSecret)"'')
            ++ (optional (
              cfg.settings.DATABASE_URL_FILE != null
            ) ''export DATABASE_URL="$(systemd-creds cat databaseUrl)"'');
        in
        ''
          ${concatStringsSep "\n" loadCredentials}
          ${getExe cfg.package}
        '';

      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        RestartSec = 3;
        DynamicUser = true;

        LoadCredential =
          (optional (cfg.settings.APP_SECRET_FILE != null) "appSecret:${cfg.settings.APP_SECRET_FILE}")
          ++ (optional (
            cfg.settings.DATABASE_URL_FILE != null
          ) "databaseUrl:${cfg.settings.DATABASE_URL_FILE}");

        # Hardening
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        PrivateUsers = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateMounts = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = (optional cfg.createPostgresqlDatabase "AF_UNIX") ++ [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
      };
    };
  };

  meta.maintainers = with maintainers; [ diogotcorreia ];
}
