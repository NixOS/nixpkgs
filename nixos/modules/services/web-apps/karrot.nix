{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.karrot;

  effectiveSecretKeyFile =
    if cfg.secretKeyFile != null then cfg.secretKeyFile else "${cfg.dataDir}/secret.key";

  databaseHost =
    if cfg.database.host != "" then
      cfg.database.host
    else if cfg.database.createLocally then
      "/run/postgresql"
    else
      "";

  redisSocket =
    if cfg.redis.socket != null then
      cfg.redis.socket
    else if cfg.redis.createLocally then
      config.services.redis.servers.karrot.unixSocket
    else
      null;

  envVars = {
    HOME = cfg.dataDir;
    MODE = cfg.settings.mode;
    BASE_URL = cfg.settings.baseUrl;
    LISTEN_HOST = cfg.settings.listen.host;
    LISTEN_PORT = toString cfg.settings.listen.port;
    LISTEN_CONCURRENCY = toString cfg.settings.listen.concurrency;
    FILE_UPLOAD_DIR = "${cfg.dataDir}/uploads/";
    PLUGIN_DIR = "${cfg.dataDir}/plugins/";
    DATABASE_NAME = cfg.database.name;
    DATABASE_USER = cfg.database.user;
    DATABASE_PASSWORD = "";
    DATABASE_PORT = toString cfg.database.port;
  }
  // lib.optionalAttrs (databaseHost != "") {
    DATABASE_HOST = databaseHost;
  }
  // lib.optionalAttrs (redisSocket != null) {
    REDIS_SOCKET = redisSocket;
  }
  // lib.optionalAttrs (redisSocket == null) {
    REDIS_HOST = cfg.redis.host;
    REDIS_PORT = toString cfg.redis.port;
    REDIS_DB = toString cfg.redis.db;
  }
  // lib.optionalAttrs (cfg.settings.listen.socket != null) {
    LISTEN_SOCKET = cfg.settings.listen.socket;
  }
  // lib.optionalAttrs (cfg.settings.allowedHosts != [ ]) {
    ALLOWED_HOSTS = lib.concatStringsSep "," cfg.settings.allowedHosts;
  }
  // lib.optionalAttrs (cfg.settings.csrfTrustedOrigins != [ ]) {
    CSRF_TRUSTED_ORIGINS = lib.concatStringsSep "," cfg.settings.csrfTrustedOrigins;
  }
  // lib.optionalAttrs (cfg.settings.adminEmails != [ ]) {
    ADMIN_EMAILS = lib.concatStringsSep "," cfg.settings.adminEmails;
  }
  // cfg.extraEnvironment;

  envFile = pkgs.writeText "karrot.env" (
    lib.pipe envVars [
      (lib.mapAttrsToList (name: value: "${name}=\"${toString value}\""))
      (lib.concatStringsSep "\n")
    ]
  );

  loadCreds = ''
    if [ -n "''${CREDENTIALS_DIRECTORY:-}" ] && [ -f "$CREDENTIALS_DIRECTORY/secret-key" ]; then
      export SECRET_KEY="$(<"$CREDENTIALS_DIRECTORY/secret-key")"
    elif [ -f "${effectiveSecretKeyFile}" ]; then
      export SECRET_KEY="$(<"${effectiveSecretKeyFile}")"
    fi
    ${lib.optionalString (cfg.database.passwordFile != null) ''
      if [ -n "''${CREDENTIALS_DIRECTORY:-}" ] && [ -f "$CREDENTIALS_DIRECTORY/db-password" ]; then
        export DATABASE_PASSWORD="$(<"$CREDENTIALS_DIRECTORY/db-password")"
      elif [ -f "${cfg.database.passwordFile}" ]; then
        export DATABASE_PASSWORD="$(<"${cfg.database.passwordFile}")"
      fi
    ''}
  '';

  karrotManageScript =
    let
      manageWrapper = pkgs.writeShellScript "karrot-manage-wrapper" ''
        set -eou pipefail
        if [ ! -f "${effectiveSecretKeyFile}" ]; then
          (umask 077; ${pkgs.coreutils}/bin/tr -dc 'a-zA-Z0-9' < /dev/urandom | ${pkgs.coreutils}/bin/head -c 50 > "${effectiveSecretKeyFile}")
        fi
        ${loadCreds}
        exec ${lib.getExe cfg.package} "$@"
      '';
      systemdRunArgs = lib.escapeShellArgs (
        [
          "--quiet"
          "--collect"
          "--pipe"
          "--pty"
          "--wait"
          "--service-type=exec"
          "--property=DynamicUser=yes"
          "--property=User=karrot"
          "--property=Group=karrot"
          "--property=StateDirectory=karrot"
          "--property=WorkingDirectory=${cfg.dataDir}"
          "--property=EnvironmentFile=${envFile}"
        ]
        ++ map (f: "--property=EnvironmentFile=${f}") cfg.environmentFiles
        ++ lib.optional cfg.redis.createLocally "--property=SupplementaryGroups=${config.services.redis.servers.karrot.group}"
        ++ lib.optional (
          cfg.secretKeyFile != null
        ) "--property=LoadCredential=secret-key:${cfg.secretKeyFile}"
        ++ lib.optional (
          cfg.database.passwordFile != null
        ) "--property=LoadCredential=db-password:${cfg.database.passwordFile}"
        ++ [
          "--"
          manageWrapper
        ]
      );
    in
    pkgs.writeShellScriptBin "karrot-manage" ''
      set -eou pipefail
      if [[ "$EUID" -ne 0 ]]; then
        exec ${config.security.wrapperDir}/sudo "$0" "$@"
      fi
      exec ${lib.getExe' config.systemd.package "systemd-run"} ${systemdRunArgs} "$@"
    '';
in
{
  options.services.karrot = {
    enable = lib.mkEnableOption "Karrot grassroots initiative coordination platform";

    package = lib.mkPackageOption pkgs "karrot" { };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/karrot";
      description = "Directory where Karrot stores state such as uploaded files and plugins.";
    };

    secretKeyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        File containing the Django secret key.
        If null, a key will automatically be generated in {file}`''${dataDir}/secret.key` on first start.
      '';
    };

    settings = {
      mode = lib.mkOption {
        type = lib.types.enum [
          "dev"
          "prod"
        ];
        default = "prod";
        description = "Running mode for Karrot.";
      };

      baseUrl = lib.mkOption {
        type = lib.types.str;
        default = "http://localhost:${toString cfg.settings.listen.port}";
        defaultText = lib.literalExpression ''"http://localhost:''${toString config.services.karrot.settings.listen.port}"'';
        example = "https://karrot.example.org";
        description = "Public base URL where Karrot is reachable.";
      };

      allowedHosts = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "localhost"
          "127.0.0.1"
        ];
        description = "List of host/domain names that this Karrot site can serve.";
      };

      csrfTrustedOrigins = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "List of trusted origins for CSRF protection.";
      };

      adminEmails = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Email addresses of initial instance administrators.";
      };

      listen = {
        host = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1";
          description = "Address on which the Karrot web server will listen.";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 8000;
          description = "Port on which the Karrot web server will listen.";
        };

        socket = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "Path to a Unix domain socket for Karrot to bind to instead of TCP.";
        };

        concurrency = lib.mkOption {
          type = lib.types.int;
          default = 2;
          description = "Number of worker processes for gunicorn/uvicorn.";
        };
      };
    };

    database = {
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to create a local PostgreSQL database automatically.";
      };

      name = lib.mkOption {
        type = lib.types.str;
        default = "karrot";
        description = "PostgreSQL database name.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "karrot";
        description = "PostgreSQL database user.";
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "PostgreSQL database host. If empty, connects via Unix domain socket.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 5432;
        description = "PostgreSQL database port.";
      };

      passwordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "File containing the password for PostgreSQL connection.";
      };
    };

    redis = {
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to configure and start a local Redis server instance automatically.";
      };

      socket = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to Redis Unix domain socket.";
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "Redis server host.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 6379;
        description = "Redis server port.";
      };

      db = lib.mkOption {
        type = lib.types.int;
        default = 0;
        description = "Redis database index.";
      };
    };

    extraEnvironment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Extra environment variables passed to Karrot.";
    };

    environmentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      description = "Environment files containing additional configuration and secrets.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the firewall port for Karrot.";
    };

    nginx = {
      enable = lib.mkEnableOption "Nginx virtual host reverse proxy for Karrot";

      hostName = lib.mkOption {
        type = lib.types.str;
        default = config.networking.fqdnOrHostName;
        defaultText = lib.literalExpression "config.networking.fqdnOrHostName";
        description = "Host name for the Nginx virtual host.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.database.createLocally -> cfg.database.user == "karrot";
        message = "services.karrot.database.user must be \"karrot\" when database.createLocally is true, as peer authentication requires the database user to match the dynamic user name.";
      }
    ];

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.settings.listen.port ];

    services.postgresql = lib.mkIf cfg.database.createLocally {
      enable = true;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensureDBOwnership = true;
        }
      ];
    };

    services.redis.servers.karrot = lib.mkIf cfg.redis.createLocally {
      enable = true;
    };

    environment.systemPackages = [ karrotManageScript ];

    services.nginx = lib.mkIf cfg.nginx.enable {
      enable = true;
      virtualHosts.${cfg.nginx.hostName} = {
        locations."/" = {
          proxyPass = "http://${cfg.settings.listen.host}:${toString cfg.settings.listen.port}";
          proxyWebsockets = true;
        };
      };
    };

    systemd.services.karrot = {
      description = "Karrot Web Server";
      after = [
        "network.target"
      ]
      ++ lib.optional cfg.database.createLocally "postgresql.target"
      ++ lib.optional cfg.redis.createLocally "redis-karrot.service";
      requires =
        lib.optional cfg.database.createLocally "postgresql.target"
        ++ lib.optional cfg.redis.createLocally "redis-karrot.service";
      wantedBy = [ "multi-user.target" ];

      unitConfig = {
        StartLimitIntervalSec = 30;
        StartLimitBurst = 3;
      };

      environment = {
        PYTHONUNBUFFERED = "1";
      };

      preStart = ''
        if [ ! -f "${effectiveSecretKeyFile}" ]; then
          (umask 077; ${pkgs.coreutils}/bin/tr -dc 'a-zA-Z0-9' < /dev/urandom | ${pkgs.coreutils}/bin/head -c 50 > "${effectiveSecretKeyFile}")
        fi
        ${pkgs.coreutils}/bin/mkdir -p "${cfg.dataDir}/uploads" "${cfg.dataDir}/plugins"
        ${loadCreds}
        ${cfg.package}/bin/karrot migrate
      '';

      script = ''
        ${loadCreds}
        exec ${lib.getExe cfg.package} server
      '';

      serviceConfig = {
        Type = "exec";
        User = "karrot";
        Group = "karrot";
        DynamicUser = true;
        SupplementaryGroups = lib.optional cfg.redis.createLocally config.services.redis.servers.karrot.group;
        LoadCredential =
          lib.optional (cfg.secretKeyFile != null) "secret-key:${cfg.secretKeyFile}"
          ++ lib.optional (cfg.database.passwordFile != null) "db-password:${cfg.database.passwordFile}";
        EnvironmentFile = [ envFile ] ++ cfg.environmentFiles;
        WorkingDirectory = cfg.dataDir;
        StateDirectory = "karrot";
        StateDirectoryMode = "0750";
        Restart = "on-failure";
        RestartSec = 2;

        # Hardening
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        PrivateTmp = true;
        ReadWritePaths = [ cfg.dataDir ];
      };
    };

    systemd.services.karrot-worker = {
      description = "Karrot Huey Background Worker";
      after = [
        "network.target"
        "karrot.service"
      ];
      requires = [ "karrot.service" ];
      bindsTo = [ "karrot.service" ];
      wantedBy = [ "multi-user.target" ];

      unitConfig = {
        StartLimitIntervalSec = 30;
        StartLimitBurst = 3;
      };

      environment = {
        PYTHONUNBUFFERED = "1";
      };

      script = ''
        ${loadCreds}
        exec ${cfg.package}/bin/karrot worker
      '';

      serviceConfig = {
        Type = "exec";
        User = "karrot";
        Group = "karrot";
        DynamicUser = true;
        SupplementaryGroups = lib.optional cfg.redis.createLocally config.services.redis.servers.karrot.group;
        LoadCredential =
          lib.optional (cfg.secretKeyFile != null) "secret-key:${cfg.secretKeyFile}"
          ++ lib.optional (cfg.database.passwordFile != null) "db-password:${cfg.database.passwordFile}";
        EnvironmentFile = [ envFile ] ++ cfg.environmentFiles;
        WorkingDirectory = cfg.dataDir;
        StateDirectory = "karrot";
        StateDirectoryMode = "0750";
        Restart = "on-failure";
        RestartSec = 2;

        # Hardening
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        PrivateTmp = true;
        ReadWritePaths = [ cfg.dataDir ];
      };
    };
  };

  meta.teams = with lib.teams; [ ngi ];
}
