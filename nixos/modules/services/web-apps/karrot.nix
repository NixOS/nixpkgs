{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.karrot;

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

  allowedHosts =
    cfg.settings.allowedHosts
    ++ lib.optional (cfg.nginx.enable && !lib.elem cfg.nginx.hostName cfg.settings.allowedHosts) cfg.nginx.hostName;

  envVars = {
    HOME = cfg.dataDir;
    MODE = cfg.settings.mode;
    BASE_URL = cfg.settings.baseUrl;
    LISTEN_HOST = cfg.settings.listen.host;
    LISTEN_PORT = toString cfg.settings.listen.port;
    LISTEN_CONCURRENCY = toString cfg.settings.listen.concurrency;
    FILE_UPLOAD_DIR = "${cfg.dataDir}/uploads/";
    FILE_UPLOAD_MAX_SIZE = cfg.settings.uploads.maxSize;
    FILE_UPLOAD_USE_ACCEL_REDIRECT = lib.boolToString cfg.settings.uploads.useAccelRedirect;
    BACKGROUND_WORKER_COUNT = toString cfg.worker.count;
    BACKGROUND_WORKER_TYPE = cfg.worker.type;
    PLUGIN_DIR = "${cfg.dataDir}/plugins/";
    DATABASE_NAME = cfg.database.name;
    DATABASE_USER = cfg.database.user;
    DATABASE_PORT = toString cfg.database.port;
    SECRET_KEY_FILE =
      if cfg.secretKeyFile != null then cfg.secretKeyFile else "${cfg.dataDir}/secret.key";
  }
  // (
    if cfg.database.passwordFile != null then
      { DATABASE_PASSWORD_FILE = cfg.database.passwordFile; }
    else
      { DATABASE_PASSWORD = ""; }
  )
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
  // lib.optionalAttrs (allowedHosts != [ ]) {
    ALLOWED_HOSTS = lib.concatStringsSep "," allowedHosts;
  }
  // lib.optionalAttrs (cfg.settings.csrfTrustedOrigins != [ ]) {
    CSRF_TRUSTED_ORIGINS = lib.concatStringsSep "," cfg.settings.csrfTrustedOrigins;
  }
  // lib.optionalAttrs (cfg.settings.adminEmails != [ ]) {
    ADMIN_EMAILS = lib.concatStringsSep "," cfg.settings.adminEmails;
  }
  // lib.optionalAttrs (cfg.settings.geoipPath != null) {
    GEOIP_PATH = cfg.settings.geoipPath;
  }
  // cfg.extraEnvironment;

  envFile = pkgs.writeText "karrot.env" (
    lib.pipe envVars [
      (lib.mapAttrsToList (name: value: "${name}=\"${toString value}\""))
      (lib.concatStringsSep "\n")
    ]
  );

  commonEnvironment = {
    PYTHONUNBUFFERED = "1";
  }
  // lib.optionalAttrs (cfg.secretKeyFile != null) {
    SECRET_KEY_FILE = "%d/secret-key";
  }
  // lib.optionalAttrs (cfg.database.passwordFile != null) {
    DATABASE_PASSWORD_FILE = "%d/db-password";
  };

  karrotManageScript = pkgs.writeShellScriptBin "karrot-manage" ''
    set -a
    . ${envFile}
    ${lib.concatMapStringsSep "\n" (f: ''. "${f}"'') cfg.environmentFiles}
    set +a

    if [ "$(id -un)" = "${cfg.user}" ]; then
      exec ${lib.getExe cfg.package} "$@"
    else
      exec ${config.security.wrapperDir}/sudo -E -u ${cfg.user} ${lib.getExe cfg.package} "$@"
    fi
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

    user = lib.mkOption {
      type = lib.types.str;
      default = "karrot";
      description = "User account under which Karrot runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "karrot";
      description = "Group account under which Karrot runs.";
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
        default =
          if cfg.nginx.enable then
            let
              vhost = config.services.nginx.virtualHosts.${cfg.nginx.hostName};
              ssl = vhost.forceSSL || vhost.onlySSL || vhost.enableACME || vhost.addSSL;
            in
            "http${lib.optionalString ssl "s"}://${cfg.nginx.hostName}"
          else
            "http://${cfg.settings.listen.host}:${toString cfg.settings.listen.port}";
        defaultText = lib.literalExpression ''
          if config.services.karrot.nginx.enable then
            let
              vhost = config.services.nginx.virtualHosts.''${config.services.karrot.nginx.hostName};
              ssl = vhost.forceSSL || vhost.onlySSL || vhost.enableACME || vhost.addSSL;
            in
            "http''${lib.optionalString ssl "s"}://''${config.services.karrot.nginx.hostName}"
          else
            "http://''${config.services.karrot.settings.listen.host}:''${toString config.services.karrot.settings.listen.port}"
        '';
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

      uploads = {
        maxSize = lib.mkOption {
          type = lib.types.str;
          default = "25m";
          example = "50m";
          description = "Maximum size allowed for image and file attachment uploads.";
        };

        useAccelRedirect = lib.mkOption {
          type = lib.types.bool;
          default = cfg.nginx.enable;
          defaultText = lib.literalExpression "config.services.karrot.nginx.enable";
          description = "Whether to use Nginx X-Accel-Redirect for serving uploaded files.";
        };
      };

      geoipPath = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default =
          if config.services.geoipupdate.enable then
            config.services.geoipupdate.settings.DatabaseDirectory
          else
            null;
        defaultText = lib.literalExpression ''
          if config.services.geoipupdate.enable then
            config.services.geoipupdate.settings.DatabaseDirectory
          else
            null
        '';
        example = "/var/lib/GeoIP";
        description = ''
          Path to directory containing MaxMind GeoIP database files (such as {file}`GeoLite2-City.mmdb`).
          When {option}`services.geoipupdate.enable` is true, this defaults automatically to
          {option}`services.geoipupdate.settings.DatabaseDirectory`.
        '';
      };
    };

    worker = {
      count = lib.mkOption {
        type = lib.types.int;
        default = 1;
        description = "Number of background Huey worker threads or processes.";
      };

      type = lib.mkOption {
        type = lib.types.enum [
          "thread"
          "process"
        ];
        default = "thread";
        description = "Which type of background worker to run (thread or process).";
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
        assertion = cfg.database.createLocally -> cfg.database.user == cfg.user;
        message = "services.karrot.database.user must be \"${cfg.user}\" when database.createLocally is true, as peer authentication requires the database user to match the system user name.";
      }
    ];

    users.users.${cfg.user} = lib.mkIf (cfg.user == "karrot") {
      isSystemUser = true;
      group = cfg.group;
      extraGroups = lib.optional cfg.redis.createLocally config.services.redis.servers.karrot.group;
      home = cfg.dataDir;
    };

    users.groups.${cfg.group} = lib.mkIf (cfg.group == "karrot") { };

    users.users.nginx.extraGroups = lib.mkIf (cfg.nginx.enable && config.services.nginx.enable) [
      cfg.group
    ];

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall (
      if cfg.nginx.enable then [ 80 443 ] else [ cfg.settings.listen.port ]
    );

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
        root = "${cfg.package.frontend}";
        extraConfig = ''
          client_max_body_size ${cfg.settings.uploads.maxSize};
        '';
        locations."/assets".extraConfig = "expires max;";
        locations."/statics".extraConfig = "expires max;";
        locations."/css".extraConfig = "expires max;";
        locations."/js".extraConfig = "expires max;";
        locations."/img".extraConfig = "expires max;";
        locations."/fonts".extraConfig = "expires max;";
        locations."/" = {
          tryFiles = "$uri /index.html";
          extraConfig = ''
            add_header X-Content-Type-Options nosniff;
            add_header Cache-Control 'no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0';
            expires off;
            etag off;
          '';
        };
        locations."~ ^/(api(-auth)?|docs|silk|static)(/|$)" = {
          proxyPass =
            if cfg.settings.listen.socket != null then
              "http://unix:${cfg.settings.listen.socket}"
            else
              "http://${cfg.settings.listen.host}:${toString cfg.settings.listen.port}";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_redirect off;
          '';
        };
        locations."/uploads/" = {
          alias = "${cfg.dataDir}/uploads/";
          extraConfig = ''
            internal;
            etag on;
          '';
        };
        locations."/media/" = {
          alias = "${cfg.dataDir}/uploads/";
          extraConfig = "expires max;";
        };
        locations."/media/tmp/".extraConfig = ''
          deny all;
          return 404;
        '';
        locations."~ /media/conversation_message_attachment_(files|previews|thumbnails)/".extraConfig = ''
          deny all;
          return 404;
        '';
      };
    };

    systemd.targets.karrot = {
      description = "Target for all Karrot services";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [
        "network-online.target"
      ]
      ++ lib.optional cfg.database.createLocally "postgresql.target"
      ++ lib.optional cfg.redis.createLocally "redis-karrot.service";
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
      partOf = [ "karrot.target" ];
      wantedBy = [ "karrot.target" ];

      unitConfig = {
        StartLimitIntervalSec = 30;
        StartLimitBurst = 3;
      };

      environment = commonEnvironment;

      preStart = ''
        export PATH="${pkgs.coreutils}/bin:$PATH"

        ${lib.optionalString (cfg.secretKeyFile == null) ''
          if [ ! -f "${cfg.dataDir}/secret.key" ]; then
            (umask 077; tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 50 > "${cfg.dataDir}/secret.key")
            chmod 600 "${cfg.dataDir}/secret.key"
          fi
        ''}
        mkdir -p "${cfg.dataDir}/uploads" "${cfg.dataDir}/plugins"
        chmod 750 "${cfg.dataDir}/uploads"
        ${lib.getExe cfg.package} migrate
      '';

      script = ''
        exec ${lib.getExe cfg.package} server
      '';

      serviceConfig = {
        Type = "exec";
        User = cfg.user;
        Group = cfg.group;
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
      partOf = [ "karrot.target" ];
      wantedBy = [ "karrot.target" ];

      unitConfig = {
        StartLimitIntervalSec = 30;
        StartLimitBurst = 3;
      };

      environment = commonEnvironment;

      script = ''
        exec ${lib.getExe cfg.package} worker
      '';

      serviceConfig = {
        Type = "exec";
        User = cfg.user;
        Group = cfg.group;
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
