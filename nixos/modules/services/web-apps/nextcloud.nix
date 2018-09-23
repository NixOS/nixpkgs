{ config, lib, pkgs, ... }@args:

with lib;

let
  cfg = config.services.nextcloud;

  phpOptionsExtensions = ''
    ${optionalString cfg.caching.apcu "extension=${pkgs.php71Packages.apcu}/lib/php/extensions/apcu.so"}
    ${optionalString cfg.caching.redis "extension=${pkgs.php71Packages.redis}/lib/php/extensions/redis.so"}
    ${optionalString cfg.caching.memcached "extension=${pkgs.php71Packages.memcached}/lib/php/extensions/memcached.so"}
    zend_extension = opcache.so
    opcache.enable = 1
  '';
  phpOptions = {
    upload_max_filesize = cfg.maxUploadSize;
    post_max_size = cfg.maxUploadSize;
    memory_limit = cfg.maxUploadSize;
  } // cfg.phpOptions;
  phpOptionsStr = phpOptionsExtensions + (concatStringsSep "\n" (mapAttrsToList (k: v: "k = v") phpOptions));

  occ = pkgs.writeScriptBin "nextcloud-occ" ''
    #! ${pkgs.stdenv.shell}
    cd ${pkgs.nextcloud}
    exec ${pkgs.sudo}/bin/sudo -u nextcloud \
      NEXTCLOUD_CONFIG_DIR="${cfg.home}/config" \
      ${config.services.phpfpm.phpPackage}/bin/php \
      -c ${pkgs.writeText "php.ini" phpOptionsStr}\
      occ $*
  '';

