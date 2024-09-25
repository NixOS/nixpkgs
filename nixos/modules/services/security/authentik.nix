{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    types
    mkOption
    mkEnableOption
    mkPackageOption
    ;
  cfg = config.services.authentik;

  isRedisUnixSocket = lib.hasPrefix "/" cfg.redis.host;

  commonServiceConfig = {
    Type = "simple";
    User = cfg.user;
    Group = cfg.group;
    Restart = "always";
    RestartSec = 3;
    RuntimeDirectory = "authentik";
    NoNewPrivileges = true;
    PrivateTmp = true;
    ProtectHome = true;
    ProtectSystem = "strict";
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectControlGroups = true;
    SystemCallFilter = "~@cpu-emulation @keyring @module @obsolete @raw-io @reboot @swap @sync";
    ConfigurationDirectory = "authentik";
  };
in
{
  options.services.authentik = {
    enable = mkEnableOption "authentik";
    package = mkPackageOption pkgs "authentik" { };

    secretsFile = mkOption {
      type = types.nullOr (
        types.str
        // {
          # We don't want users to be able to pass a path literal here but
          # it should look like a path.
          check = it: lib.isString it && lib.types.path.check it;
        }
      );
      default = null;
      example = "/run/secrets/authentik";
      description = ''
        Path of a file with extra environment variables to be loaded from disk.
        This file is not added to the nix store, so it can be used to pass secrets to authentik.
        Refer to the [documentation](https://docs.goauthentik.io/docs/installation/configuration) for options.

        authentik requires at least a secret key:
        ```
        AUTHENTIK_SECRET_KEY=<random key>
        ```
        You can also use services.authentik.environment.AUTHENTIK_SECRET_KEY = 'file:///path/to/secret' instead
      '';
    };
    environment = mkOption {
      type = types.attrsOf types.str;
      default = { };
      example = {
        AUTHENTIK_LOG_LEVEL = "debug";
      };
      description = ''
        Extra configuration environment variables. Refer to the [documentation](https://docs.goauthentik.io/docs/installation/configuration) for options.
      '';
    };

    host = lib.mkOption {
      type = types.str;
      default = "localhost";
      description = "The host that authentik will listen on.";
    };
    httpPort = mkOption {
      type = types.port;
      default = 9000;
      description = "The http port that authentik will listen on.";
    };
    httpsPort = mkOption {
      type = types.port;
      default = 9443;
      description = "The https port that authentik will listen on.";
    };
    user = mkOption {
      type = types.str;
      default = "authentik";
      description = "The user authentik should run as.";
    };
    group = mkOption {
      type = types.str;
      default = "authentik";
      description = "The group authentik should run as.";
    };
    database = {
      enable =
        mkEnableOption "the postgresql database for use with authentik. See {option}`services.postgresql`"
        // {
          default = true;
        };
      createDB = mkEnableOption "the automatic creation of the database for authentik." // {
        default = true;
      };
      name = mkOption {
        type = types.str;
        default = "authentik";
        description = "The name of the authentik database.";
      };
      host = mkOption {
        type = types.str;
        default = "/run/postgresql";
        example = "127.0.0.1";
        description = "Hostname or address of the postgresql server. If an absolute path is given here, it will be interpreted as a unix socket path.";
      };
      port = mkOption {
        type = types.port;
        default = 5432;
        description = "The port of the postgresql server";
      };
      user = mkOption {
        type = types.str;
        default = "authentik";
        description = "The database user for authentik.";
      };
    };
    redis = {
      enable = mkEnableOption "a redis cache for use with authentik" // {
        default = true;
      };
      host = mkOption {
        type = types.str;
        default = config.services.redis.servers.authentik.unixSocket;
        defaultText = lib.literalExpression "config.services.redis.servers.authentik.unixSocket";
        description = "The host that redis will listen on.";
      };
      port = mkOption {
        type = types.port;
        default = 0;
        description = "The port that redis will listen on. Set to zero to disable TCP.";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.database.createDB -> cfg.database.name == cfg.database.user;
        message = "The postgres module requires the database name and the database user name to be the same.";
      }
      {
        assertion = cfg.secretsFile == null -> lib.hasPrefix "file://" cfg.environment.AUTHENTIK_SECRET_KEY;
        message = "If no secretsFile is provided, services.authentik.environment has to provide AUTHENTIK_SECRET_KEY with a file:// prefix";
      }
      {
        assertion = cfg.secretsFile != null -> !(cfg.environment ? "AUTHENTIK_SECRET_KEY");
        message = "Possibly conflicting AUTHENTIK_SECRET_KEY definition in secretsFile and services.authentik.environment";
      }
    ];

    systemd.services.authentik-server = {
      description = "Authentik server component";
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      inherit (cfg) environment;

      serviceConfig = commonServiceConfig // {
        ExecStart = "${lib.getExe cfg.package} server";
        EnvironmentFile = cfg.secretsFile;
      };
    };

    systemd.services.authentik-worker = {
      description = "Authentik worker component";
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      inherit (cfg) environment;

      serviceConfig = commonServiceConfig // {
        ExecStart = "${lib.getExe cfg.package} worker";
        EnvironmentFile = cfg.secretsFile;
      };
    };

    services.postgresql = mkIf cfg.database.enable {
      enable = true;
      ensureDatabases = mkIf cfg.database.createDB [ cfg.database.name ];
      ensureUsers = mkIf cfg.database.createDB [
        {
          name = cfg.database.user;
          ensureDBOwnership = true;
          ensureClauses.login = true;
        }
      ];
    };

    services.authentik.environment = {
      AUTHENTIK_CACHE__URL = mkIf isRedisUnixSocket "unix://${cfg.redis.host}";
      AUTHENTIK_CHANNEL__URL = mkIf isRedisUnixSocket "unix://${cfg.redis.host}";
      AUTHENTIK_RESULT_BACKEND__URL = mkIf isRedisUnixSocket "redis+socket://${cfg.redis.host}";
      AUTHENTIK_BROKER__URL = mkIf isRedisUnixSocket "redis+socket://${cfg.redis.host}";
      AUTHENTIK_REDIS__HOST = mkIf (!isRedisUnixSocket) cfg.redis.host;
      AUTHENTIK_REDIS__PORT = mkIf (!isRedisUnixSocket) (toString cfg.redis.port);
      AUTHENTIK_POSTGRESQL__HOST = cfg.database.host;
      AUTHENTIK_POSTGRESQL__NAME = cfg.database.name;
      AUTHENTIK_POSTGRESQL__USER = cfg.database.user;
      AUTHENTIK_POSTGRESQL__PORT = toString cfg.database.port;
      AUTHENTIK_LISTEN_HTTP = "${cfg.host}:${toString cfg.httpPort}";
      AUTHENTIK_LISTEN_HTTPS = "${cfg.host}:${toString cfg.httpsPort}";
    };

    services.redis.servers = mkIf cfg.redis.enable {
      authentik = {
        enable = true;
        user = cfg.user;
        port = cfg.redis.port;
        bind = mkIf (!isRedisUnixSocket) cfg.redis.host;
      };
    };

    users.users = mkIf (cfg.user == "authentik") {
      authentik = {
        name = "authentik";
        group = cfg.group;
        isSystemUser = true;
      };
    };
    users.groups = mkIf (cfg.group == "authentik") { authentik = { }; };
  };
}
