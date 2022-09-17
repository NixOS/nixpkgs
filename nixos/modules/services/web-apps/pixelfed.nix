{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.pixelfed;
  opt = options.services.pixelfed;

  user = "pixelfed";
  group = "nginx";

  pixelfed = pkgs.pixelfed.override {
    dataDir = cfg.dataDir;
  };

  configFile = pkgs.writeTextFile {
    name = "env";
    text = cfg.envFile + ''
    APP_KEY = ${cfg.appKey}
    DB_CONNECTION=${cfg.database.type}
    DB_HOST=${cfg.database.host}
    DB_PORT= ${toString cfg.database.port}
    DB_DATABASE=${cfg.database.name}
    DB_USERNAME=${cfg.database.user}
    DB_PASSWORD=${cfg.database.password}
    '';
  };

  # shell script for local administration
  artisan = pkgs.writeScriptBin "pixelfed" ''
    #! ${pkgs.runtimeShell}
    cd ${pixelfed}
    sudo=exec
    if [[ "$USER" != ${user} ]]; then
      sudo='exec /run/wrappers/bin/sudo -u ${user}'
    fi
    $sudo ${pkgs.php}/bin/php artisan $*
  '';


in {
  options.services = {
    pixelfed = {
      enable = mkEnableOption (lib.mdDoc "the pixelfed service");

      envFile = mkOption {
        type = types.str;
        description = lib.mdDoc "Pixelfed .env file used to configure the application";
        default = ''
        ENABLE_CONFIG_CACHE=true
        APP_NAME=Pixelfed
        APP_ENV=production
        APP_DEBUG=true

        # Instance Configuration
        OPEN_REGISTRATION=true
        ENFORCE_EMAIL_VERIFICATION=false
        PF_MAX_USERS=1000
        OAUTH_ENABLED=false

        # Media Configuration
        PF_OPTIMIZE_IMAGES=true
        IMAGE_QUALITY=80
        MAX_PHOTO_SIZE=15000
        MAX_CAPTION_LENGTH=500
        MAX_ALBUM_LENGTH=4

        # Instance URL Configuration
        APP_URL=https://127.0.0.1
        APP_DOMAIN=127.0.0.1
        ADMIN_DOMAIN=127.0.0.1
        SESSION_DOMAIN=127.0.0.1
        TRUST_PROXIES=*


        # Redis Configuration
        REDIS_CLIENT=predis
        REDIS_SCHEME=tcp
        REDIS_HOST=127.0.0.1
        REDIS_PASSWORD=null
        REDIS_PORT=6379

        # Laravel Configuration
        SESSION_DRIVER=database
        CACHE_DRIVER=redis
        QUEUE_DRIVER=redis
        BROADCAST_DRIVER=log
        LOG_CHANNEL=stack
        HORIZON_PREFIX=horizon-

        # ActivityPub Configuration
        ACTIVITY_PUB=false
        AP_REMOTE_FOLLOW=false
        AP_INBOX=false
        AP_OUTBOX=false
        AP_SHAREDINBOX=false

        # Experimental Configuration
        EXP_EMC=true

        ## Mail Configuration (Post-Installer)
        MAIL_DRIVER=log
        MAIL_HOST=smtp.mailtrap.io
        MAIL_PORT=2525
        MAIL_USERNAME=null
        MAIL_PASSWORD=null
        MAIL_ENCRYPTION=null
        MAIL_FROM_ADDRESS=pixelfed@example.com
        MAIL_FROM_NAME=Pixelfed

        ## S3 Configuration (Post-Installer)
        PF_ENABLE_CLOUD=false
        FILESYSTEM_DRIVER=local
        FILESYSTEM_CLOUD=s3
        #AWS_ACCESS_KEY_ID=
        #AWS_SECRET_ACCESS_KEY=
        #AWS_DEFAULT_REGION=
        #AWS_BUCKET=<BucketName>
        #AWS_URL=
        #AWS_ENDPOINT=
        #AWS_USE_PATH_STYLE_ENDPOINT=false
        '';
      };

      # database config taken from zabbix.nix
      database = {
        type = mkOption {
          type = types.enum [ "mysql" "pgsql" ];
          example = "pgsql";
          default = "mysql";
          description = lib.mdDoc "Database engine to use.";
        };

        host = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = lib.mdDoc "Database host address.";
        };

        port = mkOption {
          type = types.int;
          default =
            if cfg.database.type == "mysql" then (head config.services.mysql.settings.mysqld.port)
            else config.services.postgresql.port;
          defaultText = literalExpression ''
            if config.services.pixelfed == "mysql" then config.services.mysql.port
            else config.services.postgresql.port
          '';
          description = lib.mdDoc "Database host port.";
        };

        name = mkOption {
          type = types.str;
          default = "pixelfed";
          description = lib.mdDoc "Database name.";
        };

        user = mkOption {
          type = types.str;
          default = "pixelfed";
          description = lib.mdDoc "Database user.";
        };

        password = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc ''
            The database user's password.
          '';
        };

      };

      appKey = mkOption {
        type = types.str;
        description = lib.mdDoc '' A random
          32-character string to be used as an encryption key. No default value;
          use php artisan key:generate in the dataDir to generate. '';
      };

      maxUploadSize = mkOption {
        type =  types.ints.positive;
        default = 8;
        description = lib.mdDoc ''
      Max upload size in megabytes.
      '';
      };

      hostName = mkOption {
        type = types.str;
        description = lib.mdDoc ''
        FQDN for the pixelfed instance.
      '';
      };

      nginx.enableACME = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
        Whether or not to enable ACME and let's encrypt for the pixelfed vhost.
      '';
      };


      poolConfig = mkOption {
        type = with types; attrsOf (oneOf [ int str bool ]);
        default = {
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

        description = lib.mdDoc ''
        Options for pixelfed's PHPFPM pool.
      '';
      };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/pixelfed";
        description = lib.mdDoc ''
        Home directory of the `pixelfed` user which holds
        the application's state.
        '';
      };

    };
  };


  config = mkIf cfg.enable {
    users.users.pixelfed = {
      isSystemUser = true;
      group = "nginx";
      home = cfg.dataDir;
      createHome = true;
    };

    environment.systemPackages = [ artisan ];

    services.phpfpm.pools.pixelfed = {
      user = "pixelfed";
      group = "nginx";

      phpPackage = pkgs.php80;

      phpOptions = ''
        post_max_size = ${toString cfg.maxUploadSize}M
        upload_max_filesize = ${toString cfg.maxUploadSize}M
        max_execution_time = 600;
      '';

      settings = {
        "user" = "${user}";
        "group" = "${group}";
        "listen.owner" = "nginx";
        "listen.group" = "nginx";
        "listen.mode" = "0660";
        "catch_workers_output" = "yes";
      } // cfg.poolConfig;

    };

    systemd.services.pixelfed-data-setup = {
      description = "Setup dataDir for pixelfed and change permissions";
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [ bash ];

      script = ''
        rm '${cfg.dataDir}/.env' -f
        ln -s ${configFile} '${cfg.dataDir}/.env'

        # migrate db
        ${pkgs.php}/bin/php artisan migrate --force

        ${pkgs.php}/bin/php artisan route:cache
        ${pkgs.php}/bin/php artisan view:cache
        ${pkgs.php}/bin/php artisan config:cache


        chown -R ${user}:${group} '${cfg.dataDir}'/. # change user/group to pixelfed user and nginx group
        chmod -R 755 ${cfg.dataDir}
      '';
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir}                            0710 ${user} ${group} - -"
      "d ${cfg.dataDir}/bootstrap                  0750 ${user} ${group} - -"
      "d ${cfg.dataDir}/bootstrap/cache            0750 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage                    0755 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/app                0755 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/app/backups        0700 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/app/public         0750 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/app/public/avatars 0750 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/app/public/emoji   0750 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/app/public/headers 0750 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/app/public/live-hls 0750 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/app/public/m       0750 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/app/public/textimg 0750 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/app/remcache       0700 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/debugbar           0700 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/framework          0700 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/framework/cache    0700 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/framework/sessions 0700 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/framework/views    0700 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/framework/testing  0700 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/logs               0700 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/purify             0700 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/uploads            0700 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/private_uploads    0700 ${user} ${group} - -"
    ];



    services.nginx = {
      enable = true;
      logError = "/var/log/nginx/error.log info";
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts."${cfg.hostName}" = mkMerge [
        { root = ''${pixelfed}/public/'';
          locations."/".extraConfig = ''
            try_files $uri $uri/ /index.php?$query_string;
          '';
          locations."/favicon.ico".extraConfig = ''
            access_log off; log_not_found off;
          '';
          locations."/robots.txt".extraConfig = ''
            access_log off; log_not_found off;
          '';
          locations."~ \\.php$".extraConfig = ''
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass unix:${config.services.phpfpm.pools.pixelfed.socket}; # make sure this is correct
            fastcgi_index index.php;
            include ${config.services.nginx.package}/conf/fastcgi.conf;
            include ${config.services.nginx.package}/conf/fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name; # or $request_filename
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
          '';
          forceSSL = true; # pixelfed requires ssl
        }
        (mkIf cfg.nginx.enableACME {
          enableACME = true;
        })
      ];
    };
  };
}
