{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.pterodactyl.panel;

  env =
    (lib.filterAttrs (n: v: v != null) {
      APP_NAME = cfg.app.name;
      APP_ENV = cfg.app.env;
      APP_DEBUG = cfg.app.debug;
      APP_KEY = if cfg.app.keyFile != null then "@APP_KEY@" else cfg.app.key;
      APP_TIMEZONE = cfg.app.timezone;
      APP_URL = cfg.app.url;
      APP_ENVIRONMENT_ONLY = cfg.app.environmentOnly;

      DB_CONNECTION = "mysql";
      DB_HOST = if cfg.database.createLocally then "localhost" else cfg.database.host;
      DB_PORT = cfg.database.port;
      DB_DATABASE = cfg.database.name;
      DB_USERNAME = cfg.database.user;
      DB_PASSWORD = if cfg.database.passwordFile != null then "@DB_PASSWORD@" else cfg.database.password;
      DB_SOCKET = if cfg.database.createLocally then "/run/mysqld/mysqld.sock" else null;

      REDIS_SCHEME = if cfg.redis.createLocally then "unix" else "tcp";
      REDIS_PATH =
        if cfg.redis.createLocally then
          config.services.redis.servers.${cfg.redis.name}.unixSocket
        else
          null;
      REDIS_HOST = if cfg.redis.createLocally then null else cfg.redis.host;
      REDIS_PORT = if cfg.redis.createLocally then null else cfg.redis.port;
      REDIS_PASSWORD = if cfg.redis.passwordFile != null then "@REDIS_PASSWORD@" else cfg.redis.password;

      CACHE_DRIVER = cfg.cacheDriver;
      QUEUE_CONNECTION = cfg.queueConnection;
      SESSION_DRIVER = cfg.sessionDriver;

      HASHIDS_SALT = if cfg.hashids.saltFile != null then "@HASHIDS_SALT@" else cfg.hashids.salt;
      HASHIDS_LENGTH = cfg.hashids.length;

      MAIL_MAILER = cfg.mail.mailer;
      MAIL_HOST = cfg.mail.host;
      MAIL_PORT = cfg.mail.port;
      MAIL_USERNAME = cfg.mail.username;
      MAIL_PASSWORD = if cfg.mail.passwordFile != null then "@MAIL_PASSWORD@" else cfg.mail.password;
      MAIL_ENCRYPTION = cfg.mail.encryption;
      MAIL_FROM_ADDRESS = cfg.mail.fromAddress;
      MAIL_FROM_NAME = cfg.mail.fromName;

      TRUSTED_PROXIES = builtins.concatStringsSep "," cfg.trustedProxies;
      PTERODACTYL_TELEMETRY_ENABLED = cfg.telemetry.enable;
    })
    // cfg.extraEnvironment;

  setupScript = pkgs.writeShellApplication {
    name = "pterodactyl-panel-setup";
    runtimeInputs = with pkgs; [
      coreutils
      replace-secret
      cfg.phpPackage
    ];
    text = ''
      install -Dm640 -o ${cfg.user} -g ${cfg.group} ${
        pkgs.writeText "pterodactyl.env" (
          lib.generators.toKeyValue {
            mkKeyValue = lib.generators.mkKeyValueDefault {
              mkValueString =
                v:
                if builtins.isString v && lib.strings.hasInfix " " v then
                  ''"${v}"''
                else
                  lib.generators.mkValueStringDefault { } v;
            } "=";
          } env
        )
      } ${cfg.dataDir}/.env

      ${lib.optionalString (cfg.app.keyFile != null) ''
        replace-secret '@APP_KEY@' ${lib.escapeShellArg cfg.app.keyFile} ${cfg.dataDir}/.env
      ''}

      ${lib.optionalString (cfg.database.passwordFile != null) ''
        replace-secret '@DB_PASSWORD@' ${lib.escapeShellArg cfg.database.passwordFile} ${cfg.dataDir}/.env
      ''}

      ${lib.optionalString (cfg.redis.passwordFile != null) ''
        replace-secret '@REDIS_PASSWORD@' ${lib.escapeShellArg cfg.redis.passwordFile} ${cfg.dataDir}/.env
      ''}

      ${lib.optionalString (cfg.hashids.saltFile != null) ''
        replace-secret '@HASHIDS_SALT@' ${lib.escapeShellArg cfg.hashids.saltFile} ${cfg.dataDir}/.env
      ''}

      ${lib.optionalString (cfg.mail.passwordFile != null) ''
        replace-secret '@MAIL_PASSWORD@' ${lib.escapeShellArg cfg.mail.passwordFile} ${cfg.dataDir}/.env
      ''}

      ${lib.optionalString (cfg.extraEnvironmentFile != null) ''
        cat ${lib.escapeShellArg cfg.extraEnvironmentFile} >> ${cfg.dataDir}/.env
      ''}

      php ${cfg.package}/artisan migrate --seed --force
      php ${cfg.package}/artisan optimize:clear
    '';
  };

  pterodactylCli = pkgs.writeShellApplication {
    name = "pterodactyl-cli";
    runtimeInputs = [ cfg.phpPackage ];
    text = ''
      cd ${cfg.dataDir}
      php ${cfg.package}/artisan "$@"
    '';
  };

  cfgService = {
    User = cfg.user;
    Group = cfg.group;
    WorkingDirectory = cfg.package;
    StateDirectory = lib.removePrefix "/var/lib/" cfg.dataDir;
    ReadWritePaths = [ cfg.dataDir ];
  };
in
{
  options.services.pterodactyl.panel = {
    enable = lib.mkEnableOption "Pterodactyl Panel";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.pterodactyl.panel;
      defaultText = "pkgs.pterodactyl.panel";
      description = "Pterodactyl Panel package to use";
    };

    phpPackage = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = pkgs.php83.buildEnv {
        extensions =
          {
            enabled,
            all,
          }:
          enabled
          ++ (with all; [
            bcmath
            curl
            dom
            gd
            mbstring
            mysqli
            opcache
            pdo
            pdo_mysql
            xml
            tokenizer
            openssl
            zip
          ]);
      };
      defaultText = lib.literalExpression ''
        pkgs.php83.buildEnv {
          extensions = {
            enabled,
            all,
          }:
            enabled
            ++ (with all; [
              bcmath
              curl
              dom
              gd
              mbstring
              mysqli
              opcache
              pdo
              pdo_mysql
              xml
              tokenizer
              openssl
              zip
            ]);
        };
      '';
      description = "The PHP package to use";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "pterodactyl-panel";
      description = "User to run the panel as";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "pterodactyl-panel";
      description = "Group to run the panel as";
    };

    enableNginx = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable Nginx and PHP-FPM";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/pterodactyl-panel";
      description = "The root directory where all of the panel's data is stored";
    };

    app = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Pterodactyl";
        description = "The name of the panel";
      };

      env = lib.mkOption {
        type = lib.types.str;
        default = "production";
        description = "The panel environment";
      };

      debug = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to run the panel in debug mode";
      };

      key = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "The panel encryption key";
      };

      keyFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to a file containing the panel encryption key";
      };

      timezone = lib.mkOption {
        type = lib.types.str;
        default = "UTC";
        description = "The timezone for the panel";
      };

      url = lib.mkOption {
        type = lib.types.str;
        description = "The URL of the panel";
      };

      environmentOnly = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "The ability to manage settings from the panel";
      };
    };

    database = {
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to create the database locally";
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "The host of the database";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 3306;
        description = "The port of the database";
      };

      name = lib.mkOption {
        type = lib.types.str;
        default = "panel";
        description = "The name of the database";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "pterodactyl-panel";
        description = "The user for the database";
      };

      password = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "The password for the database";
      };

      passwordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to a file containing the database password";
      };
    };

    redis = {
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to create the Redis instance locally";
      };

      name = lib.mkOption {
        type = lib.types.str;
        default = "pterodactyl-panel";
        description = "The name of the Redis server to create";
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "The host of the Redis server";
      };

      password = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "The password for the Redis server";
      };

      passwordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to a file containing the Redis password";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 6379;
        description = "The port of the Redis server";
      };
    };

    cacheDriver = lib.mkOption {
      type = lib.types.str;
      default = "redis";
      description = "The driver for the cache";
    };

    queueConnection = lib.mkOption {
      type = lib.types.str;
      default = "redis";
      description = "The driver for the queue";
    };

    sessionDriver = lib.mkOption {
      type = lib.types.str;
      default = "redis";
      description = "The driver for the session";
    };

    hashids = {
      salt = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "The salt for the hash";
      };

      saltFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to a file containing the hash salt";
      };

      length = lib.mkOption {
        type = lib.types.int;
        default = 8;
        description = "The length of the generated hash";
      };
    };

    mail = {
      mailer = lib.mkOption {
        type = lib.types.str;
        default = "smtp";
        description = "The mailer to use";
      };

      host = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "The host of the mail server";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 25;
        description = "The port of the mail server";
      };

      username = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "The username for the mail server";
      };

      password = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "The password for the mail server";
      };

      passwordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to a file containing the mail password";
      };

      encryption = lib.mkOption {
        type = lib.types.str;
        default = "tls";
        description = "The encryption for the mail server";
      };

      fromAddress = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "The from address for the mail server";
      };

      fromName = lib.mkOption {
        type = lib.types.str;
        default = "Pterodactyl Panel";
        description = "The from name for the mail server";
      };
    };

    trustedProxies = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "A list of trusted proxy IP addresses";
    };

    telemetry.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable telemetry";
    };

    extraEnvironment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Extra environment variables to be merged with the main environment variables";
    };

    extraEnvironmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Additional environment file to be merged with other environment variables";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.app.key == null || cfg.app.keyFile == null;
        message = "cannot set both services.pterodactyl.panel.app.key and services.pterodactyl.panel.app.keyFile";
      }
      {
        assertion = cfg.app.key != null || cfg.app.keyFile != null;
        message = "must set either services.pterodactyl.panel.app.key or services.pterodactyl.panel.app.keyFile";
      }
      {
        assertion = cfg.database.password == null || cfg.database.passwordFile == null;
        message = "cannot set both services.pterodactyl.panel.database.password and services.pterodactyl.panel.database.passwordFile";
      }
      {
        assertion = cfg.redis.password == null || cfg.redis.passwordFile == null;
        message = "cannot set both services.pterodactyl.panel.redis.password and services.pterodactyl.panel.redis.passwordFile";
      }
      {
        assertion = cfg.hashids.salt == null || cfg.hashids.saltFile == null;
        message = "cannot set both services.pterodactyl.panel.hashids.salt and services.pterodactyl.panel.hashids.saltFile";
      }
      {
        assertion = cfg.hashids.salt != null || cfg.hashids.saltFile != null;
        message = "must set either services.pterodactyl.panel.hashids.salt or services.pterodactyl.panel.hashids.saltFile";
      }
      {
        assertion = cfg.mail.password == null || cfg.mail.passwordFile == null;
        message = "cannot set both services.pterodactyl.panel.mail.password and services.pterodactyl.panel.mail.passwordFile";
      }
    ];

    services.mysql = lib.optionalAttrs cfg.database.createLocally {
      enable = true;
      package = pkgs.mariadb;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensurePermissions."${cfg.database.name}.*" = "ALL PRIVILEGES";
        }
      ];
    };

    services.redis.servers."${cfg.redis.name}" = lib.mkIf cfg.redis.createLocally (
      {
        enable = true;
        user = cfg.user;
        group = cfg.group;
      }
      // lib.optionalAttrs (cfg.redis.password != null) { requirePass = cfg.redis.password; }
      // lib.optionalAttrs (cfg.redis.passwordFile != null) { requirePassFile = cfg.redis.passwordFile; }
    );

    systemd.tmpfiles.settings."10-pterodactyl-panel" =
      lib.attrsets.genAttrs
        [
          "${cfg.dataDir}/storage"
          "${cfg.dataDir}/storage/app"
          "${cfg.dataDir}/storage/app/public"
          "${cfg.dataDir}/storage/app/private"
          "${cfg.dataDir}/storage/clockwork"
          "${cfg.dataDir}/storage/framework"
          "${cfg.dataDir}/storage/framework/cache"
          "${cfg.dataDir}/storage/framework/sessions"
          "${cfg.dataDir}/storage/framework/views"
          "${cfg.dataDir}/storage/logs"
          "${cfg.dataDir}/bootstrap"
          "${cfg.dataDir}/bootstrap/cache"
        ]
        (n: {
          d = {
            user = cfg.user;
            group = cfg.group;
            mode = "0770";
          };
        })
      // {
        "${cfg.dataDir}".d = {
          user = cfg.user;
          group = cfg.group;
          mode = "0750";
        };
      };

    systemd.services.pterodactyl-panel-setup = {
      description = "Pterodactyl Panel setup";
      requiredBy = lib.optional cfg.enableNginx "phpfpm-pterodactyl-panel.service";
      before = lib.optional cfg.enableNginx "phpfpm-pterodactyl-panel.service";
      after = [ "mysql.service" ];
      restartTriggers = [ cfg.package ];

      serviceConfig = cfgService // {
        Type = "oneshot";
        ExecStart = lib.getExe setupScript;
        RemainAfterExit = true;
      };
    };

    systemd.services.pteroq = {
      description = "Pterodactyl Queue Worker";
      after = [
        "pterodactyl-panel-setup.service"
        "mysql.service"
        "redis-pterodactyl-panel.service"
      ];
      wants = [ "pterodactyl-panel-setup.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = cfgService // {
        ExecStart = "${cfg.phpPackage}/bin/php ${cfg.package}/artisan queue:work --queue=high,standard,low --sleep=3 --tries=3";
        Restart = "always";
      };
    };

    systemd.services.pterodactyl-panel-cron = {
      description = "Pterodactyl Panel cron job";
      after = [
        "pterodactyl-panel-setup.service"
        "mysql.service"
        "redis-pterodactyl-panel.service"
      ];
      wants = [ "pterodactyl-panel-setup.service" ];

      serviceConfig = cfgService // {
        Type = "oneshot";
        ExecStart = "${cfg.phpPackage}/bin/php ${cfg.package}/artisan schedule:run";
      };
    };

    systemd.timers.pterodactyl-panel-cron = {
      description = "Pterodactyl Panel cron timer";
      wantedBy = [ "timers.target" ];
      restartTriggers = [ cfg.package ];

      timerConfig = {
        OnCalendar = "minutely";
        Persistent = true;
      };
    };

    services.phpfpm.pools.pterodactyl-panel = lib.mkIf cfg.enableNginx {
      user = cfg.user;
      group = cfg.group;
      phpPackage = cfg.phpPackage;
      settings = {
        "listen.owner" = config.services.nginx.user;
        "listen.group" = config.services.nginx.group;
        "pm" = "dynamic";
        "pm.max_children" = 5;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 1;
        "pm.max_spare_servers" = 3;
      };
    };

    systemd.services."phpfpm-pterodactyl-panel" = lib.mkIf cfg.enableNginx {
      requires = [ "pterodactyl-panel-setup.service" ];
    };

    services.nginx = lib.mkIf cfg.enableNginx {
      enable = true;
      recommendedTlsSettings = lib.mkDefault true;
      recommendedOptimisation = lib.mkDefault true;
      recommendedGzipSettings = lib.mkDefault true;
      virtualHosts."${builtins.replaceStrings [ "https://" "http://" ] [ "" "" ] cfg.app.url}" = {
        root = "${cfg.package}/public";
        extraConfig = ''
          index index.php;
          client_max_body_size 100m;
          client_body_timeout 120s;
          sendfile off;
        '';
        locations = {
          "/" = {
            tryFiles = "$uri $uri/ /index.php?$query_string";
            index = "index.php";
            extraConfig = ''
              sendfile off;
            '';
          };
          "~ \\.php$" = {
            extraConfig = ''
              fastcgi_split_path_info ^(.+\.php)(/.+)$;
              fastcgi_pass unix:${config.services.phpfpm.pools.pterodactyl-panel.socket};
              fastcgi_index index.php;
              fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
              fastcgi_param HTTP_PROXY "";
              fastcgi_intercept_errors off;
              fastcgi_buffer_size 16k;
              fastcgi_buffers 4 16k;
              fastcgi_connect_timeout 300;
              fastcgi_send_timeout 300;
              fastcgi_read_timeout 300;
              include ${pkgs.nginx}/conf/fastcgi_params;
            '';
          };
        };
      };
    };

    environment.systemPackages = [ pterodactylCli ];

    services.pterodactyl.panel.group = lib.mkIf cfg.enableNginx (
      lib.mkDefault config.services.nginx.group
    );

    users.users = lib.mkIf (cfg.user == "pterodactyl-panel") {
      ${cfg.user} = {
        isSystemUser = true;
        group = cfg.group;
        home = cfg.dataDir;
        extraGroups = lib.optionals cfg.redis.createLocally [ "redis" ];
      };
    };

    users.groups = lib.mkIf (cfg.group == "pterodactyl-panel") {
      ${cfg.group} = { };
    };
  };
}
