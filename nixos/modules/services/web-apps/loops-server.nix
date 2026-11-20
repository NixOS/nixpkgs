{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.loops-server;
  # https://github.com/joinloops/loops-server/blob/main/INSTALLATION.md
  extraPrograms = with pkgs; [ ffmpeg ];
  # Ensure PHP extensions: https://github.com/joinloops/loops-server/blob/main/INSTALLATION.md
  # json and xml already included in nix php env
  phpPackage = cfg.phpPackage.buildEnv {
    extensions =
      { enabled, all }:
      enabled
      ++ (with all; [
        bcmath
        ctype
        fileinfo
        intl
        mbstring
        openssl
        pdo
        tokenizer
        gd
        redis
      ]);
  };
  configFile = pkgs.writeText "loops-env" (lib.generators.toKeyValue { } cfg.settings);
  # Management script
  loops-manage = pkgs.writeShellScriptBin "loops-manage" ''
    cd ${cfg.package}
    sudo=exec
    if [[ "$USER" != ${cfg.user} ]]; then
      sudo='exec /run/wrappers/bin/sudo -u ${cfg.user}'
    fi
    $sudo ${phpPackage}/bin/php artisan "$@"
  '';
  redisService = "redis-loops-server.service";

  defaultServiceConfig = {
    User = cfg.user;
    Group = cfg.group;
    WorkingDirectory = cfg.dataDir;
    StateDirectory = lib.mkIf (cfg.dataDir == "/var/lib/loops-server") "loops-server";
    # Service hardening
    ReadWritePaths = [ cfg.dataDir ];
    CacheDirectory = "loops-server";
    AmbientCapabilities = "";
    CapabilityBoundingSet = "";
    # ProtectClock adds DeviceAllow=char-rtc r
    DeviceAllow = "";
    DevicePolicy = "closed";
    LockPersonality = true;
    # Loosening setting, required by Horizon daemon
    MemoryDenyWriteExecute = false;
    NoNewPrivileges = true;
    RemoveIPC = true;
    PrivateDevices = true;
    PrivateMounts = true;
    PrivateTmp = true;
    PrivateUsers = true;
    ProtectClock = true;
    ProtectHome = true;
    ProtectHostname = true;
    ProtectSystem = "strict";
    ProtectControlGroups = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectProc = "invisible";
    ProcSubset = "pid";
    RestrictAddressFamilies = [
      "AF_UNIX"
      "AF_INET"
      "AF_INET6"
    ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    SystemCallArchitectures = "native";
    SystemCallFilter = [
      "@system-service"
      "~@privileged @setuid @keyring"
    ];
    UMask = "0077";
  };
in
{

  meta = {
    maintainers = [ lib.maintainers.onny ];
    teams = [ lib.teams.ngi ];
  };

  options.services = {
    loops-server = {
      enable = lib.mkEnableOption "a Loops instance";
      package = lib.mkPackageOption pkgs "loops-server" { };
      phpPackage = lib.mkPackageOption pkgs "php85" { };

      user = lib.mkOption {
        type = lib.types.str;
        default = "loops";
        description = ''
          User account under which Loops runs.

          ::: {.note}
          If left as the default value this user will automatically be created
          on system activation, otherwise you are responsible for
          ensuring the user exists before the Loops application starts.
          :::
        '';
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "loops";
        description = ''
          Group account under which Loops runs.

          ::: {.note}
          If left as the default value this group will automatically be created
          on system activation, otherwise you are responsible for
          ensuring the group exists before the Loops application starts.
          :::
        '';
      };

      domain = lib.mkOption {
        type = lib.types.str;
        description = ''
          FQDN for the Loops instance.
        '';
      };

      secretFile = lib.mkOption {
        type = lib.types.path;
        description = ''
          A secret file to be sourced for the .env settings.
          Place `APP_KEY` and other settings that should not end up in the Nix store here.
        '';
      };

      settings = lib.mkOption {
        type =
          with lib.types;
          (attrsOf (oneOf [
            bool
            int
            str
          ]));
        description = ''
          .env settings for Loops.
          Secrets should use `secretFile` option instead.
        '';
      };

      nginx = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.submodule (
            import ../web-servers/nginx/vhost-options.nix {
              inherit config lib;
            }
          )
        );
        default = null;
        example = lib.literalExpression ''
          {
            serverAliases = [
              "pics.''${config.networking.domain}"
            ];
            enableACME = true;
            forceSSL = true;
          }
        '';
        description = ''
          With this option, you can customize an nginx virtual host which already has sensible defaults for Loops.
          Set to {} if you do not need any customization to the virtual host.
          If enabled, then by default, the {option}`serverName` is
          `''${domain}`,
          If this is set to null (the default), no nginx virtualHost will be configured.
        '';
      };

      redis.createLocally =
        lib.mkEnableOption "a local Redis database using UNIX socket authentication"
        // {
          default = true;
        };

      database = {

        createLocally = lib.mkEnableOption "a local database using UNIX socket authentication" // {
          default = true;
        };

        automaticMigrations = lib.mkEnableOption "automatic migrations for database schema and data" // {
          default = true;
        };

        name = lib.mkOption {
          type = lib.types.str;
          default = "loops";
          description = "Database name.";
        };
      };

      maxUploadSize = lib.mkOption {
        type = lib.types.str;
        default = "100M";
        description = ''
          Max upload size with units.
        '';
      };

      poolConfig = lib.mkOption {
        type =
          with lib.types;
          attrsOf (oneOf [
            int
            str
            bool
          ]);
        default = { };

        description = ''
          Options for Loops's PHP-FPM pool.
        '';
      };

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/loops-server";
        description = ''
          State directory of the `loops` user which holds
          the application's state and data.
        '';
      };

      schedulerInterval = lib.mkOption {
        type = lib.types.str;
        default = "1d";
        description = "How often the Loops cron task should run";
      };
    };
  };

  config = lib.mkIf cfg.enable {

    services.loops-server.settings = lib.mkMerge [
      {
        # https://github.com/joinloops/loops-server/blob/main/.env.example
        APP_NAME = lib.mkDefault "Loops";
        APP_ENV = lib.mkDefault "production";
        APP_DEBUG = lib.mkDefault false;
        APP_URL = lib.mkDefault "https://${cfg.domain}";
        OAUTH_ENABLED = lib.mkDefault true;
        QUEUE_CONNECTION = "redis";
        LOG_CHANNEL = lib.mkDefault "stderr";
      }
      (lib.mkIf (cfg.redis.createLocally) {
        REDIS_HOST = config.services.redis.servers.loops-server.unixSocket;
        REDIS_PATH = config.services.redis.servers.loops-server.unixSocket;
        REDIS_PORT = 0;
      })
      (lib.mkIf (cfg.database.createLocally) {
        DB_CONNECTION = "mysql";
        DB_SOCKET = "/run/mysqld/mysqld.sock";
        DB_DATABASE = cfg.database.name;
        DB_USERNAME = cfg.user;
        # No TCP/IP connection.
        DB_PORT = 0;
      })
    ];

    systemd.tmpfiles.rules = [
      "L+ /run/loops-server - - - - ${cfg.dataDir}"
      "d ${cfg.dataDir}/cache 0755 ${cfg.user} ${cfg.group} -"
      "d ${cfg.dataDir}/storage 0755 ${cfg.user} ${cfg.group} -"
    ];

    services.mysql = lib.mkIf (cfg.database.createLocally) {
      enable = lib.mkDefault true;
      package = lib.mkDefault pkgs.mariadb;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.user;
          ensurePermissions = {
            "${cfg.database.name}.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    # Make each individual option overridable with lib.mkDefault.
    services.loops-server.poolConfig = lib.mapAttrs' (n: v: lib.nameValuePair n (lib.mkDefault v)) {
      "pm" = "dynamic";
      "php_admin_value[error_log]" = "stderr";
      "php_admin_flag[log_errors]" = true;
      "catch_workers_output" = true;
      # PHP-FPM settings
      # https://github.com/joinloops/loops-server/blob/main/INSTALLATION.md#3-configure-php-fpm
      "pm.max_children" = 50;
      "pm.start_servers" = 10;
      "pm.min_spare_servers" = 5;
      "pm.max_spare_servers" = 20;
      "pm.max_requests" = 1000;
    };

    services.phpfpm.pools.loops-server = {
      inherit (cfg) user group;
      inherit phpPackage;

      phpOptions = ''
        post_max_size = ${toString cfg.maxUploadSize}
        upload_max_filesize = ${toString cfg.maxUploadSize}
        max_execution_time = 300;
        memory_limit = 512M
        # OPcache settings
        # https://github.com/joinloops/loops-server/blob/main/INSTALLATION.md#2-enable-opcache
        opcache.enable = 1;
        opcache.memory_consumption = 128;
        opcache.interned_strings_buffer = 8;
        opcache.max_accelerated_files = 4000;
        opcache.revalidate_freq = 2;
        opcache.fast_shutdown = 1;
      '';

      settings = {
        "listen.owner" = cfg.user;
        "listen.group" = cfg.group;
        "listen.mode" = "0660";
        "catch_workers_output" = "yes";
      }
      // cfg.poolConfig;
    };

    systemd.services.phpfpm-loops-server = {
      after = [ "loops-data-setup.service" ];
      requires = [
        "loops-horizon.service"
        "loops-data-setup.service"
      ]
      ++ (lib.optional cfg.database.createLocally "mysql.service")
      ++ (lib.optional cfg.redis.createLocally redisService);
      path = extraPrograms;
    };

    systemd.services.loops-horizon = {
      description = "Loops task queueing via Laravel Horizon framework";
      after = [
        "network.target"
        "loops-data-setup.service"
      ];
      requires = [
        "loops-data-setup.service"
      ]
      ++ (lib.optional cfg.database.createLocally "mysql.service")
      ++ (lib.optional cfg.redis.createLocally redisService);
      wantedBy = [ "multi-user.target" ];
      path = extraPrograms;

      serviceConfig = {
        Type = "simple";
        ExecStart = "${lib.getExe loops-manage} horizon";
        Restart = "on-failure";
      }
      // defaultServiceConfig;
    };

    systemd.timers.loops-cron = {
      description = "Loops periodic tasks timer";
      after = [ "loops-data-setup.service" ];
      requires = [ "phpfpm-loops-server.service" ];
      wantedBy = [ "timers.target" ];

      timerConfig = {
        OnBootSec = cfg.schedulerInterval;
        OnUnitActiveSec = cfg.schedulerInterval;
      };
    };

    systemd.services.loops-cron = {
      description = "Loops periodic tasks";
      path = extraPrograms;
      serviceConfig = {
        ExecStart = "${lib.getExe loops-manage} schedule:run";
      }
      // defaultServiceConfig;
    };

    systemd.services.loops-data-setup = {
      description = "Loops setup: migrations, environment file update, cache reload, data changes";
      wantedBy = [ "multi-user.target" ];
      after = lib.optional cfg.database.createLocally "mysql.service";
      requires = lib.optional cfg.database.createLocally "mysql.service";
      path =
        with pkgs;
        [
          bash
          loops-manage
          rsync
        ]
        ++ extraPrograms;

      serviceConfig = {
        Type = "oneshot";
        LoadCredential = "env-secrets:${cfg.secretFile}";
        UMask = "077";
      }
      // defaultServiceConfig;

      script = ''
        # Before running any PHP program, cleanup the code cache.
        # It's necessary if you upgrade the application otherwise you might
        # try to import non-existent modules.
        rm -f ${cfg.dataDir}/app.php
        rm -rf ${cfg.dataDir}/cache/*

        # Concatenate non-secret .env and secret .env
        rm -f ${cfg.dataDir}/.env
        cp --no-preserve=all ${configFile} ${cfg.dataDir}/.env
        echo -e '\n' >> ${cfg.dataDir}/.env
        cat "$CREDENTIALS_DIRECTORY/env-secrets" >> ${cfg.dataDir}/.env

        # Link the static storage (package provided) to the runtime storage
        # Necessary for static media files.
        rsync -av --no-perms ${cfg.package}/storage-static/ ${cfg.dataDir}/storage
        chmod -R +w ${cfg.dataDir}/storage

        chmod g+x ${cfg.dataDir}/storage ${cfg.dataDir}/storage/app
        chmod -R g+rX ${cfg.dataDir}/storage/app/public

        # Link app.php and providers.php in the runtime folder.
        # We cannot link the cache folder only because bootstrap folder needs to be writeable.
        ln -sf ${cfg.package}/bootstrap-static/app.php ${cfg.dataDir}/app.php
        ln -sf ${cfg.package}/bootstrap-static/providers.php ${cfg.dataDir}/providers.php

        # Perform the first migration.
        [[ ! -f ${cfg.dataDir}/.initial-migration ]] && loops-manage migrate --force && touch ${cfg.dataDir}/.initial-migration

        ${lib.optionalString cfg.database.automaticMigrations ''
          # Force migrate the database.
          loops-manage migrate --force
        ''}

        ${lib.optionalString cfg.settings.OAUTH_ENABLED ''
          # Generate Passport encryption keys
          [[ ! -f ${cfg.dataDir}/.passport-keys-generated ]] && loops-manage passport:keys && touch ${cfg.dataDir}/.passport-keys-generated
        ''}

        loops-manage route:cache
        loops-manage view:cache
        loops-manage config:clear
        loops-manage config:cache
      '';
    };

    services.nginx = lib.mkIf (cfg.nginx != null) {
      enable = true;
      virtualHosts."${cfg.domain}" = lib.mkMerge [
        cfg.nginx
        {
          root = lib.mkForce "${cfg.package}/public/";
          locations."/".tryFiles = "$uri $uri/ /index.php?$query_string";
          locations."/favicon.ico".extraConfig = ''
            access_log off; log_not_found off;
          '';
          locations."/robots.txt".extraConfig = ''
            access_log off; log_not_found off;
          '';
          locations."~ \\.php$".extraConfig = ''
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass unix:${config.services.phpfpm.pools.loops-server.socket};
            fastcgi_index index.php;
          '';
          locations."~ /\\.(?!well-known).*".extraConfig = ''
            deny all;
          '';
          extraConfig = ''
            add_header X-Frame-Options "SAMEORIGIN";
            add_header X-Content-Type-Options "nosniff";
            index index.html index.htm index.php;
            error_page 404 /index.php;
            client_max_body_size ${toString cfg.maxUploadSize};
          '';
        }
      ];
    };

    services.redis.servers.loops-server = {
      enable = lib.mkIf cfg.redis.createLocally true;
      settings.loadmodule = [
        "${pkgs.redisbloom}/lib/redisbloom.so"
      ];
    };

    users.users = lib.mkMerge [
      (lib.mkIf (cfg.user == "loops") {
        loops = {
          isSystemUser = true;
          group = cfg.group;
          home = cfg.dataDir;
          extraGroups = lib.optional cfg.redis.createLocally "redis-loops-server";
        };
      })
      # Enable NGINX to access our phpfpm-socket.
      (lib.optionalAttrs (cfg.nginx != null) {
        "${config.services.nginx.user}".extraGroups = [ cfg.group ];
      })
    ];
    users.groups.loops = lib.mkIf (cfg.group == "loops") { };

    environment.systemPackages = [ loops-manage ];

  };
}