in {
  options.services.nextcloud = {
    enable = mkEnableOption "nextcloud";
    hostName = mkOption {
      type = types.str;
      description = "FQDN for the nextcloud instance.";
    };
    home = mkOption {
      type = types.str;
      default = "/var/lib/nextcloud";
      description = "Storage path of nextcloud.";
    };
    https = mkOption {
      type = types.bool;
      default = false;
      description = "Enable if there is a TLS terminating proxy in front of nextcloud.";
    };

    maxUploadSize = mkOption {
      default = "512M";
      type = types.str;
      description = ''
        Defines the upload limit for files. This changes the relevant options
        in php.ini and nginx if enabled.
      '';
    };

    skeletonDirectory = mkOption {
      default = "";
      type = types.str;
      description = ''
        The directory where the skeleton files are located. These files will be
        copied to the data directory of new users. Leave empty to not copy any
        skeleton files.
      '';
    };

    nginx.enable = mkEnableOption "nginx vhost management";

    webfinger = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable this option if you plan on using the webfinger plugin.
        The appropriate nginx rewrite rules will be added to your configuration.
      '';
    };

    phpOptions = mkOption {
      type = types.attrsOf types.str;
      default = {
        "short_open_tag" = "Off";
        "expose_php" = "Off";
        "disable_functions" = "pcntl_alarm,pcntl_fork,pcntl_waitpid,pcntl_wait,pcntl_wifexited,pcntl_wifstopped,pcntl_wifsignaled,pcntl_wexitstatus,pcntl_wtermsig,pcntl_wstopsig,pcntl_signal,pcntl_signal_dispatch,pcntl_get_last_error,pcntl_strerror,pcntl_sigprocmask,pcntl_sigwaitinfo,pcntl_sigtimedwait,pcntl_exec,pcntl_getpriority,pcntl_setpriority";
        "error_reporting" = "E_ALL & ~E_DEPRECATED & ~E_STRICT";
        "display_errors" = "stderr";
        "opcache.enable_cli" = "1";
        "opcache.interned_strings_buffer" = "8";
        "opcache.max_accelerated_files" = "10000";
        "opcache.memory_consumption" = "128";
        "opcache.revalidate_freq" = "1";
        "opcache.fast_shutdown" = "1";
        "openssl.cafile" = "/etc/ssl/certs/ca-certificates.crt";
        "sendmail_path" = "/var/setuid-wrappers/sendmail -t -i";
        "catch_workers_output" = "yes";
      };
      description = ''
        Options for PHP's php.ini file for nextcloud.
      '';
    };

    autoconfig = {
      dbtype = mkOption {
        type = types.str;
        default = "sqlite";
        description = "Database Type";
      };
      dbname = mkOption {
        type = types.str;
        default = "nextcloud";
        description = "Database Name";
      };
      dbuser = mkOption {
        type = types.str;
        default = "nextcloud";
        description = "Database User";
      };
      dbpass = mkOption {
        type = types.str;
        default = "";
        description = "Database Password";
      };
      dbhost = mkOption {
        type = types.str;
        default = "localhost";
        description = "Database Host";
      };
      dbtableprefix = mkOption {
        type = types.str;
        default = "";
        description = "Table Prefix in Nextlcoud Database";
      };
      adminlogin = mkOption {
        type = types.str;
        default = "root";
        description = "Admin Username";
      };
      adminpass = mkOption {
        type = types.str;
        description = "Admin Password";
      };
    };

    caching = {
      apcu = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to load the APCu module into PHP.
        '';
      };
      redis = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to load the Redis module into PHP.
          You still need to enable Redis in your config.php.
          See https://docs.nextcloud.com/server/13/admin_manual/configuration_server/caching_configuration.html
        '';
      };
      memcached = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to load the Memcached module into PHP.
          You still need to enable Memcached in your config.php.
          See https://docs.nextcloud.com/server/13/admin_manual/configuration_server/caching_configuration.html
        '';
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [

    { systemd.timers."nextcloud-cron" = {
        wantedBy = [ "timers.target" ];
        timerConfig.OnBootSec = "5m";
        timerConfig.OnUnitActiveSec = "15m";
        timerConfig.Unit = "nextcloud-cron.service";
      };

      systemd.services = {
        "nextcloud-setup" = let
          overrideConfig = pkgs.writeText "nextcloud-config.php" ''
            <?php
            $CONFIG = [
              'apps_paths' => [
                [ 'path' => '${cfg.home}/apps', 'url' => '/apps', 'writable' => false ],
                [ 'path' => '${cfg.home}/store-apps', 'url' => '/store-apps', 'writable' => true ],
              ],
              'datadirectory' => '${cfg.home}/data',
              'skeletondirectory' => '${cfg.skeletonDirectory}',
              ${optionalString cfg.caching.apcu "'memcache.local' => '\\OC\\Memcache\\APCu',"}
              'log_type' => 'syslog',
            ];
          '';
          autoConfig = pkgs.writeText "nextcloud-autoconfig.php" (let acfg = cfg.autoconfig; in ''
            <?php
            $AUTOCONFIG = [
              "dbtype"        => "${acfg.dbtype}",
              "dbname"        => "${acfg.dbname}",
              "dbuser"        => "${acfg.dbuser}",
              "dbpass"        => "${acfg.dbpass}",
              "dbhost"        => "${acfg.dbhost}",
              "dbtableprefix" => "${acfg.dbtableprefix}",
              "adminlogin"    => "${acfg.adminlogin}",
              "adminpass"     => "${acfg.adminpass}",
              "directory"     => "${cfg.home}/data",
            ];
          '');
        in {
          wantedBy = [ "multi-user.target" ];
          before = [ "phpfpm-nextcloud.service" ];
          script = ''
            chmod og+x ${cfg.home}
            ln -sf ${pkgs.nextcloud}/apps ${cfg.home}/
            mkdir -p ${cfg.home}/config ${cfg.home}/data ${cfg.home}/store-apps
            ln -sf ${overrideConfig} ${cfg.home}/config/override.config.php

            # Do not create autoconfig if already installed
            [ -e ${cfg.home}/config/config.php ] && exit 0

            ln -sf ${autoConfig} ${cfg.home}/config/autoconfig.php
            chown -R nextcloud:nginx ${cfg.home}/config ${cfg.home}/data ${cfg.home}/store-apps
          '';
          serviceConfig.Type = "oneshot";
        };
        "nextcloud-cron" = {
          environment.NEXTCLOUD_CONFIG_DIR = "${cfg.home}/config";
          serviceConfig.Type = "oneshot";
          serviceConfig.User = "nextcloud";
          serviceConfig.ExecStart = "${pkgs.php}/bin/php -f ${pkgs.nextcloud}/cron.php";
        };
      };

      services.phpfpm = {
        phpOptions = phpOptionsExtensions;
        phpPackage = pkgs.php71;
        pools.nextcloud = let
          phpAdminValues = concatStringsSep "\n" (flip mapAttrsToList phpOptions
            (k: v: "php_admin_value[${k}] = ${v}"));
        in {
          listen = "/run/phpfpm/nextcloud";
          extraConfig = ''
            listen.owner = nginx
            listen.group = nginx
            user = nextcloud
            group = nginx
            pm = dynamic
            pm.max_children = 32
            pm.start_servers = 2
            pm.min_spare_servers = 2
            pm.max_spare_servers = 4
            env[NEXTCLOUD_CONFIG_DIR] = ${cfg.home}/config
            env[PATH] = /bin
            ${phpAdminValues}
          '';
        };
      };

      users.extraUsers.nextcloud = {
        home = "${cfg.home}";
        group = "nginx";
        createHome = true;
      };

      environment.systemPackages = [ occ ];
    }

    (mkIf cfg.nginx.enable {
      services.nginx = {
        enable = true;
        virtualHosts = {
          "${cfg.hostName}" = {
            root = pkgs.nextcloud;
            locations = {
              "= /robots.txt" = {
                priority = 100;
                extraConfig = ''
                  allow all;
                  log_not_found off;
                  access_log off;
                '';
              };
              "/" = {
                priority = 200;
                extraConfig = "rewrite ^ /index.php$uri;";
              };
              "~ ^/store-apps" = {
                priority = 201;
                extraConfig = "root ${cfg.home};";
              };
              "= /.well-known/carddav" = {
                priority = 210;
                extraConfig = "return 301 $scheme://$host/remote.php/dav;";
              };
              "= /.well-known/caldav" = {
                priority = 210;
                extraConfig = "return 301 $scheme://$host/remote.php/dav;";
              };
              "~ ^/(?:build|tests|config|lib|3rdparty|templates|data)/" = {
                priority = 300;
                extraConfig = "deny all;";
              };
              "~ ^/(?:\\.|autotest|occ|issue|indie|db_|console)" = {
                priority = 300;
                extraConfig = "deny all;";
              };
              "~ ^/(?:index|remote|public|cron|core/ajax/update|status|ocs/v[12]|updater/.+|ocs-provider/.+)\\.php(?:$|/)" = {
                priority = 500;
                extraConfig = ''
                  include ${pkgs.nginxMainline}/conf/fastcgi.conf;
                  fastcgi_split_path_info ^(.+\.php)(/.*)$;
                  fastcgi_param PATH_INFO $fastcgi_path_info;
                  fastcgi_param HTTPS ${if cfg.https then "on" else "off"};
                  fastcgi_param modHeadersAvailable true;
                  fastcgi_param front_controller_active true;
                  fastcgi_pass unix:/run/phpfpm/nextcloud;
                  fastcgi_intercept_errors on;
                  fastcgi_request_buffering off;
                  fastcgi_read_timeout 120s;
                '';
              };
              "~ ^/(?:updater|ocs-provider)(?:$|/)".extraConfig = ''
                try_files $uri/ =404;
                index index.php;
              '';
              "~ \\.(?:css|js|woff|svg|gif)$".extraConfig = ''
                try_files $uri /index.php$uri$is_args$args;
                add_header Cache-Control "public, max-age=15778463";
                add_header X-Content-Type-Options nosniff;
                add_header X-XSS-Protection "1; mode=block";
                add_header X-Robots-Tag none;
                add_header X-Download-Options noopen;
                add_header X-Permitted-Cross-Domain-Policies none;
                access_log off;
              '';
              "~ \\.(?:png|html|ttf|ico|jpg|jpeg)$".extraConfig = ''
                try_files $uri /index.php$uri$is_args$args;
                access_log off;
              '';
            };
            extraConfig = ''
              add_header X-Content-Type-Options nosniff;
              add_header X-XSS-Protection "1; mode=block";
              add_header X-Robots-Tag none;
              add_header X-Download-Options noopen;
              add_header X-Permitted-Cross-Domain-Policies none;
              error_page 403 /core/templates/403.php;
              error_page 404 /core/templates/404.php;
              client_max_body_size ${cfg.maxUploadSize};
              fastcgi_buffers 64 4K;
              gzip on;
              gzip_vary on;
              gzip_comp_level 4;
              gzip_min_length 256;
              gzip_proxied expired no-cache no-store private no_last_modified no_etag auth;
              gzip_types application/atom+xml application/javascript application/json application/ld+json application/manifest+json application/rss+xml application/vnd.geo+json application/vnd.ms-fontobject application/x-font-ttf application/x-web-app-manifest+json application/xhtml+xml application/xml font/opentype image/bmp image/svg+xml image/x-icon text/cache-manifest text/css text/plain text/vcard text/vnd.rim.location.xloc text/vtt text/x-component text/x-cross-domain-policy;

              ${optionalString cfg.webfinger ''
                rewrite ^/.well-known/host-meta /public.php?service=host-meta last;
                rewrite ^/.well-known/host-meta.json /public.php?service=host-meta-json last;
              ''}
            '';
          };
        };
      };
    })
  ]);
}
