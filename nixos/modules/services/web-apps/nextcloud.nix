{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nextcloud;
  fpm = config.services.phpfpm.pools.nextcloud;

  jsonFormat = pkgs.formats.json {};

  defaultPHPSettings = {
    output_buffering = "0";
    short_open_tag = "Off";
    expose_php = "Off";
    error_reporting = "E_ALL & ~E_DEPRECATED & ~E_STRICT";
    display_errors = "stderr";
    "opcache.interned_strings_buffer" = "8";
    "opcache.max_accelerated_files" = "10000";
    "opcache.memory_consumption" = "128";
    "opcache.revalidate_freq" = "1";
    "opcache.fast_shutdown" = "1";
    "openssl.cafile" = "/etc/ssl/certs/ca-certificates.crt";
    catch_workers_output = "yes";
  };

  appStores = {
    # default apps bundled with pkgs.nextcloudXX, e.g. files, contacts
    apps = {
      enabled = true;
      writable = false;
    };
    # apps installed via cfg.extraApps
    nix-apps = {
      enabled = cfg.extraApps != { };
      linkTarget = pkgs.linkFarm "nix-apps"
        (mapAttrsToList (name: path: { inherit name path; }) cfg.extraApps);
      writable = false;
    };
    # apps installed via the app store.
    store-apps = {
      enabled = cfg.appstoreEnable == null || cfg.appstoreEnable;
      linkTarget = "${cfg.home}/store-apps";
      writable = true;
    };
  };

  webroot = pkgs.runCommand "${cfg.package.name or "nextcloud"}-with-apps" {
    preferLocalBuild = true;
  } ''
      mkdir $out
      ln -sfv "${cfg.package}"/* "$out"
      ${concatStrings
        (mapAttrsToList (name: store: optionalString (store.enabled && store?linkTarget) ''
          if [ -e "$out"/${name} ]; then
            echo "Didn't expect ${name} already in $out!"
            exit 1
          fi
          ln -sfTv ${store.linkTarget} "$out"/${name}
        '') appStores)}
    '';

  inherit (cfg) datadir;

  phpPackage = cfg.phpPackage.buildEnv {
    extensions = { enabled, all }:
      (with all; enabled
        ++ [ bz2 intl sodium ] # recommended
        ++ optional cfg.enableImagemagick imagick
        # Optionally enabled depending on caching settings
        ++ optional cfg.caching.apcu apcu
        ++ optional cfg.caching.redis redis
        ++ optional cfg.caching.memcached memcached
      )
      ++ cfg.phpExtraExtensions all; # Enabled by user
    extraConfig = toKeyValue cfg.phpOptions;
  };

  toKeyValue = generators.toKeyValue {
    mkKeyValue = generators.mkKeyValueDefault {} " = ";
  };

  phpCli = concatStringsSep " " ([
    "${getExe phpPackage}"
  ] ++ optionals (cfg.cli.memoryLimit != null) [
    "-dmemory_limit=${cfg.cli.memoryLimit}"
  ]);

  occ = pkgs.writeScriptBin "nextcloud-occ" ''
    #! ${pkgs.runtimeShell}
    cd ${webroot}
    sudo=exec
    if [[ "$USER" != nextcloud ]]; then
      sudo='exec /run/wrappers/bin/sudo -u nextcloud'
    fi
    $sudo ${pkgs.coreutils}/bin/env \
      NEXTCLOUD_CONFIG_DIR="${datadir}/config" \
      ${phpCli} \
      occ "$@"
  '';

  inherit (config.system) stateVersion;

  mysqlLocal = cfg.database.createLocally && cfg.config.dbtype == "mysql";
  pgsqlLocal = cfg.database.createLocally && cfg.config.dbtype == "pgsql";

  nextcloudGreaterOrEqualThan = versionAtLeast cfg.package.version;
  nextcloudOlderThan = versionOlder cfg.package.version;

  # https://github.com/nextcloud/documentation/pull/11179
  ocmProviderIsNotAStaticDirAnymore = nextcloudGreaterOrEqualThan "27.1.2"
    || (nextcloudOlderThan "27.0.0" && nextcloudGreaterOrEqualThan "26.0.8");

  overrideConfig = let
    c = cfg.config;
    requiresReadSecretFunction = c.dbpassFile != null || c.objectstore.s3.enable;
    objectstoreConfig = let s3 = c.objectstore.s3; in optionalString s3.enable ''
      'objectstore' => [
        'class' => '\\OC\\Files\\ObjectStore\\S3',
        'arguments' => [
          'bucket' => '${s3.bucket}',
          'autocreate' => ${boolToString s3.autocreate},
          'key' => '${s3.key}',
          'secret' => nix_read_secret('${s3.secretFile}'),
          ${optionalString (s3.hostname != null) "'hostname' => '${s3.hostname}',"}
          ${optionalString (s3.port != null) "'port' => ${toString s3.port},"}
          'use_ssl' => ${boolToString s3.useSsl},
          ${optionalString (s3.region != null) "'region' => '${s3.region}',"}
          'use_path_style' => ${boolToString s3.usePathStyle},
          ${optionalString (s3.sseCKeyFile != null) "'sse_c_key' => nix_read_secret('${s3.sseCKeyFile}'),"}
        ],
      ]
    '';
    showAppStoreSetting = cfg.appstoreEnable != null || cfg.extraApps != {};
    renderedAppStoreSetting =
      let
        x = cfg.appstoreEnable;
      in
        if x == null then "false"
        else boolToString x;
    mkAppStoreConfig = name: { enabled, writable, ... }: optionalString enabled ''
      [ 'path' => '${webroot}/${name}', 'url' => '/${name}', 'writable' => ${boolToString writable} ],
    '';
  in pkgs.writeText "nextcloud-config.php" ''
    <?php
    ${optionalString requiresReadSecretFunction ''
      function nix_read_secret($file) {
        if (!file_exists($file)) {
          throw new \RuntimeException(sprintf(
            "Cannot start Nextcloud, secret file %s set by NixOS doesn't seem to "
            . "exist! Please make sure that the file exists and has appropriate "
            . "permissions for user & group 'nextcloud'!",
            $file
          ));
        }
        return trim(file_get_contents($file));
      }''}
    function nix_decode_json_file($file, $error) {
      if (!file_exists($file)) {
        throw new \RuntimeException(sprintf($error, $file));
      }
      $decoded = json_decode(file_get_contents($file), true);

      if (json_last_error() !== JSON_ERROR_NONE) {
        throw new \RuntimeException(sprintf("Cannot decode %s, because: %s", $file, json_last_error_msg()));
      }

      return $decoded;
    }
    $CONFIG = [
      'apps_paths' => [
        ${concatStrings (mapAttrsToList mkAppStoreConfig appStores)}
      ],
      ${optionalString (showAppStoreSetting) "'appstoreenabled' => ${renderedAppStoreSetting},"}
      ${optionalString cfg.caching.apcu "'memcache.local' => '\\OC\\Memcache\\APCu',"}
      ${optionalString (c.dbname != null) "'dbname' => '${c.dbname}',"}
      ${optionalString (c.dbhost != null) "'dbhost' => '${c.dbhost}',"}
      ${optionalString (c.dbuser != null) "'dbuser' => '${c.dbuser}',"}
      ${optionalString (c.dbtableprefix != null) "'dbtableprefix' => '${toString c.dbtableprefix}',"}
      ${optionalString (c.dbpassFile != null) ''
          'dbpassword' => nix_read_secret(
            "${c.dbpassFile}"
          ),
        ''
      }
      'dbtype' => '${c.dbtype}',
      ${objectstoreConfig}
    ];

    $CONFIG = array_replace_recursive($CONFIG, nix_decode_json_file(
      "${jsonFormat.generate "nextcloud-settings.json" cfg.settings}",
      "impossible: this should never happen (decoding generated settings file %s failed)"
    ));

    ${optionalString (cfg.secretFile != null) ''
      $CONFIG = array_replace_recursive($CONFIG, nix_decode_json_file(
        "${cfg.secretFile}",
        "Cannot start Nextcloud, secrets file %s set by NixOS doesn't exist!"
      ));
    ''}
  '';
in {

  imports = [
    (mkRenamedOptionModule
      [ "services" "nextcloud" "cron" "memoryLimit" ]
      [ "services" "nextcloud" "cli" "memoryLimit" ])
    (mkRemovedOptionModule [ "services" "nextcloud" "enableBrokenCiphersForSSE" ] ''
      This option has no effect since there's no supported Nextcloud version packaged here
      using OpenSSL for RC4 SSE.
    '')
    (mkRemovedOptionModule [ "services" "nextcloud" "config" "dbport" ] ''
      Add port to services.nextcloud.config.dbhost instead.
    '')
    (mkRenamedOptionModule
      [ "services" "nextcloud" "logLevel" ] [ "services" "nextcloud" "settings" "loglevel" ])
    (mkRenamedOptionModule
      [ "services" "nextcloud" "logType" ] [ "services" "nextcloud" "settings" "log_type" ])
    (mkRenamedOptionModule
      [ "services" "nextcloud" "config" "defaultPhoneRegion" ] [ "services" "nextcloud" "settings" "default_phone_region" ])
    (mkRenamedOptionModule
      [ "services" "nextcloud" "config" "overwriteProtocol" ] [ "services" "nextcloud" "settings" "overwriteprotocol" ])
    (mkRenamedOptionModule
      [ "services" "nextcloud" "skeletonDirectory" ] [ "services" "nextcloud" "settings" "skeletondirectory" ])
    (mkRenamedOptionModule
      [ "services" "nextcloud" "globalProfiles" ] [ "services" "nextcloud" "settings" "profile.enabled" ])
    (mkRenamedOptionModule
      [ "services" "nextcloud" "config" "extraTrustedDomains" ] [ "services" "nextcloud" "settings" "trusted_domains" ])
    (mkRenamedOptionModule
      [ "services" "nextcloud" "config" "trustedProxies" ] [ "services" "nextcloud" "settings" "trusted_proxies" ])
    (mkRenamedOptionModule ["services" "nextcloud" "extraOptions" ] [ "services" "nextcloud" "settings" ])
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
      type = types.str;
      default = config.services.nextcloud.home;
      defaultText = literalExpression "config.services.nextcloud.home";
      description = ''
        Nextcloud's data storage path.  Will be [](#opt-services.nextcloud.home) by default.
        This folder will be populated with a config.php file and a data folder which contains the state of the instance (excluding the database).";
      '';
      example = "/mnt/nextcloud-file";
    };
    extraApps = mkOption {
      type = types.attrsOf types.package;
      default = { };
      description = ''
        Extra apps to install. Should be an attrSet of appid to packages generated by fetchNextcloudApp.
        The appid must be identical to the "id" value in the apps appinfo/info.xml.
        Using this will disable the appstore to prevent Nextcloud from updating these apps (see [](#opt-services.nextcloud.appstoreEnable)).
      '';
      example = literalExpression ''
        {
          inherit (pkgs.nextcloud25Packages.apps) mail calendar contact;
          phonetrack = pkgs.fetchNextcloudApp {
            name = "phonetrack";
            sha256 = "0qf366vbahyl27p9mshfma1as4nvql6w75zy2zk5xwwbp343vsbc";
            url = "https://gitlab.com/eneiluj/phonetrack-oc/-/wikis/uploads/931aaaf8dca24bf31a7e169a83c17235/phonetrack-0.6.9.tar.gz";
            version = "0.6.9";
          };
        }
        '';
    };
    extraAppsEnable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Automatically enable the apps in [](#opt-services.nextcloud.extraApps) every time Nextcloud starts.
        If set to false, apps need to be enabled in the Nextcloud web user interface or with `nextcloud-occ app:enable`.
      '';
    };
    appstoreEnable = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = true;
      description = ''
        Allow the installation and updating of apps from the Nextcloud appstore.
        Enabled by default unless there are packages in [](#opt-services.nextcloud.extraApps).
        Set this to true to force enable the store even if [](#opt-services.nextcloud.extraApps) is used.
        Set this to false to disable the installation of apps from the global appstore. App management is always enabled regardless of this setting.
      '';
    };
    https = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Use HTTPS for generated links.

        Be aware that this also enables HTTP Strict Transport Security (HSTS) headers.
      '';
    };
    package = mkOption {
      type = types.package;
      description = "Which package to use for the Nextcloud instance.";
      relatedPackages = [ "nextcloud29" "nextcloud30" ];
    };
    phpPackage = mkPackageOption pkgs "php" {
      example = "php82";
    };

    finalPackage = mkOption {
      type = types.package;
      readOnly = true;
      description = ''
        Package to the finalized Nextcloud package, including all installed apps.
        This is automatically set by the module.
      '';
    };

    maxUploadSize = mkOption {
      default = "512M";
      type = types.str;
      description = ''
        The upload limit for files. This changes the relevant options
        in php.ini and nginx if enabled.
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
      defaultText = literalExpression "all: []";
      description = ''
        Additional PHP extensions to use for Nextcloud.
        By default, only extensions necessary for a vanilla Nextcloud installation are enabled,
        but you may choose from the list of available extensions and add further ones.
        This is sometimes necessary to be able to install a certain Nextcloud app that has additional requirements.
      '';
      example = literalExpression ''
        all: [ all.pdlib all.bz2 ]
      '';
    };

    phpOptions = mkOption {
      type = with types; attrsOf (oneOf [ str int ]);
      defaultText = literalExpression (generators.toPretty { } defaultPHPSettings);
      description = ''
        Options for PHP's php.ini file for nextcloud.

        Please note that this option is _additive_ on purpose while the
        attribute values inside the default are option defaults: that means that

        ```nix
        {
          services.nextcloud.phpOptions."opcache.interned_strings_buffer" = "23";
        }
        ```

        will override the `php.ini` option `opcache.interned_strings_buffer` without
        discarding the rest of the defaults.

        Overriding all of `phpOptions` (including `upload_max_filesize`, `post_max_size`
        and `memory_limit` which all point to [](#opt-services.nextcloud.maxUploadSize)
        by default) can be done like this:

        ```nix
        {
          services.nextcloud.phpOptions = lib.mkForce {
            /* ... */
          };
        }
        ```
      '';
    };

    poolSettings = mkOption {
      type = with types; attrsOf (oneOf [ str int bool ]);
      default = {
        "pm" = "dynamic";
        "pm.max_children" = "120";
        "pm.start_servers" = "12";
        "pm.min_spare_servers" = "6";
        "pm.max_spare_servers" = "18";
        "pm.max_requests" = "500";
      };
      description = ''
        Options for nextcloud's PHP pool. See the documentation on `php-fpm.conf` for details on
        configuration directives. The above are recommended for a server with 4GiB of RAM.

        It's advisable to read the [section about PHPFPM tuning in the upstream manual](https://docs.nextcloud.com/server/30/admin_manual/installation/server_tuning.html#tune-php-fpm)
        and consider customizing the values.
      '';
    };

    poolConfig = mkOption {
      type = types.nullOr types.lines;
      default = null;
      description = ''
        Options for Nextcloud's PHP pool. See the documentation on `php-fpm.conf` for details on configuration directives.
      '';
    };

    fastcgiTimeout = mkOption {
      type = types.int;
      default = 120;
      description = ''
        FastCGI timeout for database connection in seconds.
      '';
    };

    database = {

      createLocally = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to create the database and database user locally.
        '';
      };

    };

    config = {
      dbtype = mkOption {
        type = types.enum [ "sqlite" "pgsql" "mysql" ];
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
      dbpassFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          The full path to a file that contains the database password.
        '';
      };
      dbhost = mkOption {
        type = types.nullOr types.str;
        default =
          if pgsqlLocal then "/run/postgresql"
          else if mysqlLocal then "localhost:/run/mysqld/mysqld.sock"
          else "localhost";
        defaultText = "localhost";
        example = "localhost:5000";
        description = ''
          Database host (+port) or socket path.
          If [](#opt-services.nextcloud.database.createLocally) is true and
          [](#opt-services.nextcloud.config.dbtype) is either `pgsql` or `mysql`,
          defaults to the correct Unix socket instead.
        '';
      };
      dbtableprefix = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Table prefix in Nextcloud's database.

          __Note:__ since Nextcloud 20 it's not an option anymore to create a database
          schema with a custom table prefix. This option only exists for backwards compatibility
          with installations that were originally provisioned with Nextcloud <20.
        '';
      };
      adminuser = mkOption {
        type = types.str;
        default = "root";
        description = ''
          Username for the admin account. The username is only set during the
          initial setup of Nextcloud! Since the username also acts as unique
          ID internally, it cannot be changed later!
        '';
      };
      adminpassFile = mkOption {
        type = types.str;
        description = ''
          The full path to a file that contains the admin's password. Must be
          readable by user `nextcloud`. The password is set only in the initial
          setup of Nextcloud by the systemd service `nextcloud-setup.service`.
        '';
      };
      objectstore = {
        s3 = {
          enable = mkEnableOption ''
            S3 object storage as primary storage.

            This mounts a bucket on an Amazon S3 object storage or compatible
            implementation into the virtual filesystem.

            Further details about this feature can be found in the
            [upstream documentation](https://docs.nextcloud.com/server/22/admin_manual/configuration_files/primary_storage.html)
          '';
          bucket = mkOption {
            type = types.str;
            example = "nextcloud";
            description = ''
              The name of the S3 bucket.
            '';
          };
          autocreate = mkOption {
            type = types.bool;
            description = ''
              Create the objectstore if it does not exist.
            '';
          };
          key = mkOption {
            type = types.str;
            example = "EJ39ITYZEUH5BGWDRUFY";
            description = ''
              The access key for the S3 bucket.
            '';
          };
          secretFile = mkOption {
            type = types.str;
            example = "/var/nextcloud-objectstore-s3-secret";
            description = ''
              The full path to a file that contains the access secret. Must be
              readable by user `nextcloud`.
            '';
          };
          hostname = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "example.com";
            description = ''
              Required for some non-Amazon implementations.
            '';
          };
          port = mkOption {
            type = types.nullOr types.port;
            default = null;
            description = ''
              Required for some non-Amazon implementations.
            '';
          };
          useSsl = mkOption {
            type = types.bool;
            default = true;
            description = ''
              Use SSL for objectstore access.
            '';
          };
          region = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "REGION";
            description = ''
              Required for some non-Amazon implementations.
            '';
          };
          usePathStyle = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Required for some non-Amazon S3 implementations.

              Ordinarily, requests will be made with
              `http://bucket.hostname.domain/`, but with path style
              enabled requests are made with
              `http://hostname.domain/bucket` instead.
            '';
          };
          sseCKeyFile = mkOption {
            type = types.nullOr types.path;
            default = null;
            example = "/var/nextcloud-objectstore-s3-sse-c-key";
            description = ''
              If provided this is the full path to a file that contains the key
              to enable [server-side encryption with customer-provided keys][1]
              (SSE-C).

              The file must contain a random 32-byte key encoded as a base64
              string, e.g. generated with the command

              ```
              openssl rand 32 | base64
              ```

              Must be readable by user `nextcloud`.

              [1]: https://docs.aws.amazon.com/AmazonS3/latest/userguide/ServerSideEncryptionCustomerKeys.html
            '';
          };
        };
      };
    };

    enableImagemagick = mkEnableOption ''
        the ImageMagick module for PHP.
        This is used by the theming app and for generating previews of certain images (e.g. SVG and HEIF).
        You may want to disable it for increased security. In that case, previews will still be available
        for some images (e.g. JPEG and PNG).
        See <https://github.com/nextcloud/server/issues/13099>
    '' // {
      default = true;
    };

    configureRedis = lib.mkOption {
      type = lib.types.bool;
      default = config.services.nextcloud.notify_push.enable;
      defaultText = literalExpression "config.services.nextcloud.notify_push.enable";
      description = ''
        Whether to configure Nextcloud to use the recommended Redis settings for small instances.

        ::: {.note}
        The `notify_push` app requires Redis to be configured. If this option is turned off, this must be configured manually.
        :::
      '';
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
          See <https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/caching_configuration.html>
        '';
      };
      memcached = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to load the Memcached module into PHP.
          You still need to enable Memcached in your config.php.
          See <https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/caching_configuration.html>
        '';
      };
    };
    autoUpdateApps = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Run a regular auto-update of all apps installed from the Nextcloud app store.
        '';
      };
      startAt = mkOption {
        type = with types; either str (listOf str);
        default = "05:00:00";
        example = "Sun 14:00:00";
        description = ''
          When to run the update. See `systemd.services.<name>.startAt`.
        '';
      };
    };
    occ = mkOption {
      type = types.package;
      default = occ;
      defaultText = literalMD "generated script";
      description = ''
        The nextcloud-occ program preconfigured to target this Nextcloud instance.
      '';
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = jsonFormat.type;
        options = {

          loglevel = mkOption {
            type = types.ints.between 0 4;
            default = 2;
            description = ''
              Log level value between 0 (DEBUG) and 4 (FATAL).

              - 0 (debug): Log all activity.

              - 1 (info): Log activity such as user logins and file activities, plus warnings, errors, and fatal errors.

              - 2 (warn): Log successful operations, as well as warnings of potential problems, errors and fatal errors.

              - 3 (error): Log failed operations and fatal errors.

              - 4 (fatal): Log only fatal errors that cause the server to stop.
            '';
          };
          log_type = mkOption {
            type = types.enum [ "errorlog" "file" "syslog" "systemd" ];
            default = "syslog";
            description = ''
              Logging backend to use.
              systemd requires the php-systemd package to be added to services.nextcloud.phpExtraExtensions.
              See the [nextcloud documentation](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/logging_configuration.html) for details.
            '';
          };
          skeletondirectory = mkOption {
            default = "";
            type = types.str;
            description = ''
              The directory where the skeleton files are located. These files will be
              copied to the data directory of new users. Leave empty to not copy any
              skeleton files.
            '';
          };
          trusted_domains = mkOption {
            type = types.listOf types.str;
            default = [];
            description = ''
              Trusted domains, from which the nextcloud installation will be
              accessible. You don't need to add
              `services.nextcloud.hostname` here.
            '';
          };
          trusted_proxies = mkOption {
            type = types.listOf types.str;
            default = [];
            description = ''
              Trusted proxies, to provide if the nextcloud installation is being
              proxied to secure against e.g. spoofing.
            '';
          };
          overwriteprotocol = mkOption {
            type = types.enum [ "" "http" "https" ];
            default = "";
            example = "https";
            description = ''
              Force Nextcloud to always use HTTP or HTTPS i.e. for link generation.
              Nextcloud uses the currently used protocol by default, but when
              behind a reverse-proxy, it may use `http` for everything although
              Nextcloud may be served via HTTPS.
            '';
          };
          default_phone_region = mkOption {
            default = "";
            type = types.str;
            example = "DE";
            description = ''
              An [ISO 3166-1](https://www.iso.org/iso-3166-country-codes.html)
              country code which replaces automatic phone-number detection
              without a country code.

              As an example, with `DE` set as the default phone region,
              the `+49` prefix can be omitted for phone numbers.
            '';
          };
          "profile.enabled" = mkEnableOption "global profiles" // {
            description = ''
              Makes user-profiles globally available under `nextcloud.tld/u/user.name`.
              Even though it's enabled by default in Nextcloud, it must be explicitly enabled
              here because it has the side-effect that personal information is even accessible to
              unauthenticated users by default.
              By default, the following properties are set to “Show to everyone”
              if this flag is enabled:
              - About
              - Full name
              - Headline
              - Organisation
              - Profile picture
              - Role
              - Twitter
              - Website
              Only has an effect in Nextcloud 23 and later.
            '';
          };
        };
      };
      default = {};
      description = ''
        Extra options which should be appended to Nextcloud's config.php file.
      '';
      example = literalExpression ''
        {
          redis = {
            host = "/run/redis/redis.sock";
            port = 0;
            dbindex = 0;
            password = "secret";
            timeout = 1.5;
          };
        }
      '';
    };

    secretFile = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Secret options which will be appended to Nextcloud's config.php file (written as JSON, in the same
        form as the [](#opt-services.nextcloud.settings) option), for example
        `{"redis":{"password":"secret"}}`.
      '';
    };

    webserver = lib.mkOption {
      type = lib.types.enum [
        "nginx"
        "caddy"
      ];
      default = "nginx";
      description = ''
        Type of virtualhost to use and setup.
      '';
    };

    nginx = {
      recommendedHttpHeaders = mkOption {
        type = types.bool;
        default = true;
        description = "Enable additional recommended HTTP response headers";
      };
      hstsMaxAge = mkOption {
        type = types.ints.positive;
        default = 15552000;
        description = ''
          Value for the `max-age` directive of the HTTP
          `Strict-Transport-Security` header.

          See section 6.1.1 of IETF RFC 6797 for detailed information on this
          directive and header.
        '';
      };
    };

    cli.memoryLimit = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "1G";
      description = ''
        The `memory_limit` of PHP is equal to [](#opt-services.nextcloud.maxUploadSize).
        The value can be customized for `nextcloud-cron.service` using this option.
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    { warnings = let
        latest = 30;
        upgradeWarning = major: nixos:
          ''
            A legacy Nextcloud install (from before NixOS ${nixos}) may be installed.

            After nextcloud${toString major} is installed successfully, you can safely upgrade
            to ${toString (major + 1)}. The latest version available is Nextcloud${toString latest}.

            Please note that Nextcloud doesn't support upgrades across multiple major versions
            (i.e. an upgrade from 16 is possible to 17, but not 16 to 18).

            The package can be upgraded by explicitly declaring the service-option
            `services.nextcloud.package`.
          '';

      in (optional (cfg.poolConfig != null) ''
          Using config.services.nextcloud.poolConfig is deprecated and will become unsupported in a future release.
          Please migrate your configuration to config.services.nextcloud.poolSettings.
        '')
        ++ (optional (cfg.config.dbtableprefix != null) ''
          Using `services.nextcloud.config.dbtableprefix` is deprecated. Fresh installations with this
          option set are not allowed anymore since v20.

          If you have an existing installation with a custom table prefix, make sure it is
          set correctly in `config.php` and remove the option from your NixOS config.
        '')
        ++ (optional (versionOlder cfg.package.version "26") (upgradeWarning 25 "23.05"))
        ++ (optional (versionOlder cfg.package.version "27") (upgradeWarning 26 "23.11"))
        ++ (optional (versionOlder cfg.package.version "28") (upgradeWarning 27 "24.05"))
        ++ (optional (versionOlder cfg.package.version "29") (upgradeWarning 28 "24.11"))
        ++ (optional (versionOlder cfg.package.version "30") (upgradeWarning 29 "24.11"));

      services.nextcloud.package = with pkgs;
        mkDefault (
          if pkgs ? nextcloud
            then throw ''
              The `pkgs.nextcloud`-attribute has been removed. If it's supposed to be the default
              nextcloud defined in an overlay, please set `services.nextcloud.package` to
              `pkgs.nextcloud`.
            ''
          else if versionOlder stateVersion "24.05" then nextcloud27
          else if versionOlder stateVersion "24.11" then nextcloud29
          else nextcloud30
        );

      services.nextcloud.phpPackage =
        if versionOlder cfg.package.version "29" then pkgs.php82
        else pkgs.php83;

      services.nextcloud.phpOptions = mkMerge [
        (mapAttrs (const mkOptionDefault) defaultPHPSettings)
        {
          upload_max_filesize = cfg.maxUploadSize;
          post_max_size = cfg.maxUploadSize;
          memory_limit = cfg.maxUploadSize;
        }
        (mkIf cfg.caching.apcu {
          "apc.enable_cli" = "1";
        })
      ];
    }

    { assertions = [
      { assertion = cfg.database.createLocally -> cfg.config.dbpassFile == null;
        message = ''
          Using `services.nextcloud.database.createLocally` with database
          password authentication is no longer supported.

          If you use an external database (or want to use password auth for any
          other reason), set `services.nextcloud.database.createLocally` to
          `false`. The database won't be managed for you (use `services.mysql`
          if you want to set it up).

          If you want this module to manage your nextcloud database for you,
          unset `services.nextcloud.config.dbpassFile` and
          `services.nextcloud.config.dbhost` to use socket authentication
          instead of password.
        '';
      }
    ]; }

    { systemd.timers.nextcloud-cron = {
        wantedBy = [ "timers.target" ];
        after = [ "nextcloud-setup.service" ];
        timerConfig = {
          OnBootSec = "5m";
          OnUnitActiveSec = "5m";
          Unit = "nextcloud-cron.service";
        };
      };

      systemd.tmpfiles.rules = map (dir: "d ${dir} 0750 nextcloud nextcloud - -") [
        "${cfg.home}"
        "${datadir}/config"
        "${datadir}/data"
        "${cfg.home}/store-apps"
      ] ++ [
        "L+ ${datadir}/config/override.config.php - - - - ${overrideConfig}"
      ];

      services.nextcloud.finalPackage = webroot;

      systemd.services = {
        # When upgrading the Nextcloud package, Nextcloud can report errors such as
        # "The files of the app [all apps in /var/lib/nextcloud/apps] were not replaced correctly"
        # Restarting phpfpm on Nextcloud package update fixes these issues (but this is a workaround).
        phpfpm-nextcloud.restartTriggers = [ webroot overrideConfig ];

        nextcloud-setup = let
          c = cfg.config;
          occInstallCmd = let
            mkExport = { arg, value }: ''
              ${arg}=${value};
              export ${arg};
            '';
            dbpass = {
              arg = "DBPASS";
              value = if c.dbpassFile != null
                then ''"$(<"${toString c.dbpassFile}")"''
                else ''""'';
            };
            adminpass = {
              arg = "ADMINPASS";
              value = ''"$(<"${toString c.adminpassFile}")"'';
            };
            installFlags = concatStringsSep " \\\n    "
              (mapAttrsToList (k: v: "${k} ${toString v}") {
              "--database" = ''"${c.dbtype}"'';
              # The following attributes are optional depending on the type of
              # database.  Those that evaluate to null on the left hand side
              # will be omitted.
              ${if c.dbname != null then "--database-name" else null} = ''"${c.dbname}"'';
              ${if c.dbhost != null then "--database-host" else null} = ''"${c.dbhost}"'';
              ${if c.dbuser != null then "--database-user" else null} = ''"${c.dbuser}"'';
              "--database-pass" = "\"\$${dbpass.arg}\"";
              "--admin-user" = ''"${c.adminuser}"'';
              "--admin-pass" = "\"\$${adminpass.arg}\"";
              "--data-dir" = ''"${datadir}/data"'';
            });
          in ''
            ${mkExport dbpass}
            ${mkExport adminpass}
            ${occ}/bin/nextcloud-occ maintenance:install \
                ${installFlags}
          '';
          occSetTrustedDomainsCmd = concatStringsSep "\n" (imap0
            (i: v: ''
              ${occ}/bin/nextcloud-occ config:system:set trusted_domains \
                ${toString i} --value="${toString v}"
            '') ([ cfg.hostName ] ++ cfg.settings.trusted_domains));

        in {
          wantedBy = [ "multi-user.target" ];
          wants = [ "nextcloud-update-db.service" ];
          before = [ "phpfpm-nextcloud.service" ];
          after = optional mysqlLocal "mysql.service" ++ optional pgsqlLocal "postgresql.service";
          requires = optional mysqlLocal "mysql.service" ++ optional pgsqlLocal "postgresql.service";
          path = [ occ ];
          restartTriggers = [ overrideConfig ];
          script = ''
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
            if [ ! -r "${c.adminpassFile}" ]; then
              echo "adminpassFile ${c.adminpassFile} is not readable by nextcloud:nextcloud! Aborting..."
              exit 1
            fi
            if [ -z "$(<${c.adminpassFile})" ]; then
              echo "adminpassFile ${c.adminpassFile} is empty!"
              exit 1
            fi

            ${concatMapStrings (name: ''
              if [ -d "${cfg.home}"/${name} ]; then
                echo "Cleaning up ${name}; these are now bundled in the webroot store-path!"
                rm -r "${cfg.home}"/${name}
              fi
            '') [ "nix-apps" "apps" ]}

            # Do not install if already installed
            if [[ ! -e ${datadir}/config/config.php ]]; then
              ${occInstallCmd}
            fi

            ${occ}/bin/nextcloud-occ upgrade

            ${occ}/bin/nextcloud-occ config:system:delete trusted_domains

            ${optionalString (cfg.extraAppsEnable && cfg.extraApps != { }) ''
                # Try to enable apps
                ${occ}/bin/nextcloud-occ app:enable ${concatStringsSep " " (attrNames cfg.extraApps)}
            ''}

            ${occSetTrustedDomainsCmd}
          '';
          serviceConfig.Type = "oneshot";
          serviceConfig.User = "nextcloud";
          # On Nextcloud ≥ 26, it is not necessary to patch the database files to prevent
          # an automatic creation of the database user.
          environment.NC_setup_create_db_user = lib.mkIf (nextcloudGreaterOrEqualThan "26") "false";
        };
        nextcloud-cron = {
          after = [ "nextcloud-setup.service" ];
          environment.NEXTCLOUD_CONFIG_DIR = "${datadir}/config";
          serviceConfig = {
            Type = "exec";
            User = "nextcloud";
            ExecCondition = "${phpCli} -f ${webroot}/occ status -e";
            ExecStart = "${phpCli} -f ${webroot}/cron.php";
            KillMode = "process";
          };
        };
        nextcloud-update-plugins = mkIf cfg.autoUpdateApps.enable {
          after = [ "nextcloud-setup.service" ];
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${occ}/bin/nextcloud-occ app:update --all";
            User = "nextcloud";
          };
          startAt = cfg.autoUpdateApps.startAt;
        };
        nextcloud-update-db = {
          after = [ "nextcloud-setup.service" ];
          environment.NEXTCLOUD_CONFIG_DIR = "${datadir}/config";
          script = ''
            ${occ}/bin/nextcloud-occ db:add-missing-columns
            ${occ}/bin/nextcloud-occ db:add-missing-indices
            ${occ}/bin/nextcloud-occ db:add-missing-primary-keys
          '';
          serviceConfig = {
            Type = "exec";
            User = "nextcloud";
            ExecCondition = "${phpCli} -f ${webroot}/occ status -e";
          };
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
          settings =
            mapAttrs (name: mkDefault) {
              "listen.owner" = config.services."${cfg.webserver}".user;
              "listen.group" = config.services."${cfg.webserver}".group;
            }
            // cfg.poolSettings;
          extraConfig = cfg.poolConfig;
        };
      };

      users.users.nextcloud = {
        home = "${cfg.home}";
        group = "nextcloud";
        isSystemUser = true;
      };
      users.groups.nextcloud.members = [
        "nextcloud"
        config.services."${cfg.webserver}".user
      ];

      environment.systemPackages = [ occ ];

      services.mysql = lib.mkIf mysqlLocal {
        enable = true;
        package = lib.mkDefault pkgs.mariadb;
        ensureDatabases = [ cfg.config.dbname ];
        ensureUsers = [{
          name = cfg.config.dbuser;
          ensurePermissions = { "${cfg.config.dbname}.*" = "ALL PRIVILEGES"; };
        }];
      };

      services.postgresql = mkIf pgsqlLocal {
        enable = true;
        ensureDatabases = [ cfg.config.dbname ];
        ensureUsers = [{
          name = cfg.config.dbuser;
          ensureDBOwnership = true;
        }];
      };

      services.redis.servers.nextcloud = lib.mkIf cfg.configureRedis {
        enable = true;
        user = "nextcloud";
      };

      services.nextcloud = {
        caching.redis = lib.mkIf cfg.configureRedis true;
        settings = mkMerge [({
          datadirectory = lib.mkDefault "${datadir}/data";
          trusted_domains = [ cfg.hostName ];
        }) (lib.mkIf cfg.configureRedis {
          "memcache.distributed" = ''\OC\Memcache\Redis'';
          "memcache.locking" = ''\OC\Memcache\Redis'';
          redis = {
            host = config.services.redis.servers.nextcloud.unixSocket;
            port = 0;
          };
        })];
      };

      services.nginx = lib.mkIf (cfg.webserver == "nginx") {
        enable = lib.mkDefault true;
        virtualHosts.${cfg.hostName} = {
          root = webroot;
          locations = {
            "= /robots.txt" = {
              priority = 100;
              extraConfig = ''
                allow all;
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
            "^~ /.well-known" = {
              priority = 210;
              extraConfig = ''
                absolute_redirect off;
                location = /.well-known/carddav {
                  return 301 /remote.php/dav/;
                }
                location = /.well-known/caldav {
                  return 301 /remote.php/dav/;
                }
                location ~ ^/\.well-known/(?!acme-challenge|pki-validation) {
                  return 301 /index.php$request_uri;
                }
                try_files $uri $uri/ =404;
              '';
            };
            "~ ^/(?:build|tests|config|lib|3rdparty|templates|data)(?:$|/)" = {
              priority = 450;
              extraConfig = ''
                return 404;
              '';
            };
            "~ ^/(?:\\.|autotest|occ|issue|indie|db_|console)" = {
              priority = 450;
              extraConfig = ''
                return 404;
              '';
            };
            "~ \\.php(?:$|/)" = {
              priority = 500;
              extraConfig = ''
                # legacy support (i.e. static files and directories in cfg.package)
                rewrite ^/(?!index|remote|public|cron|core\/ajax\/update|status|ocs\/v[12]|updater\/.+|oc[s${
                  optionalString (!ocmProviderIsNotAStaticDirAnymore) "m"
                }]-provider\/.+|.+\/richdocumentscode\/proxy) /index.php$request_uri;
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
                fastcgi_read_timeout ${builtins.toString cfg.fastcgiTimeout}s;
              '';
            };
            "~ \\.(?:css|js|mjs|svg|gif|png|jpg|jpeg|ico|wasm|tflite|map|html|ttf|bcmap|mp4|webm|ogg|flac)$".extraConfig =
              ''
                try_files $uri /index.php$request_uri;
                expires 6M;
                access_log off;
                location ~ \.mjs$ {
                  default_type text/javascript;
                }
                location ~ \.wasm$ {
                  default_type application/wasm;
                }
              '';
            "~ ^\\/(?:updater|ocs-provider${
              optionalString (!ocmProviderIsNotAStaticDirAnymore) "|ocm-provider"
            })(?:$|\\/)".extraConfig =
              ''
                try_files $uri/ =404;
                index index.php;
              '';
            "/remote" = {
              priority = 1500;
              extraConfig = ''
                return 301 /remote.php$request_uri;
              '';
            };
            "/" = {
              priority = 1600;
              extraConfig = ''
                try_files $uri $uri/ /index.php$request_uri;
              '';
            };
          };
          extraConfig = ''
            index index.php index.html /index.php$request_uri;
            ${optionalString (cfg.nginx.recommendedHttpHeaders) ''
              add_header X-Content-Type-Options nosniff;
              add_header X-XSS-Protection "1; mode=block";
              add_header X-Robots-Tag "noindex, nofollow";
              add_header X-Download-Options noopen;
              add_header X-Permitted-Cross-Domain-Policies none;
              add_header X-Frame-Options sameorigin;
              add_header Referrer-Policy no-referrer;
            ''}
            ${optionalString (cfg.https) ''
              add_header Strict-Transport-Security "max-age=${toString cfg.nginx.hstsMaxAge}; includeSubDomains" always;
            ''}
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

      services.caddy = lib.mkIf (cfg.webserver == "caddy") {
        enable = mkDefault true;
        virtualHosts."${if cfg.https then "https" else "http"}://${cfg.hostName}" = {
          extraConfig = ''
            encode zstd gzip

            root * ${webroot}

            redir /.well-known/carddav /remote.php/dav 301
            redir /.well-known/caldav /remote.php/dav 301
            redir /.well-known/* /index.php{uri} 301
            redir /remote/* /remote.php{uri} 301

            header {
              Strict-Transport-Security max-age=31536000
              Permissions-Policy interest-cohort=()
              X-Content-Type-Options nosniff
              X-Frame-Options SAMEORIGIN
              Referrer-Policy no-referrer
              X-XSS-Protection "1; mode=block"
              X-Permitted-Cross-Domain-Policies none
              X-Robots-Tag "noindex, nofollow"
              -X-Powered-By
            }

            php_fastcgi unix/${fpm.socket} {
              root ${webroot}
              env front_controller_active true
              env modHeadersAvailable true
            }

            @forbidden {
              path /build/* /tests/* /config/* /lib/* /3rdparty/* /templates/* /data/*
              path /.* /autotest* /occ* /issue* /indie* /db_* /console*
              not path /.well-known/*
            }
            error @forbidden 404

            @immutable {
              path *.css *.js *.mjs *.svg *.gif *.png *.jpg *.ico *.wasm *.tflite
              query v=*
            }
            header @immutable Cache-Control "max-age=15778463, immutable"

            @static {
              path *.css *.js *.mjs *.svg *.gif *.png *.jpg *.ico *.wasm *.tflite
              not query v=*
            }
            header @static Cache-Control "max-age=15778463"

            @woff2 path *.woff2
            header @woff2 Cache-Control "max-age=604800"

            file_server
          '';
        };
      };
    }
  ]);

  meta.doc = ./nextcloud.md;
}
