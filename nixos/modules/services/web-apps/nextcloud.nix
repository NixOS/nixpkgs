{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nextcloud;
  fpm = config.services.phpfpm.pools.nextcloud;
  datadir = if cfg.datadir == null then "${cfg.home}" else "${cfg.datadir}";

  phpPackage = pkgs.php74.buildEnv {
    extensions = { enabled, all }:
      (with all;
        enabled
        ++ optional cfg.enableImagemagick imagick
        # Optionally enabled depending on caching settings
        ++ optional cfg.caching.apcu apcu
        ++ optional cfg.caching.redis redis
        ++ optional cfg.caching.memcached memcached
      )
      ++ cfg.phpExtraExtensions all; # Enabled by user
    extraConfig = toKeyValue phpOptions;
  };

  toKeyValue = generators.toKeyValue {
    mkKeyValue = generators.mkKeyValueDefault {} " = ";
  };

  phpOptions = {
    upload_max_filesize = cfg.maxUploadSize;
    post_max_size = cfg.maxUploadSize;
    memory_limit = cfg.maxUploadSize;
  } // cfg.phpOptions
    // optionalAttrs cfg.caching.apcu {
      "apc.enable_cli" = "1";
    };

  occ = pkgs.writeScriptBin "nextcloud-occ" ''
    #! ${pkgs.runtimeShell}
    cd ${cfg.package}
    sudo=exec
    if [[ "$USER" != nextcloud ]]; then
      sudo='exec /run/wrappers/bin/sudo -u nextcloud --preserve-env=NEXTCLOUD_CONFIG_DIR --preserve-env=OC_PASS'
    fi
    export NEXTCLOUD_CONFIG_DIR="${datadir}/config"
    $sudo \
      ${phpPackage}/bin/php \
      occ "$@"
  '';

  inherit (config.system) stateVersion;

