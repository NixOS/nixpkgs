{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.pixelfed;
  user = cfg.user;
  group = cfg.group;
  pixelfed = cfg.package.override { inherit (cfg) dataDir runtimeDir; };
  # https://github.com/pixelfed/pixelfed/blob/dev/app/Console/Commands/Installer.php#L185-L190
  extraPrograms = with pkgs; [ jpegoptim optipng pngquant gifsicle ffmpeg ];
  # Ensure PHP extensions: https://github.com/pixelfed/pixelfed/blob/dev/app/Console/Commands/Installer.php#L135-L147
  phpPackage = cfg.phpPackage.buildEnv {
    extensions = { enabled, all }:
      enabled
      ++ (with all; [ bcmath ctype curl mbstring gd intl zip redis imagick ]);
  };
  configFile =
    pkgs.writeText "pixelfed-env" (lib.generators.toKeyValue { } cfg.settings);
  # Management script
  pixelfed-manage = pkgs.writeShellScriptBin "pixelfed-manage" ''
    cd ${pixelfed}
    sudo=exec
    if [[ "$USER" != ${user} ]]; then
      sudo='exec /run/wrappers/bin/sudo -u ${user}'
    fi
    $sudo ${phpPackage}/bin/php artisan "$@"
  '';
  dbSocket = {
    "pgsql" = "/run/postgresql";
    "mysql" = "/run/mysqld/mysqld.sock";
  }.${cfg.database.type};
  dbService = {
    "pgsql" = "postgresql.service";
    "mysql" = "mysql.service";
  }.${cfg.database.type};
  redisService = "redis-pixelfed.service";
in {
  options.services = {
    pixelfed = {
      enable = mkEnableOption "a Pixelfed instance";
      package = mkPackageOption pkgs "pixelfed" { };
      phpPackage = mkPackageOption pkgs "php81" { };

      user = mkOption {
        type = types.str;
        default = "pixelfed";
        description = ''
          User account under which pixelfed runs.

          ::: {.note}
          If left as the default value this user will automatically be created
          on system activation, otherwise you are responsible for
          ensuring the user exists before the pixelfed application starts.
          :::
        '';
      };

      group = mkOption {
        type = types.str;
        default = "pixelfed";
        description = ''
          Group account under which pixelfed runs.

          ::: {.note}
          If left as the default value this group will automatically be created
          on system activation, otherwise you are responsible for
          ensuring the group exists before the pixelfed application starts.
          :::
        '';
      };

      domain = mkOption {
        type = types.str;
        description = ''
          FQDN for the Pixelfed instance.
        '';
      };

      secretFile = mkOption {
        type = types.path;
        description = ''
          A secret file to be sourced for the .env settings.
          Place `APP_KEY` and other settings that should not end up in the Nix store here.
        '';
      };

      settings = mkOption {
        type = with types; (attrsOf (oneOf [ bool int str ]));
        description = ''
          .env settings for Pixelfed.
          Secrets should use `secretFile` option instead.
        '';
      };

      nginx = mkOption {
        type = types.nullOr (types.submodule
          (import ../web-servers/nginx/vhost-options.nix {
            inherit config lib;
          }));
        default = null;
        example = lib.literalExpression ''
          {
            serverAliases = [
              "pics.''${config.networking.domain}"
            ];
            enableACME = true;
            forceHttps = true;
          }
        '';
        description = ''
          With this option, you can customize an nginx virtual host which already has sensible defaults for Dolibarr.
          Set to {} if you do not need any customization to the virtual host.
          If enabled, then by default, the {option}`serverName` is
          `''${domain}`,
          If this is set to null (the default), no nginx virtualHost will be configured.
        '';
      };

      redis.createLocally = mkEnableOption "a local Redis database using UNIX socket authentication"
        // {
          default = true;
        };

      database = {
        createLocally = mkEnableOption "a local database using UNIX socket authentication" // {
            default = true;
          };
        automaticMigrations = mkEnableOption "automatic migrations for database schema and data" // {
            default = true;
          };

        type = mkOption {
          type = types.enum [ "mysql" "pgsql" ];
          example = "pgsql";
          default = "mysql";
          description = ''
            Database engine to use.
            Note that PGSQL is not well supported: https://github.com/pixelfed/pixelfed/issues/2727
          '';
        };

        name = mkOption {
          type = types.str;
          default = "pixelfed";
          description = "Database name.";
        };
      };

      maxUploadSize = mkOption {
        type = types.str;
        default = "8M";
        description = ''
          Max upload size with units.
        '';
      };

      poolConfig = mkOption {
        type = with types; attrsOf (oneOf [ int str bool ]);
        default = { };

        description = ''
          Options for Pixelfed's PHP-FPM pool.
        '';
      };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/pixelfed";
        description = ''
          State directory of the `pixelfed` user which holds
          the application's state and data.
        '';
      };

      runtimeDir = mkOption {
        type = types.str;
        default = "/run/pixelfed";
        description = ''
          Ruutime directory of the `pixelfed` user which holds
          the application's caches and temporary files.
        '';
      };

      schedulerInterval = mkOption {
        type = types.str;
        default = "1d";
        description = "How often the Pixelfed cron task should run";
      };
    };
  };

  config = mkIf cfg.enable {
    users.users.pixelfed = mkIf (cfg.user == "pixelfed") {
      isSystemUser = true;
      group = cfg.group;
      extraGroups = lib.optional cfg.redis.createLocally "redis-pixelfed";
    };
    users.groups.pixelfed = mkIf (cfg.group == "pixelfed") { };

    services.redis.servers.pixelfed.enable = lib.mkIf cfg.redis.createLocally true;
    services.pixelfed.settings = mkMerge [
      ({
        APP_ENV = mkDefault "production";
        APP_DEBUG = mkDefault false;
        # https://github.com/pixelfed/pixelfed/blob/dev/app/Console/Commands/Installer.php#L312-L316
        APP_URL = mkDefault "https://${cfg.domain}";
        ADMIN_DOMAIN = mkDefault cfg.domain;
        APP_DOMAIN = mkDefault cfg.domain;
        SESSION_DOMAIN = mkDefault cfg.domain;
        SESSION_SECURE_COOKIE = mkDefault true;
        OPEN_REGISTRATION = mkDefault false;
        # ActivityPub: https://github.com/pixelfed/pixelfed/blob/dev/app/Console/Commands/Installer.php#L360-L364
        ACTIVITY_PUB = mkDefault true;
        AP_REMOTE_FOLLOW = mkDefault true;
        AP_INBOX = mkDefault true;
        AP_OUTBOX = mkDefault true;
        AP_SHAREDINBOX = mkDefault true;
        # Image optimization: https://github.com/pixelfed/pixelfed/blob/dev/app/Console/Commands/Installer.php#L367-L404
        PF_OPTIMIZE_IMAGES = mkDefault true;
        IMAGE_DRIVER = mkDefault "imagick";
        # Mobile APIs
        OAUTH_ENABLED = mkDefault true;
        # https://github.com/pixelfed/pixelfed/blob/dev/app/Console/Commands/Installer.php#L351
        EXP_EMC = mkDefault true;
        # Defer to systemd
        LOG_CHANNEL = mkDefault "stderr";
        # TODO: find out the correct syntax?
        # TRUST_PROXIES = mkDefault "127.0.0.1/8, ::1/128";
      })
      (mkIf (cfg.redis.createLocally) {
        BROADCAST_DRIVER = mkDefault "redis";
        CACHE_DRIVER = mkDefault "redis";
        QUEUE_DRIVER = mkDefault "redis";
        SESSION_DRIVER = mkDefault "redis";
        WEBSOCKET_REPLICATION_MODE = mkDefault "redis";
        # Support phpredis and predis configuration-style.
        REDIS_SCHEME = "unix";
        REDIS_HOST = config.services.redis.servers.pixelfed.unixSocket;
        REDIS_PATH = config.services.redis.servers.pixelfed.unixSocket;
      })
      (mkIf (cfg.database.createLocally) {
        DB_CONNECTION = cfg.database.type;
        DB_SOCKET = dbSocket;
        DB_DATABASE = cfg.database.name;
        DB_USERNAME = user;
        # No TCP/IP connection.
        DB_PORT = 0;
      })
    ];

    environment.systemPackages = [ pixelfed-manage ];

    services.mysql =
      mkIf (cfg.database.createLocally && cfg.database.type == "mysql") {
        enable = mkDefault true;
        package = mkDefault pkgs.mariadb;
        ensureDatabases = [ cfg.database.name ];
        ensureUsers = [{
          name = user;
          ensurePermissions = { "${cfg.database.name}.*" = "ALL PRIVILEGES"; };
        }];
      };

    services.postgresql =
      mkIf (cfg.database.createLocally && cfg.database.type == "pgsql") {
        enable = mkDefault true;
        ensureDatabases = [ cfg.database.name ];
        ensureUsers = [{
          name = user;
        }];
      };

    # Make each individual option overridable with lib.mkDefault.
    services.pixelfed.poolConfig = lib.mapAttrs' (n: v: lib.nameValuePair n (lib.mkDefault v)) {
      "pm" = "dynamic";
      "php_admin_value[error_log]" = "stderr";
      "php_admin_flag[log_errors]" = true;
      "catch_workers_output" = true;
      "pm.max_children" = "32";
      "pm.start_servers" = "2";
      "pm.min_spare_servers" = "2";
      "pm.max_spare_servers" = "4";
      "pm.max_requests" = "500";
    };

    services.phpfpm.pools.pixelfed = {
      inherit user group;
      inherit phpPackage;

      phpOptions = ''
        post_max_size = ${toString cfg.maxUploadSize}
        upload_max_filesize = ${toString cfg.maxUploadSize}
        max_execution_time = 600;
      '';

      settings = {
        "listen.owner" = user;
        "listen.group" = group;
        "listen.mode" = "0660";
        "catch_workers_output" = "yes";
      } // cfg.poolConfig;
    };

    systemd.services.phpfpm-pixelfed.after = [ "pixelfed-data-setup.service" ];
    systemd.services.phpfpm-pixelfed.requires =
      [ "pixelfed-horizon.service" "pixelfed-data-setup.service" ]
      ++ lib.optional cfg.database.createLocally dbService
      ++ lib.optional cfg.redis.createLocally redisService;
    # Ensure image optimizations programs are available.
    systemd.services.phpfpm-pixelfed.path = extraPrograms;

    systemd.services.pixelfed-horizon = {
      description = "Pixelfed task queueing via Laravel Horizon framework";
      after = [ "network.target" "pixelfed-data-setup.service" ];
      requires = [ "pixelfed-data-setup.service" ]
        ++ (lib.optional cfg.database.createLocally dbService)
        ++ (lib.optional cfg.redis.createLocally redisService);
      wantedBy = [ "multi-user.target" ];
      # Ensure image optimizations programs are available.
      path = extraPrograms;

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pixelfed-manage}/bin/pixelfed-manage horizon";
        StateDirectory =
          lib.mkIf (cfg.dataDir == "/var/lib/pixelfed") "pixelfed";
        User = user;
        Group = group;
        Restart = "on-failure";
      };
    };

    systemd.timers.pixelfed-cron = {
      description = "Pixelfed periodic tasks timer";
      after = [ "pixelfed-data-setup.service" ];
      requires = [ "phpfpm-pixelfed.service" ];
      wantedBy = [ "timers.target" ];

      timerConfig = {
        OnBootSec = cfg.schedulerInterval;
        OnUnitActiveSec = cfg.schedulerInterval;
      };
    };

    systemd.services.pixelfed-cron = {
      description = "Pixelfed periodic tasks";
      # Ensure image optimizations programs are available.
      path = extraPrograms;

      serviceConfig = {
        ExecStart = "${pixelfed-manage}/bin/pixelfed-manage schedule:run";
        User = user;
        Group = group;
        StateDirectory =
          lib.mkIf (cfg.dataDir == "/var/lib/pixelfed") "pixelfed";
      };
    };

    systemd.services.pixelfed-data-setup = {
      description =
        "Pixelfed setup: migrations, environment file update, cache reload, data changes";
      wantedBy = [ "multi-user.target" ];
      after = lib.optional cfg.database.createLocally dbService;
      requires = lib.optional cfg.database.createLocally dbService;
      path = with pkgs; [ bash pixelfed-manage rsync ] ++ extraPrograms;

      serviceConfig = {
        Type = "oneshot";
        User = user;
        Group = group;
        StateDirectory =
          lib.mkIf (cfg.dataDir == "/var/lib/pixelfed") "pixelfed";
        LoadCredential = "env-secrets:${cfg.secretFile}";
        UMask = "077";
      };

      script = ''
        # Before running any PHP program, cleanup the code cache.
        # It's necessary if you upgrade the application otherwise you might
        # try to import non-existent modules.
        rm -f ${cfg.runtimeDir}/app.php
        rm -rf ${cfg.runtimeDir}/cache/*

        # Concatenate non-secret .env and secret .env
        rm -f ${cfg.dataDir}/.env
        cp --no-preserve=all ${configFile} ${cfg.dataDir}/.env
        echo -e '\n' >> ${cfg.dataDir}/.env
        cat "$CREDENTIALS_DIRECTORY/env-secrets" >> ${cfg.dataDir}/.env

        # Link the static storage (package provided) to the runtime storage
        # Necessary for cities.json and static images.
        mkdir -p ${cfg.dataDir}/storage
        rsync -av --no-perms ${pixelfed}/storage-static/ ${cfg.dataDir}/storage
        chmod -R +w ${cfg.dataDir}/storage

        chmod g+x ${cfg.dataDir}/storage ${cfg.dataDir}/storage/app
        chmod -R g+rX ${cfg.dataDir}/storage/app/public

        # Link the app.php in the runtime folder.
        # We cannot link the cache folder only because bootstrap folder needs to be writeable.
        ln -sf ${pixelfed}/bootstrap-static/app.php ${cfg.runtimeDir}/app.php

        # https://laravel.com/docs/10.x/filesystem#the-public-disk
        # Creating the public/storage → storage/app/public link
        # is unnecessary as it's part of the installPhase of pixelfed.

        # Install Horizon
        # FIXME: require write access to public/ — should be done as part of install — pixelfed-manage horizon:publish

        # Perform the first migration.
        [[ ! -f ${cfg.dataDir}/.initial-migration ]] && pixelfed-manage migrate --force && touch ${cfg.dataDir}/.initial-migration

        ${lib.optionalString cfg.database.automaticMigrations ''
          # Force migrate the database.
          pixelfed-manage migrate --force
        ''}

        # Import location data
        pixelfed-manage import:cities

        ${lib.optionalString cfg.settings.ACTIVITY_PUB ''
          # ActivityPub federation bookkeeping
          [[ ! -f ${cfg.dataDir}/.instance-actor-created ]] && pixelfed-manage instance:actor && touch ${cfg.dataDir}/.instance-actor-created
        ''}

        ${lib.optionalString cfg.settings.OAUTH_ENABLED ''
          # Generate Passport encryption keys
          [[ ! -f ${cfg.dataDir}/.passport-keys-generated ]] && pixelfed-manage passport:keys && touch ${cfg.dataDir}/.passport-keys-generated
        ''}

        pixelfed-manage route:cache
        pixelfed-manage view:cache
        pixelfed-manage config:cache
      '';
    };

    systemd.tmpfiles.rules = [
      # Cache must live across multiple systemd units runtimes.
      "d ${cfg.runtimeDir}/                         0700 ${user} ${group} - -"
      "d ${cfg.runtimeDir}/cache                    0700 ${user} ${group} - -"
    ];

    # Enable NGINX to access our phpfpm-socket.
    users.users."${config.services.nginx.user}".extraGroups = [ cfg.group ];
    services.nginx = mkIf (cfg.nginx != null) {
      enable = true;
      virtualHosts."${cfg.domain}" = mkMerge [
        cfg.nginx
        {
          root = lib.mkForce "${pixelfed}/public/";
          locations."/".tryFiles = "$uri $uri/ /index.php?$query_string";
          locations."/favicon.ico".extraConfig = ''
            access_log off; log_not_found off;
          '';
          locations."/robots.txt".extraConfig = ''
            access_log off; log_not_found off;
          '';
          locations."~ \\.php$".extraConfig = ''
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass unix:${config.services.phpfpm.pools.pixelfed.socket};
            fastcgi_index index.php;
          '';
          locations."~ /\\.(?!well-known).*".extraConfig = ''
            deny all;
          '';
          extraConfig = ''
            add_header X-Frame-Options "SAMEORIGIN";
            add_header X-XSS-Protection "1; mode=block";
            add_header X-Content-Type-Options "nosniff";
            index index.html index.htm index.php;
            error_page 404 /index.php;
            client_max_body_size ${toString cfg.maxUploadSize};
          '';
        }
      ];
    };
  };
}
