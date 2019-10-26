{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nextcloud;
  fpm = config.services.phpfpm.pools.nextcloud;

  phpPackage = pkgs.php73;
  phpPackages = pkgs.php73Packages;

  toKeyValue = generators.toKeyValue {
    mkKeyValue = generators.mkKeyValueDefault {} " = ";
  };

  phpOptionsExtensions = ''
    ${optionalString cfg.caching.apcu "extension=${phpPackages.apcu}/lib/php/extensions/apcu.so"}
    ${optionalString cfg.caching.redis "extension=${phpPackages.redis}/lib/php/extensions/redis.so"}
    ${optionalString cfg.caching.memcached "extension=${phpPackages.memcached}/lib/php/extensions/memcached.so"}
    extension=${phpPackages.imagick}/lib/php/extensions/imagick.so
    zend_extension = opcache.so
    opcache.enable = 1
  '';
  phpOptions = {
    upload_max_filesize = cfg.maxUploadSize;
    post_max_size = cfg.maxUploadSize;
    memory_limit = cfg.maxUploadSize;
  } // cfg.phpOptions;
  phpOptionsStr = phpOptionsExtensions + (toKeyValue phpOptions);

  occ = pkgs.writeScriptBin "nextcloud-occ" ''
    #! ${pkgs.stdenv.shell}
    cd ${pkgs.nextcloud}
    exec /run/wrappers/bin/sudo -u nextcloud \
      NEXTCLOUD_CONFIG_DIR="${cfg.home}/config" \
      ${phpPackage}/bin/php \
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
    logLevel = mkOption {
      type = types.ints.between 0 4;
      default = 2;
      description = "Log level value between 0 (DEBUG) and 4 (FATAL).";
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

    nginx.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable nginx virtual host management.
        Further nginx configuration can be done by adapting <literal>services.nginx.virtualHosts.&lt;name&gt;</literal>.
        See <xref linkend="opt-services.nginx.virtualHosts"/> for further information.
      '';
    };

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
        short_open_tag = "Off";
        expose_php = "Off";
        error_reporting = "E_ALL & ~E_DEPRECATED & ~E_STRICT";
        display_errors = "stderr";
        "opcache.enable_cli" = "1";
        "opcache.interned_strings_buffer" = "8";
        "opcache.max_accelerated_files" = "10000";
        "opcache.memory_consumption" = "128";
        "opcache.revalidate_freq" = "1";
        "opcache.fast_shutdown" = "1";
        "openssl.cafile" = "/etc/ssl/certs/ca-certificates.crt";
        catch_workers_output = "yes";
      };
      description = ''
        Options for PHP's php.ini file for nextcloud.
      '';
    };

    poolSettings = mkOption {
      type = with types; attrsOf (oneOf [ str int bool ]);
      default = {
        "pm" = "dynamic";
        "pm.max_children" = "32";
        "pm.start_servers" = "2";
        "pm.min_spare_servers" = "2";
        "pm.max_spare_servers" = "4";
        "pm.max_requests" = "500";
      };
      description = ''
        Options for nextcloud's PHP pool. See the documentation on <literal>php-fpm.conf</literal> for details on configuration directives.
      '';
    };

    poolConfig = mkOption {
      type = types.nullOr types.lines;
      default = null;
      description = ''
        Options for nextcloud's PHP pool. See the documentation on <literal>php-fpm.conf</literal> for details on configuration directives.
      '';
    };

    config = {
      dbtype = mkOption {
        type = types.enum [ "sqlite" "pgsql" "mysql" ];
        default = "sqlite";
        description = "Database type.";
      };
      dbname = mkOption {
        type = types.nullOr types.str;
        default = "nextcloud";
        description = "Database name.";
      };
      dbuser = mkOption {
        type = types.nullOr types.str;
        default = "nextcloud";
        description = "Database user.";
      };
      dbpass = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Database password.  Use <literal>dbpassFile</literal> to avoid this
          being world-readable in the <literal>/nix/store</literal>.
        '';
      };
      dbpassFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          The full path to a file that contains the database password.
        '';
      };
      dbhost = mkOption {
        type = types.nullOr types.str;
        default = "localhost";
        description = ''
          Database host.

          Note: for using Unix authentication with PostgreSQL, this should be
          set to <literal>/run/postgresql</literal>.
        '';
      };
      dbport = mkOption {
        type = with types; nullOr (either int str);
        default = null;
        description = "Database port.";
      };
      dbtableprefix = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Table prefix in Nextcloud database.";
      };
      adminuser = mkOption {
        type = types.str;
        default = "root";
        description = "Admin username.";
      };
      adminpass = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Admin password.  Use <literal>adminpassFile</literal> to avoid this
          being world-readable in the <literal>/nix/store</literal>.
        '';
      };
      adminpassFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          The full path to a file that contains the admin's password.
        '';
      };

      extraTrustedDomains = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Trusted domains, from which the nextcloud installation will be
          acessible.  You don't need to add
          <literal>services.nextcloud.hostname</literal> here.
        '';
      };

      overwriteProtocol = mkOption {
        type = types.nullOr (types.enum [ "http" "https" ]);
        default = null;
        example = "https";

        description = ''
          Force Nextcloud to always use HTTPS i.e. for link generation. Nextcloud
          uses the currently used protocol by default, but when behind a reverse-proxy,
          it may use <literal>http</literal> for everything although Nextcloud
          may be served via HTTPS.
        '';
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
          See https://docs.nextcloud.com/server/14/admin_manual/configuration_server/caching_configuration.html
        '';
      };
      memcached = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to load the Memcached module into PHP.
          You still need to enable Memcached in your config.php.
          See https://docs.nextcloud.com/server/14/admin_manual/configuration_server/caching_configuration.html
        '';
      };
    };
    autoUpdateApps = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Run regular auto update of all apps installed from the nextcloud app store.
        '';
      };
      startAt = mkOption {
        type = with types; either str (listOf str);
        default = "05:00:00";
        example = "Sun 14:00:00";
        description = ''
          When to run the update. See `systemd.services.&lt;name&gt;.startAt`.
        '';
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    { assertions = let acfg = cfg.config; in [
        { assertion = !(acfg.dbpass != null && acfg.dbpassFile != null);
          message = "Please specify no more than one of dbpass or dbpassFile";
        }
        { assertion = ((acfg.adminpass != null || acfg.adminpassFile != null)
            && !(acfg.adminpass != null && acfg.adminpassFile != null));
          message = "Please specify exactly one of adminpass or adminpassFile";
        }
      ];

      warnings = optional (cfg.poolConfig != null) ''
        Using config.services.nextcloud.poolConfig is deprecated and will become unsupported in a future release.
        Please migrate your configuration to config.services.nextcloud.poolSettings.
      '';
    }

    { systemd.timers.nextcloud-cron = {
        wantedBy = [ "timers.target" ];
        timerConfig.OnBootSec = "5m";
        timerConfig.OnUnitActiveSec = "15m";
        timerConfig.Unit = "nextcloud-cron.service";
      };

      systemd.services = {
        nextcloud-setup = let
          c = cfg.config;
          writePhpArrary = a: "[${concatMapStringsSep "," (val: ''"${toString val}"'') a}]";
          overrideConfig = pkgs.writeText "nextcloud-config.php" ''
            <?php
            ${optionalString (c.dbpassFile != null) ''
              function nix_read_pwd() {
                $file = "${c.dbpassFile}";
                if (!file_exists($file)) {
                  throw new \RuntimeException(sprintf(
                    "Cannot start Nextcloud, dbpass file %s set by NixOS doesn't exist!",
                    $file
                  ));
                }

                return trim(file_get_contents($file));
              }
            ''}
            $CONFIG = [
              'apps_paths' => [
                [ 'path' => '${cfg.home}/apps', 'url' => '/apps', 'writable' => false ],
                [ 'path' => '${cfg.home}/store-apps', 'url' => '/store-apps', 'writable' => true ],
              ],
              'datadirectory' => '${cfg.home}/data',
              'skeletondirectory' => '${cfg.skeletonDirectory}',
              ${optionalString cfg.caching.apcu "'memcache.local' => '\\OC\\Memcache\\APCu',"}
              'log_type' => 'syslog',
              'log_level' => '${builtins.toString cfg.logLevel}',
              ${optionalString (c.overwriteProtocol != null) "'overwriteprotocol' => '${c.overwriteProtocol}',"}
              ${optionalString (c.dbname != null) "'dbname' => '${c.dbname}',"}
              ${optionalString (c.dbhost != null) "'dbhost' => '${c.dbhost}',"}
              ${optionalString (c.dbport != null) "'dbport' => '${toString c.dbport}',"}
              ${optionalString (c.dbuser != null) "'dbuser' => '${c.dbuser}',"}
              ${optionalString (c.dbtableprefix != null) "'dbtableprefix' => '${toString c.dbtableprefix}',"}
              ${optionalString (c.dbpass != null) "'dbpassword' => '${c.dbpass}',"}
              ${optionalString (c.dbpassFile != null) "'dbpassword' => nix_read_pwd(),"}
              'dbtype' => '${c.dbtype}',
              'trusted_domains' => ${writePhpArrary ([ cfg.hostName ] ++ c.extraTrustedDomains)},
            ];
          '';
          occInstallCmd = let
            dbpass = if c.dbpassFile != null
              then ''"$(<"${toString c.dbpassFile}")"''
              else if c.dbpass != null
              then ''"${toString c.dbpass}"''
              else null;
            adminpass = if c.adminpassFile != null
              then ''"$(<"${toString c.adminpassFile}")"''
              else ''"${toString c.adminpass}"'';
            installFlags = concatStringsSep " \\\n    "
              (mapAttrsToList (k: v: "${k} ${toString v}") {
              "--database" = ''"${c.dbtype}"'';
              # The following attributes are optional depending on the type of
              # database.  Those that evaluate to null on the left hand side
              # will be omitted.
              ${if c.dbname != null then "--database-name" else null} = ''"${c.dbname}"'';
              ${if c.dbhost != null then "--database-host" else null} = ''"${c.dbhost}"'';
              ${if c.dbport != null then "--database-port" else null} = ''"${toString c.dbport}"'';
              ${if c.dbuser != null then "--database-user" else null} = ''"${c.dbuser}"'';
              ${if (any (x: x != null) [c.dbpass c.dbpassFile])
                 then "--database-pass" else null} = dbpass;
              ${if c.dbtableprefix != null
                then "--database-table-prefix" else null} = ''"${toString c.dbtableprefix}"'';
              "--admin-user" = ''"${c.adminuser}"'';
              "--admin-pass" = adminpass;
              "--data-dir" = ''"${cfg.home}/data"'';
            });
          in ''
            ${occ}/bin/nextcloud-occ maintenance:install \
                ${installFlags}
          '';
          occSetTrustedDomainsCmd = concatStringsSep "\n" (imap0
            (i: v: ''
              ${occ}/bin/nextcloud-occ config:system:set trusted_domains \
                ${toString i} --value="${toString v}"
            '') ([ cfg.hostName ] ++ cfg.config.extraTrustedDomains));

        in {
          wantedBy = [ "multi-user.target" ];
          before = [ "phpfpm-nextcloud.service" ];
          script = ''
            chmod og+x ${cfg.home}
            ln -sf ${pkgs.nextcloud}/apps ${cfg.home}/
            mkdir -p ${cfg.home}/config ${cfg.home}/data ${cfg.home}/store-apps
            ln -sf ${overrideConfig} ${cfg.home}/config/override.config.php

            chown -R nextcloud:nginx ${cfg.home}/config ${cfg.home}/data ${cfg.home}/store-apps

            # Do not install if already installed
            if [[ ! -e ${cfg.home}/config/config.php ]]; then
              ${occInstallCmd}
            fi

            ${occ}/bin/nextcloud-occ upgrade

            ${occ}/bin/nextcloud-occ config:system:delete trusted_domains
            ${occSetTrustedDomainsCmd}
          '';
          serviceConfig.Type = "oneshot";
        };
        nextcloud-cron = {
          environment.NEXTCLOUD_CONFIG_DIR = "${cfg.home}/config";
          serviceConfig.Type = "oneshot";
          serviceConfig.User = "nextcloud";
          serviceConfig.ExecStart = "${phpPackage}/bin/php -f ${pkgs.nextcloud}/cron.php";
        };
        nextcloud-update-plugins = mkIf cfg.autoUpdateApps.enable {
          serviceConfig.Type = "oneshot";
          serviceConfig.ExecStart = "${occ}/bin/nextcloud-occ app:update --all";
          startAt = cfg.autoUpdateApps.startAt;
        };
      };

      services.phpfpm = {
        pools.nextcloud = {
          user = "nextcloud";
          group = "nginx";
          phpOptions = phpOptionsExtensions + phpOptionsStr;
          phpPackage = phpPackage;
          phpEnv = {
            NEXTCLOUD_CONFIG_DIR = "${cfg.home}/config";
            PATH = "/run/wrappers/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:/usr/bin:/bin";
          };
          settings = mapAttrs (name: mkDefault) {
            "listen.owner" = "nginx";
            "listen.group" = "nginx";
          } // cfg.poolSettings;
          extraConfig = cfg.poolConfig;
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
          ${cfg.hostName} = {
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
                extraConfig = "rewrite ^ /index.php;";
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
              "~ ^\\/(?:build|tests|config|lib|3rdparty|templates|data)\\/" = {
                priority = 300;
                extraConfig = "deny all;";
              };
              "~ ^\\/(?:\\.|autotest|occ|issue|indie|db_|console)" = {
                priority = 300;
                extraConfig = "deny all;";
              };
              "~ ^\\/(?:index|remote|public|cron|core/ajax\\/update|status|ocs\\/v[12]|updater\\/.+|ocs-provider\\/.+|ocm-provider\\/.+)\\.php(?:$|\\/)" = {
                priority = 500;
                extraConfig = ''
                  include ${config.services.nginx.package}/conf/fastcgi.conf;
                  fastcgi_split_path_info ^(.+\.php)(\\/.*)$;
                  try_files $fastcgi_script_name =404;
                  fastcgi_param PATH_INFO $fastcgi_path_info;
                  fastcgi_param HTTPS ${if cfg.https then "on" else "off"};
                  fastcgi_param modHeadersAvailable true;
                  fastcgi_param front_controller_active true;
                  fastcgi_pass unix:${fpm.socket};
                  fastcgi_intercept_errors on;
                  fastcgi_request_buffering off;
                  fastcgi_read_timeout 120s;
                '';
              };
              "~ ^\\/(?:updater|ocs-provider|ocm-provider)(?:$|\\/)".extraConfig = ''
                try_files $uri/ =404;
                index index.php;
              '';
              "~ \\.(?:css|js|woff2?|svg|gif)$".extraConfig = ''
                try_files $uri /index.php$request_uri;
                add_header Cache-Control "public, max-age=15778463";
                add_header X-Content-Type-Options nosniff;
                add_header X-XSS-Protection "1; mode=block";
                add_header X-Robots-Tag none;
                add_header X-Download-Options noopen;
                add_header X-Permitted-Cross-Domain-Policies none;
                add_header Referrer-Policy no-referrer;
                access_log off;
              '';
              "~ \\.(?:png|html|ttf|ico|jpg|jpeg)$".extraConfig = ''
                try_files $uri /index.php$request_uri;
                access_log off;
              '';
            };
            extraConfig = ''
              add_header X-Content-Type-Options nosniff;
              add_header X-XSS-Protection "1; mode=block";
              add_header X-Robots-Tag none;
              add_header X-Download-Options noopen;
              add_header X-Permitted-Cross-Domain-Policies none;
              add_header Referrer-Policy no-referrer;
              error_page 403 /core/templates/403.php;
              error_page 404 /core/templates/404.php;
              client_max_body_size ${cfg.maxUploadSize};
              fastcgi_buffers 64 4K;
              fastcgi_hide_header X-Powered-By;
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

  meta.doc = ./nextcloud.xml;
}