in {

  imports = [
    (mkRemovedOptionModule [ "services" "nextcloud" "nginx" "enable" ] ''
      The nextcloud module supports `nginx` as reverse-proxy by default and doesn't
      support other reverse-proxies officially.

      However it's possible to use an alternative reverse-proxy by

        * disabling nginx
        * setting `listen.owner` & `listen.group` in the phpfpm-pool to a different value

      Further details about this can be found in the `Nextcloud`-section of the NixOS-manual
      (which can be openend e.g. by running `nixos-help`).
    '')
    (mkRemovedOptionModule [ "services" "nextcloud" "disableImagemagick" ] ''
      Use services.nextcloud.nginx.enableImagemagick instead.
    '')
  ];

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
    datadir = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Data storage path of nextcloud. Will be services.nextcloud.home by default. This folder will be populated with a config and data folder which contain the state of the instance (excl the database).";
      example = "/mnt/nextcloud-files";
    };
    extraApps = mkOption {
      type = types.attrsOf types.package;
      default = { };
      description = "Extra apps to install. Should point to packages that have appinfo/info.xml in their root.";
    };
    logLevel = mkOption {
      type = types.ints.between 0 4;
      default = 2;
      description = "Log level value between 0 (DEBUG) and 4 (FATAL).";
    };
    https = mkOption {
      type = types.bool;
      default = false;
      description = "Use https for generated links.";
    };
    package = mkOption {
      type = types.package;
      description = "Which package to use for the Nextcloud instance.";
      relatedPackages = [ "nextcloud20" "nextcloud21" "nextcloud22" ];
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

    webfinger = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable this option if you plan on using the webfinger plugin.
        The appropriate nginx rewrite rules will be added to your configuration.
      '';
    };

    phpExtraExtensions = mkOption {
      type = with types; functionTo (listOf package);
      default = all: [];
      defaultText = "all: []";
      description = ''
        Additional PHP extensions to use for nextcloud.
        By default, only extensions necessary for a vanilla nextcloud installation are enabled,
        but you may choose from the list of available extensions and add further ones.
        This is sometimes necessary to be able to install a certain nextcloud app that has additional requirements.
      '';
      example = literalExample ''
        all: [ all.pdlib all.bz2 ]
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
          The full path to a file that contains the admin's password. Must be
          readable by user <literal>nextcloud</literal>.
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

      trustedProxies = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Trusted proxies, to provide if the nextcloud installation is being
          proxied to secure against e.g. spoofing.
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

      defaultPhoneRegion = mkOption {
        default = null;
        type = types.nullOr types.str;
        example = "DE";
        description = ''
          <warning>
           <para>This option exists since Nextcloud 21! If older versions are used,
            this will throw an eval-error!</para>
          </warning>

          <link xlink:href="https://www.iso.org/iso-3166-country-codes.html">ISO 3611-1</link>
          country codes for automatic phone-number detection without a country code.

          With e.g. <literal>DE</literal> set, the <literal>+49</literal> can be omitted for
          phone-numbers.
        '';
      };
    };

    enableImagemagick = mkEnableOption ''
        Whether to load the ImageMagick module into PHP.
        This is used by the theming app and for generating previews of certain images (e.g. SVG and HEIF).
        You may want to disable it for increased security. In that case, previews will still be available
        for some images (e.g. JPEG and PNG).
        See https://github.com/nextcloud/server/issues/13099
    '' // {
      default = true;
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
    occ = mkOption {
      type = types.package;
      default = occ;
      internal = true;
      description = ''
        The nextcloud-occ program preconfigured to target this Nextcloud instance.
      '';
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
        { assertion = versionOlder cfg.package.version "21" -> cfg.config.defaultPhoneRegion == null;
          message = "The `defaultPhoneRegion'-setting is only supported for Nextcloud >=21!";
        }
      ];

      warnings = let
        latest = 22;
        upgradeWarning = major: nixos:
          ''
            A legacy Nextcloud install (from before NixOS ${nixos}) may be installed.

            After nextcloud${toString major} is installed successfully, you can safely upgrade
            to ${toString (major + 1)}. The latest version available is nextcloud${toString latest}.

            Please note that Nextcloud doesn't support upgrades across multiple major versions
            (i.e. an upgrade from 16 is possible to 17, but not 16 to 18).

            The package can be upgraded by explicitly declaring the service-option
            `services.nextcloud.package`.
          '';
      in (optional (cfg.poolConfig != null) ''
          Using config.services.nextcloud.poolConfig is deprecated and will become unsupported in a future release.
          Please migrate your configuration to config.services.nextcloud.poolSettings.
        '')
        ++ (optional (versionOlder cfg.package.version "20") (upgradeWarning 19 "21.05"))
        ++ (optional (versionOlder cfg.package.version "21") (upgradeWarning 20 "21.05"))
        ++ (optional (versionOlder cfg.package.version "22") (upgradeWarning 21 "21.11"));

      services.nextcloud.package = with pkgs;
        mkDefault (
          if pkgs ? nextcloud
            then throw ''
              The `pkgs.nextcloud`-attribute has been removed. If it's supposed to be the default
              nextcloud defined in an overlay, please set `services.nextcloud.package` to
              `pkgs.nextcloud`.
            ''
          # 21.03 will not be an official release - it was instead 21.05.
          # This versionOlder statement remains set to 21.03 for backwards compatibility.
          # See https://github.com/NixOS/nixpkgs/pull/108899 and
          # https://github.com/NixOS/rfcs/blob/master/rfcs/0080-nixos-release-schedule.md.
          else if versionOlder stateVersion "21.03" then nextcloud19
          else if versionOlder stateVersion "21.11" then nextcloud21
          else nextcloud22
        );
    }

    { systemd.timers.nextcloud-cron = {
        wantedBy = [ "timers.target" ];
        timerConfig.OnBootSec = "5m";
        timerConfig.OnUnitActiveSec = "15m";
        timerConfig.Unit = "nextcloud-cron.service";
      };

      systemd.services = {
        # When upgrading the Nextcloud package, Nextcloud can report errors such as
        # "The files of the app [all apps in /var/lib/nextcloud/apps] were not replaced correctly"
        # Restarting phpfpm on Nextcloud package update fixes these issues (but this is a workaround).
        phpfpm-nextcloud.restartTriggers = [ cfg.package ];

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
                    "Cannot start Nextcloud, dbpass file %s set by NixOS doesn't seem to "
                    . "exist! Please make sure that the file exists and has appropriate "
                    . "permissions for user & group 'nextcloud'!",
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
                ${optionalString (cfg.extraApps != { }) "[ 'path' => '${cfg.home}/nix-apps', 'url' => '/nix-apps', 'writable' => false ],"}
              ],
              'datadirectory' => '${datadir}/data',
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
              'trusted_proxies' => ${writePhpArrary (c.trustedProxies)},
              ${optionalString (c.defaultPhoneRegion != null) "'default_phone_region' => '${c.defaultPhoneRegion}',"}
            ];
          '';
          occInstallCmd = let
            dbpass = if c.dbpassFile != null
              then ''"$(<"${toString c.dbpassFile}")"''
              else if c.dbpass != null
              then ''"${toString c.dbpass}"''
              else ''""'';
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
              "--database-pass" = dbpass;
              ${if c.dbtableprefix != null
                then "--database-table-prefix" else null} = ''"${toString c.dbtableprefix}"'';
              "--admin-user" = ''"${c.adminuser}"'';
              "--admin-pass" = adminpass;
              "--data-dir" = ''"${datadir}/data"'';
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
          path = [ occ ];
          script = ''
            chmod og+x ${cfg.home}

            ${optionalString (c.dbpassFile != null) ''
              if [ ! -r "${c.dbpassFile}" ]; then
                echo "dbpassFile ${c.dbpassFile} is not readable by nextcloud:nextcloud! Aborting..."
                exit 1
              fi
              if [ -z "$(<${c.dbpassFile})" ]; then
                echo "dbpassFile ${c.dbpassFile} is empty!"
                exit 1
              fi
            ''}
            ${optionalString (c.adminpassFile != null) ''
              if [ ! -r "${c.adminpassFile}" ]; then
                echo "adminpassFile ${c.adminpassFile} is not readable by nextcloud:nextcloud! Aborting..."
                exit 1
              fi
              if [ -z "$(<${c.adminpassFile})" ]; then
                echo "adminpassFile ${c.adminpassFile} is empty!"
                exit 1
              fi
            ''}

            ln -sf ${cfg.package}/apps ${cfg.home}/
            rm -rf ${cfg.home}/nix-apps
            mkdir -p ${cfg.home}/nix-apps

            #Install extra apps
            '' +
            builtins.concatStringsSep "\n" (
              lib.mapAttrsToList
                (name: target:
                  "ln -sf   ${target} ${cfg.home}/nix-apps/${name}")
                cfg.extraApps) +
            ''

            # create nextcloud directories.
            # if the directories exist already with wrong permissions, we fix that
            for dir in ${datadir}/config ${datadir}/data ${cfg.home}/store-apps ${cfg.home}/nix-apps; do
              if [ ! -e $dir ]; then
                install -o nextcloud -g nextcloud -d $dir
              elif [ $(stat -c "%G" $dir) != "nextcloud" ]; then
                chgrp -R nextcloud $dir
              fi
            done

            ln -sf ${overrideConfig} ${datadir}/config/override.config.php

            # Do not install if already installed
            if [[ ! -e ${datadir}/config/config.php ]]; then
              ${occInstallCmd}
            fi

            ${occ}/bin/nextcloud-occ upgrade

            ${occ}/bin/nextcloud-occ config:system:delete trusted_domains
            ${occSetTrustedDomainsCmd}
          '';
          serviceConfig.Type = "oneshot";
          serviceConfig.User = "nextcloud";
        };
        nextcloud-cron = {
          environment.NEXTCLOUD_CONFIG_DIR = "${datadir}/config";
          serviceConfig.Type = "oneshot";
          serviceConfig.User = "nextcloud";
          serviceConfig.ExecStart = "${phpPackage}/bin/php -f ${cfg.package}/cron.php";
        };
        nextcloud-update-plugins = mkIf cfg.autoUpdateApps.enable {
          serviceConfig.Type = "oneshot";
          serviceConfig.ExecStart = "${occ}/bin/nextcloud-occ app:update --all";
          serviceConfig.User = "nextcloud";
          startAt = cfg.autoUpdateApps.startAt;
        };
      };

      services.phpfpm = {
        pools.nextcloud = {
          user = "nextcloud";
          group = "nextcloud";
          phpPackage = phpPackage;
          phpEnv = {
            NEXTCLOUD_CONFIG_DIR = "${datadir}/config";
            PATH = "/run/wrappers/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:/usr/bin:/bin";
          };
          settings = mapAttrs (name: mkDefault) {
            "listen.owner" = config.services.nginx.user;
            "listen.group" = config.services.nginx.group;
          } // cfg.poolSettings;
          extraConfig = cfg.poolConfig;
        };
      };

      users.users.nextcloud = {
        home = "${cfg.home}";
        group = "nextcloud";
        createHome = true;
        isSystemUser = true;
      };
      users.groups.nextcloud.members = [ "nextcloud" config.services.nginx.user ];

      environment.systemPackages = [ occ ];

      services.nginx.enable = mkDefault true;

      services.nginx.virtualHosts.${cfg.hostName} = {
        root = cfg.package;
        locations = {
          "= /robots.txt" = {
            priority = 100;
            extraConfig = ''
              allow all;
              log_not_found off;
              access_log off;
            '';
          };
          "= /" = {
            priority = 100;
            extraConfig = ''
              if ( $http_user_agent ~ ^DavClnt ) {
                return 302 /remote.php/webdav/$is_args$args;
              }
            '';
          };
          "/" = {
            priority = 900;
            extraConfig = "rewrite ^ /index.php;";
          };
          "~ ^/store-apps" = {
            priority = 201;
            extraConfig = "root ${cfg.home};";
          };
          "~ ^/nix-apps" = {
            priority = 201;
            extraConfig = "root ${cfg.home};";
          };
          "^~ /.well-known" = {
            priority = 210;
            extraConfig = ''
              absolute_redirect off;
              location = /.well-known/carddav {
                return 301 /remote.php/dav;
              }
              location = /.well-known/caldav {
                return 301 /remote.php/dav;
              }
              location ~ ^/\.well-known/(?!acme-challenge|pki-validation) {
                return 301 /index.php$request_uri;
              }
              try_files $uri $uri/ =404;
            '';
          };
          "~ ^/(?:build|tests|config|lib|3rdparty|templates|data)(?:$|/)".extraConfig = ''
            return 404;
          '';
          "~ ^/(?:\\.(?!well-known)|autotest|occ|issue|indie|db_|console)".extraConfig = ''
            return 404;
          '';
          "~ ^\\/(?:index|remote|public|cron|core\\/ajax\\/update|status|ocs\\/v[12]|updater\\/.+|oc[ms]-provider\\/.+|.+\\/richdocumentscode\\/proxy)\\.php(?:$|\\/)" = {
            priority = 500;
            extraConfig = ''
              include ${config.services.nginx.package}/conf/fastcgi.conf;
              fastcgi_split_path_info ^(.+?\.php)(\\/.*)$;
              set $path_info $fastcgi_path_info;
              try_files $fastcgi_script_name =404;
              fastcgi_param PATH_INFO $path_info;
              fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
              fastcgi_param HTTPS ${if cfg.https then "on" else "off"};
              fastcgi_param modHeadersAvailable true;
              fastcgi_param front_controller_active true;
              fastcgi_pass unix:${fpm.socket};
              fastcgi_intercept_errors on;
              fastcgi_request_buffering off;
              fastcgi_read_timeout 120s;
            '';
          };
          "~ \\.(?:css|js|woff2?|svg|gif|map)$".extraConfig = ''
            try_files $uri /index.php$request_uri;
            expires 6M;
            access_log off;
          '';
          "~ ^\\/(?:updater|ocs-provider|ocm-provider)(?:$|\\/)".extraConfig = ''
            try_files $uri/ =404;
            index index.php;
          '';
          "~ \\.(?:png|html|ttf|ico|jpg|jpeg|bcmap|mp4|webm)$".extraConfig = ''
            try_files $uri /index.php$request_uri;
            access_log off;
          '';
        };
        extraConfig = ''
          index index.php index.html /index.php$request_uri;
          expires 1m;
          add_header X-Content-Type-Options nosniff;
          add_header X-XSS-Protection "1; mode=block";
          add_header X-Robots-Tag none;
          add_header X-Download-Options noopen;
          add_header X-Permitted-Cross-Domain-Policies none;
          add_header X-Frame-Options sameorigin;
          add_header Referrer-Policy no-referrer;
          add_header Strict-Transport-Security "max-age=15552000; includeSubDomains" always;
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
    }
  ]);

  meta.doc = ./nextcloud.xml;
}
