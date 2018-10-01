{ config, pkgs, lib, ... }: with lib; let
  cfg = config.services.nextcloud;
  poolName = "nextcloud";
  phpfpmSocketName = "/var/run/phpfpm/${poolName}.sock";
  webroot = "${if cfg.webroot == null then "/" else "${cfg.webroot}/"}";
  rootDirectory = pkgs.stdenv.mkDerivation {
    name = "nextcloud-root";
    phases = [ "installPhase" ];

    installPhase = ''
      mkdir -p "$out${webroot}"

      # Copy NextCloud here
      shopt -s dotglob
      cp -r ${pkgs.nextcloud}/* "$out${webroot}"

      mv "$out${webroot}apps" "$out${webroot}.apps"
      ln -s /var/lib/nextcloud/apps "$out${webroot}apps"
    '';
  };
in {
  options.services.nextcloud = with types; {
    enable = mkEnableOption "Whether to enable NextCloud";

    user = mkOption {
      type = str;
      default = "nobody";
      description = ''
        User account under which the web-application runs.
      '';
    };

    webroot = mkOption {
      type = nullOr str;
      default = null;
      example = "nextcloud/";
      description = ''
        Directory part of the URL under which NextCloud should be served.
      '';
    };

    webfinger = mkOption {
      type = bool;
      default = false;
      description = ''
        Enable this option if you plan on using the webfinger plugin.
        The appropriate nginx rewrite rules will be added to your configuration.
      '';
    };

    assetAccessLog = mkOption {
      type = bool;
      default = false;
      description = ''
        Enable access log for static assets such as icons and stylesheets.
      '';
    };

    apcu = mkOption {
      type = bool;
      default = false;
      description = ''
        Whether to load the APCu module into PHP.
        You still need to enable APCu in your config.php.
      '';
    };

    redis = mkOption {
      type = bool;
      default = false;
      description = ''
        Whether to load the Redis module into PHP.
        You still need to enable Redis in your config.php.
      '';
    };

    memcached = mkOption {
      type = bool;
      default = false;
      description = ''
        Whether to load the Memcached module into PHP.
        You still need to enable Memcached in your config.php.
      '';
    };

    timer = mkOption {
      type = bool;
      default = false;
      description = ''
        Enables a systemd timer that performs housekeeping activities every 15mins.
        Remember to switch to Cron in the admin interface.
      '';
    };

    maxBodySize = mkOption {
      type = str;
      default = "512M";
      description = ''
        Maximum size of uploaded files.
      '';
    };

    pool = mkOption {
      type = str;
      default = "nextcloud";
      description = ''
        Name of existing PHP-FPM pool that is used to run NextCloud.
        If not specified, a pool will automatically created with default values.
      '';
    };

    virtualHost = mkOption {
      type = types.nullOr types.str;
      default = "nextcloud";
      description = ''
        Name of the nginx virtualhost to use and setup. If null, no virtualhost is set up.
      '';
    };
  };
  config = mkIf cfg.enable {
    # PHP-FPM pool
    services.phpfpm.poolConfigs = mkIf (cfg.pool == "${poolName}") {
      "${poolName}" = ''
        listen = "${phpfpmSocketName}";
        listen.owner = nginx
        listen.group = nginx
        listen.mode = 0600
        user = ${cfg.user}
        pm = dynamic
        pm.max_children = 32
        pm.max_requests = 500
        pm.start_servers = 2
        pm.min_spare_servers = 2
        pm.max_spare_servers = 5
        ; Logging
        php_admin_value[error_log] = 'stderr'
        php_admin_flag[log_errors] = on
        catch_workers_output = yes
        ; Set correct config directory
        env[NEXTCLOUD_CONFIG_DIR] = /etc/nextcloud
        ; This gets checked by NextCloud health checks
        env[PATH] = ${lib.makeBinPath [ pkgs.php ]}
      '';
    };
    # Permissions
    systemd.services."phpfpm-${cfg.pool}" = {
      serviceConfig = {
        ConfigurationDirectory = "nextcloud";
        StateDirectory = "nextcloud";
      };
      preStart = ''
        # Ensure apps directory
        if ! [ -d /var/lib/nextcloud/apps ]; then
          cp -r "${rootDirectory}${webroot}.apps" /var/lib/nextcloud/apps
          chown -R "${cfg.user}:nginx" /var/lib/nextcloud/apps
        fi

        # Ensure directories
        mkdir -p /etc/nextcloud /var/lib/nextcloud/data
        chown "${cfg.user}:nginx" /etc/nextcloud /var/lib/nextcloud/apps /var/lib/nextcloud/data
        chmod 750 /etc/nextcloud /var/lib/nextcloud/apps /var/lib/nextcloud/data

        # Add apps directory to config
        if [ -f /etc/nextcloud/config.php ]; then
          if ! grep -q apps_paths /etc/nextcloud/config.php; then
            sed -i 's:\$CONFIG = array (:$CONFIG = array ( "apps_paths" => array (0 => array ( "path" => "/var/lib/nextcloud/apps", "url" => "/apps", "writable" => true ) ),:g' /etc/nextcloud/config.php
          fi
        else
          echo '<?php
            $CONFIG = array (
              "apps_paths" => array (0 => array ( "path" => "/var/lib/nextcloud/apps", "url" => "/apps", "writable" => true ) ),
            );' > /etc/nextcloud/config.php
          chown "${cfg.user}:nginx" /etc/nextcloud/config.php
        fi

        # Add data directory to config
        if ! grep -q datadirectory /etc/nextcloud/config.php; then
          sed -i 's:\$CONFIG = array (:$CONFIG = array ( "datadirectory" => "/var/lib/nextcloud/data",:g' /etc/nextcloud/config.php
        fi
      '';
    };

    # Memory caching
    services.phpfpm.phpOptions = ''
      # Load opcache
      zend_extension=${pkgs.php}/lib/php/extensions/opcache.so

      # Enable opcache
      opcache.enable=1
      opcache.enable_cli=1
      opcache.interned_strings_buffer=8
      opcache.max_accelerated_files=10000
      opcache.memory_consumption=128
      opcache.save_comments=1
      opcache.revalidate_freq=1

      ${optionalString cfg.apcu "extension=${pkgs.phpPackages.apcu}/lib/php/extensions/apcu.so"}
      ${optionalString cfg.redis "extension=${pkgs.phpPackages.redis}/lib/php/extensions/redis.so"}
      ${optionalString cfg.memcached "extension=${pkgs.phpPackages.memcached}/lib/php/extensions/memcached.so"}
    '';

    # nginx vhost
    services.nginx = mkIf (cfg.virtualHost != null) {
      enable = true;
      virtualHosts."${cfg.virtualHost}" = {
        root = "${rootDirectory}/";

        extraConfig = ''
          # Set security-related headers
          add_header X-Content-Type-Options nosniff;
          add_header X-Frame-Options "SAMEORIGIN";
          add_header X-XSS-Protection "1; mode=block";
          add_header X-Robots-Tag none;
          add_header X-Download-Options noopen;
          add_header X-Permitted-Cross-Domain-Policies none;

          ${optionalString cfg.webfinger ''
            rewrite ^/.well-known/host-meta ${webroot}public.php?service=host-meta last;
            rewrite ^/.well-known/host-meta.json ${webroot}public.php?service=host-meta-json last;
          ''}

          # Max upload size
          client_max_body_size ${cfg.maxBodySize};
          fastcgi_buffers 64 4K;

          # Robots.txt
          location = /robots.txt {
            allow all;
            log_not_found off;
            access_log off;
          }

          location = /.well-known/carddav {
            return 301 $scheme://$host${webroot}remote.php/dav;
          }
          location = /.well-known/caldav {
            return 301 $scheme://$host${webroot}remote.php/dav;
          }

          # Pretty URLs
          location ${webroot} {
            rewrite ^ ${webroot}index.php$uri;
          }

          # Deny some access
          location ~ ^/(?:build|tests|config|lib|3rdparty|templates|data)/ {
            deny all;
          }
          location ~ ^/(?:\.|autotest|occ|issue|indie|db_|console) {
            deny all;
          }

          # Forward requests to PHP
          location ~ ^${webroot}(?:index|remote|public|cron|core/ajax/update|status|ocs/v[12]|updater/.+|ocs-provider/.+|core/templates/40[34])\.php(?:$|/) {
            fastcgi_split_path_info ^(.+\.php)(/.*)$;
            include ${pkgs.nginx}/conf/fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            fastcgi_param PATH_INFO $fastcgi_path_info;
            fastcgi_param HTTPS on;
            # Avoid sending the security headers twice
            fastcgi_param modHeadersAvailable true;
            fastcgi_param front_controller_active true;
            fastcgi_pass unix:${phpfpmSocketName};
            fastcgi_intercept_errors on;
            fastcgi_request_buffering off;
          }

          # Skip pretty URLs for the updater
          location ~ ^${webroot}(?:updater|ocs-provider)(?:$|/) {
            try_files $uri/ =404;
            index index.php;
          }

          # Add cache control header for js and css files
          # This must be BELOW the PHP block
          location ~* \.(?:css|js|woff|svg|gif)$ {
            try_files $uri ${webroot}index.php$uri$is_args$args;
            add_header Cache-Control "public, max-age=7200";
            include ${pkgs.nginx}/conf/mime.types;
            # Set security-related headers
            add_header X-Content-Type-Options nosniff;
            add_header X-Frame-Options "SAMEORIGIN";
            add_header X-XSS-Protection "1; mode=block";
            add_header X-Robots-Tag none;
            add_header X-Download-Options noopen;
            add_header X-Permitted-Cross-Domain-Policies none;
            ${optionalString cfg.assetAccessLog "access_log off;"}
          }

          # Binary assets
          location ~* \.(?:png|html|ttf|ico|jpg|jpeg)$ {
            try_files $uri ${webroot}index.php$uri$is_args$args;
            include ${pkgs.nginx}/conf/mime.types;
            ${optionalString cfg.assetAccessLog "access_log off;"}
          }
        '';
      };
    };

    # Housekeeping service
    systemd.services."nextcloud-cron" = mkIf cfg.timer {
      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
        Environment = "NEXTCLOUD_CONFIG_DIR=/etc/nextcloud";
        ExecStart = "${pkgs.php}/bin/php -f ${rootDirectory}/cron.php";
      };
      startAt = "*:0/15";
    };

    # occ command
    environment.shellAliases.occ = "${pkgs.su}/bin/su - ${cfg.user} -s ${pkgs.stdenv.shell} -c \"NEXTCLOUD_CONFIG_DIR=/etc/nextcloud ${pkgs.php}/bin/php \\$0 \\$@\" -- ${rootDirectory}/occ";
  };
}
