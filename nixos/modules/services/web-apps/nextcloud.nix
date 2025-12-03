{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.nextcloud;

  overridePackage = cfg.package.override {
    inherit (config.security.pki) caBundle;
  };

  fpm = config.services.phpfpm.pools.nextcloud;

  jsonFormat = pkgs.formats.json { };

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
    "openssl.cafile" = config.security.pki.caBundle;
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
      linkTarget = pkgs.linkFarm "nix-apps" (
        lib.mapAttrsToList (name: path: { inherit name path; }) cfg.extraApps
      );
      writable = false;
    };
    # apps installed via the app store.
    store-apps = {
      enabled = cfg.appstoreEnable == null || cfg.appstoreEnable;
      linkTarget = "${cfg.home}/store-apps";
      writable = true;
    };
  };

  webroot =
    pkgs.runCommand "${overridePackage.name or "nextcloud"}-with-apps"
      {
        preferLocalBuild = true;
      }
      ''
        mkdir $out
        ln -sfv "${overridePackage}"/* "$out"
        ${lib.concatStrings (
          lib.mapAttrsToList (
            name: store:
            lib.optionalString (store.enabled && store ? linkTarget) ''
              if [ -e "$out"/${name} ]; then
                echo "Didn't expect ${name} already in $out!"
                exit 1
              fi
              ln -sfTv ${store.linkTarget} "$out"/${name}
            ''
          ) appStores
        )}
      '';

  inherit (cfg) datadir;

  phpPackage = cfg.phpPackage.buildEnv {
    extensions =
      { enabled, all }:
      (
        with all;
        enabled
        ++ [
          bz2
          intl
          sodium
        ] # recommended
        ++ lib.optional cfg.enableImagemagick imagick
        # Optionally enabled depending on caching settings
        ++ lib.optional cfg.caching.apcu apcu
        ++ lib.optional cfg.caching.redis redis
        ++ lib.optional cfg.caching.memcached memcached
        ++ lib.optional (cfg.settings.log_type == "systemd") systemd
      )
      ++ cfg.phpExtraExtensions all; # Enabled by user
    extraConfig = toKeyValue cfg.phpOptions;
  };

  toKeyValue = lib.generators.toKeyValue {
    mkKeyValue = lib.generators.mkKeyValueDefault { } " = ";
  };

  phpCli = lib.concatStringsSep " " (
    [
      "${lib.getExe phpPackage}"
    ]
    ++ lib.optionals (cfg.cli.memoryLimit != null) [
      "-dmemory_limit=${cfg.cli.memoryLimit}"
    ]
  );

  # NOTE: The credentials required by all services at runtime, not including things like the
  #       admin password which is only needed by the setup service.
  runtimeSystemdCredentials =
    [ ]
    ++ (lib.optional (cfg.config.dbpassFile != null) "dbpass:${cfg.config.dbpassFile}")
    ++ (lib.optional (cfg.config.objectstore.s3.enable) "s3_secret:${cfg.config.objectstore.s3.secretFile}")
    ++ (lib.optional (
      cfg.config.objectstore.s3.sseCKeyFile != null
    ) "s3_sse_c_key:${cfg.config.objectstore.s3.sseCKeyFile}")
    ++ (lib.optional (cfg.secretFile != null) "secret_file:${cfg.secretFile}")
    ++ (lib.mapAttrsToList (credential: file: "${credential}:${file}") cfg.secrets);

  requiresRuntimeSystemdCredentials = runtimeSystemdCredentials != [ ];

  occ = pkgs.writeShellApplication {
    name = "nextcloud-occ";

    text =
      let
        command = ''
          ${lib.getExe' pkgs.coreutils "env"} \
            NEXTCLOUD_CONFIG_DIR="${datadir}/config" \
            ${phpCli} \
            occ "$@"
        '';
      in
      ''
        cd ${webroot}

        # NOTE: This is templated at eval time
        requiresRuntimeSystemdCredentials=${lib.boolToString requiresRuntimeSystemdCredentials}

        # NOTE: This wrapper is both used in the internal nextcloud service units
        #       and by users outside a service context for administration. As such,
        #       when there's an existing CREDENTIALS_DIRECTORY, we inherit it for use
        #       in the nix_read_secret() php function.
        #       When there's no CREDENTIALS_DIRECTORY we try to use systemd-run to
        #       load the credentials just as in a service unit.
        # NOTE: If there are no credentials that are required at runtime then there's no need
        #       to load any credentials.
        if [[ $requiresRuntimeSystemdCredentials == true && -z "''${CREDENTIALS_DIRECTORY:-}" ]]; then
          exec ${lib.getExe' config.systemd.package "systemd-run"} \
            ${
              lib.escapeShellArgs (
                map (credential: "--property=LoadCredential=${credential}") runtimeSystemdCredentials
              )
            } \
            --uid=nextcloud \
            --same-dir \
            --pty \
            --wait \
            --collect \
            --service-type=exec \
            --setenv OC_PASS \
            --setenv NC_PASS \
            --quiet \
            -- \
            ${command}
        elif [[ "$USER" != nextcloud ]]; then
          if [[ -x /run/wrappers/bin/sudo ]]; then
            exec /run/wrappers/bin/sudo \
              --preserve-env=CREDENTIALS_DIRECTORY \
              --preserve-env=OC_PASS \
              --preserve-env=NC_PASS \
              --user=nextcloud \
              -- \
              ${command}
          else
            exec ${lib.getExe' pkgs.util-linux "runuser"} \
              --whitelist-environment=CREDENTIALS_DIRECTORY \
              --whitelist-environment=OC_PASS \
              --whitelist-environment=NC_PASS \
              --user=nextcloud \
              -- \
              ${command}
          fi
        else
          exec ${command}
        fi
      '';
  };

  inherit (config.system) stateVersion;

  mysqlLocal = cfg.database.createLocally && cfg.config.dbtype == "mysql";
  pgsqlLocal = cfg.database.createLocally && cfg.config.dbtype == "pgsql";

  overrideConfig =
    let
      c = cfg.config;
      objectstoreConfig =
        let
          s3 = c.objectstore.s3;
        in
        lib.optionalString s3.enable ''
          'objectstore' => [
            'class' => '\\OC\\Files\\ObjectStore\\S3',
            'arguments' => [
              'bucket' => '${s3.bucket}',
              'verify_bucket_exists' => ${lib.boolToString s3.verify_bucket_exists},
              'key' => '${s3.key}',
              'secret' => nix_read_secret('s3_secret'),
              ${lib.optionalString (s3.hostname != null) "'hostname' => '${s3.hostname}',"}
              ${lib.optionalString (s3.port != null) "'port' => ${toString s3.port},"}
              'use_ssl' => ${lib.boolToString s3.useSsl},
              ${lib.optionalString (s3.region != null) "'region' => '${s3.region}',"}
              'use_path_style' => ${lib.boolToString s3.usePathStyle},
              ${lib.optionalString (s3.sseCKeyFile != null) "'sse_c_key' => nix_read_secret('s3_sse_c_key'),"}
            ],
          ]
        '';
      showAppStoreSetting = cfg.appstoreEnable != null || cfg.extraApps != { };
      renderedAppStoreSetting =
        let
          x = cfg.appstoreEnable;
        in
        if x == null then "false" else lib.boolToString x;
      mkAppStoreConfig =
        name:
        { enabled, writable, ... }:
        lib.optionalString enabled ''
          [ 'path' => '${webroot}/${name}', 'url' => '/${name}', 'writable' => ${lib.boolToString writable} ],
        '';
    in
    pkgs.writeText "nextcloud-config.php" ''
      <?php
      ${lib.optionalString requiresRuntimeSystemdCredentials ''
        function nix_read_secret($credential_name) {
          $credentials_directory = getenv("CREDENTIALS_DIRECTORY");
          if (!$credentials_directory) {
            error_log(sprintf(
              "Cannot read credential '%s' passed by NixOS, \$CREDENTIALS_DIRECTORY is not set!",
              $credential_name
            ));
            exit(1);
          }

          $credential_path = $credentials_directory . "/" . $credential_name;
          if (!is_readable($credential_path)) {
            error_log(sprintf(
              "Cannot read credential '%s' passed by NixOS, it does not exist or is not readable!",
              $credential_path,
            ));
            exit(1);
          }

          return trim(file_get_contents($credential_path));
        }

        function nix_read_secret_and_decode_json_file($credential_name) {
          $decoded = json_decode(nix_read_secret($credential_name), true);

          if (json_last_error() !== JSON_ERROR_NONE) {
            error_log(sprintf("Cannot decode %s, because: %s", $file, json_last_error_msg()));
            exit(1);
          }

          return $decoded;
        }
      ''}
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
          ${lib.concatStrings (lib.mapAttrsToList mkAppStoreConfig appStores)}
        ],
        ${lib.optionalString showAppStoreSetting "'appstoreenabled' => ${renderedAppStoreSetting},"}
        ${lib.optionalString cfg.caching.apcu "'memcache.local' => '\\OC\\Memcache\\APCu',"}
        ${lib.optionalString (c.dbname != null) "'dbname' => '${c.dbname}',"}
        ${lib.optionalString (c.dbhost != null) "'dbhost' => '${c.dbhost}',"}
        ${lib.optionalString (c.dbuser != null) "'dbuser' => '${c.dbuser}',"}
        ${lib.optionalString (
          c.dbtableprefix != null
        ) "'dbtableprefix' => '${toString c.dbtableprefix}',"}
        ${lib.optionalString (c.dbpassFile != null) "'dbpassword' => nix_read_secret('dbpass'),"}
        'dbtype' => '${c.dbtype}',
        ${lib.concatStringsSep "\n" (
          lib.mapAttrsToList (name: credential: "'${name}' => nix_read_secret('${name}'),") cfg.secrets
        )}
        ${objectstoreConfig}
      ];

      $CONFIG = array_replace_recursive($CONFIG, nix_decode_json_file(
        "${jsonFormat.generate "nextcloud-settings.json" cfg.settings}",
        "impossible: this should never happen (decoding generated settings file %s failed)"
      ));

      ${lib.optionalString (cfg.secretFile != null) ''
        $CONFIG = array_replace_recursive($CONFIG, nix_read_secret_and_decode_json_file('secret_file'));
      ''}
    '';
in
{

  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "nextcloud" "cron" "memoryLimit" ]
      [ "services" "nextcloud" "cli" "memoryLimit" ]
    )
    (lib.mkRemovedOptionModule [ "services" "nextcloud" "enableBrokenCiphersForSSE" ] ''
      This option has no effect since there's no supported Nextcloud version packaged here
      using OpenSSL for RC4 SSE.
    '')
    (lib.mkRemovedOptionModule [ "services" "nextcloud" "config" "dbport" ] ''
      Add port to services.nextcloud.config.dbhost instead.
    '')
    (lib.mkRemovedOptionModule [ "services" "nextcloud" "nginx" "recommendedHttpHeaders" ] ''
      This option has been removed to always follow upstream's security recommendation.
    '')
    (lib.mkRenamedOptionModule
      [ "services" "nextcloud" "logLevel" ]
      [ "services" "nextcloud" "settings" "loglevel" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "nextcloud" "logType" ]
      [ "services" "nextcloud" "settings" "log_type" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "nextcloud" "config" "defaultPhoneRegion" ]
      [ "services" "nextcloud" "settings" "default_phone_region" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "nextcloud" "config" "overwriteProtocol" ]
      [ "services" "nextcloud" "settings" "overwriteprotocol" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "nextcloud" "skeletonDirectory" ]
      [ "services" "nextcloud" "settings" "skeletondirectory" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "nextcloud" "globalProfiles" ]
      [ "services" "nextcloud" "settings" "profile.enabled" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "nextcloud" "config" "extraTrustedDomains" ]
      [ "services" "nextcloud" "settings" "trusted_domains" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "nextcloud" "config" "trustedProxies" ]
      [ "services" "nextcloud" "settings" "trusted_proxies" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "nextcloud" "extraOptions" ]
      [ "services" "nextcloud" "settings" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "nextcloud" "config" "objectstore" "s3" "autocreate" ]
      [ "services" "nextcloud" "config" "objectstore" "s3" "verify_bucket_exists" ]
    )
  ];

  options.services.nextcloud = {
    enable = lib.mkEnableOption "nextcloud";

    hostName = lib.mkOption {
      type = lib.types.str;
      description = "FQDN for the nextcloud instance.";
    };
    home = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/nextcloud";
      description = "Storage path of nextcloud.";
    };
    datadir = lib.mkOption {
      type = lib.types.str;
      default = config.services.nextcloud.home;
      defaultText = lib.literalExpression "config.services.nextcloud.home";
      description = ''
        Nextcloud's data storage path.  Will be [](#opt-services.nextcloud.home) by default.
        This folder will be populated with a config.php file and a data folder which contains the state of the instance (excluding the database).";
      '';
      example = "/mnt/nextcloud-file";
    };
    secrets = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.pathWith {
          inStore = false;
          absolute = true;
        }
      );
      default = { };
      description = ''
        Secret files to read into entries in `config.php`.
        This uses `nix_read_secret` and LoadCredential to read the contents of the file into the entry in `config.php`.
      '';
      example = lib.literalExpression ''
        {
          oidc_login_client_secret = "/run/secrets/nextcloud_oidc_secret";
        }
      '';
    };
    extraApps = lib.mkOption {
      type = lib.types.attrsOf lib.types.package;
      default = { };
      description = ''
        Extra apps to install. Should be an attrSet of appid to packages generated by fetchNextcloudApp.
        The appid must be identical to the "id" value in the apps appinfo/info.xml.
        Using this will disable the appstore to prevent Nextcloud from updating these apps (see [](#opt-services.nextcloud.appstoreEnable)).
      '';
      example = lib.literalExpression ''
        {
          inherit (pkgs.nextcloud31Packages.apps) mail calendar contacts;
          phonetrack = pkgs.fetchNextcloudApp {
            appName = "phonetrack";
            appVersion = "0.8.2";
            license = "agpl3Plus";
            sha512 = "f67902d1b48def9a244383a39d7bec95bb4215054963a9751f99dae9bd2f2740c02d2ef97b3b76d69a36fa95f8a9374dd049440b195f4dad2f0c4bca645de228";
            url = "https://github.com/julien-nc/phonetrack/releases/download/v0.8.2/phonetrack-0.8.2.tar.gz";
          };
        }
      '';
    };
    extraAppsEnable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Automatically enable the apps in [](#opt-services.nextcloud.extraApps) every time Nextcloud starts.
        If set to false, apps need to be enabled in the Nextcloud web user interface or with `nextcloud-occ app:enable`.
      '';
    };
    appstoreEnable = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      example = true;
      description = ''
        Allow the installation and updating of apps from the Nextcloud appstore.
        Enabled by default unless there are packages in [](#opt-services.nextcloud.extraApps).
        Set this to true to force enable the store even if [](#opt-services.nextcloud.extraApps) is used.
        Set this to false to disable the installation of apps from the global appstore. App management is always enabled regardless of this setting.
      '';
    };
    https = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Use HTTPS for generated links.

        Be aware that this also enables HTTP Strict Transport Security (HSTS) headers.
      '';
    };
    package = lib.mkOption {
      type = lib.types.package;
      description = "Which package to use for the Nextcloud instance.";
      relatedPackages = [
        "nextcloud31"
        "nextcloud32"
      ];
    };
    phpPackage = lib.mkPackageOption pkgs "php" {
      default = [ "php84" ];
      example = "php82";
    };

    finalPackage = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      description = ''
        Package to the finalized Nextcloud package, including all installed apps.
        This is automatically set by the module.
      '';
    };

    maxUploadSize = lib.mkOption {
      default = "512M";
      type = lib.types.str;
      description = ''
        The upload limit for files. This changes the relevant options
        in php.ini and nginx if enabled.
      '';
    };

    webfinger = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable this option if you plan on using the webfinger plugin.
        The appropriate nginx rewrite rules will be added to your configuration.
      '';
    };

    phpExtraExtensions = lib.mkOption {
      type = lib.types.functionTo (lib.types.listOf lib.types.package);
      default = all: [ ];
      defaultText = lib.literalExpression "all: []";
      description = ''
        Additional PHP extensions to use for Nextcloud.
        By default, only extensions necessary for a vanilla Nextcloud installation are enabled,
        but you may choose from the list of available extensions and add further ones.
        This is sometimes necessary to be able to install a certain Nextcloud app that has additional requirements.
      '';
      example = lib.literalExpression ''
        all: [ all.pdlib all.bz2 ]
      '';
    };

    phpOptions = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.oneOf [
          lib.types.str
          lib.types.int
        ]
      );
      defaultText = lib.literalExpression (
        lib.generators.toPretty { } (
          defaultPHPSettings // { "openssl.cafile" = lib.literalExpression "config.security.pki.caBundle"; }
        )
      );
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

    poolSettings = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.oneOf [
          lib.types.str
          lib.types.int
          lib.types.bool
        ]
      );
      default = {
        "pm" = "dynamic";
        "pm.max_children" = "120";
        "pm.start_servers" = "12";
        "pm.min_spare_servers" = "6";
        "pm.max_spare_servers" = "18";
        "pm.max_requests" = "500";
        "pm.status_path" = "/status";
      };
      description = ''
        Options for nextcloud's PHP pool. See the documentation on `php-fpm.conf` for details on
        configuration directives. The above are recommended for a server with 4GiB of RAM.

        It's advisable to read the [section about PHPFPM tuning in the upstream manual](https://docs.nextcloud.com/server/latest/admin_manual/installation/server_tuning.html#tune-php-fpm)
        and consider customizing the values.
      '';
    };

    poolConfig = lib.mkOption {
      type = lib.types.nullOr lib.types.lines;
      default = null;
      description = ''
        Options for Nextcloud's PHP pool. See the documentation on `php-fpm.conf` for details on configuration directives.
      '';
    };

    fastcgiTimeout = lib.mkOption {
      type = lib.types.int;
      default = 120;
      description = ''
        FastCGI timeout for database connection in seconds.
      '';
    };

    database = {

      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to create the database and database user locally.
        '';
      };

    };

    config = {
      dbtype = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.enum [
            "sqlite"
            "pgsql"
            "mysql"
          ]
        );
        default = null;
        description = "Database type.";
      };
      dbname = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "nextcloud";
        description = "Database name.";
      };
      dbuser = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "nextcloud";
        description = "Database user.";
      };
      dbpassFile = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          The full path to a file that contains the database password.
        '';
      };
      dbhost = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default =
          if pgsqlLocal then
            "/run/postgresql"
          else if mysqlLocal then
            "localhost:/run/mysqld/mysqld.sock"
          else
            "localhost";
        defaultText = "localhost";
        example = "localhost:5000";
        description = ''
          Database host (+port) or socket path.
          If [](#opt-services.nextcloud.database.createLocally) is true and
          [](#opt-services.nextcloud.config.dbtype) is either `pgsql` or `mysql`,
          defaults to the correct Unix socket instead.
        '';
      };
      dbtableprefix = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Table prefix in Nextcloud's database.

          __Note:__ since Nextcloud 20 it's not an option anymore to create a database
          schema with a custom table prefix. This option only exists for backwards compatibility
          with installations that were originally provisioned with Nextcloud <20.
        '';
      };
      adminuser = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "root";
        description = ''
          Username for the admin account. The username is only set during the
          initial setup of Nextcloud! Since the username also acts as unique
          ID internally, it cannot be changed later!
        '';
      };
      adminpassFile = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = ''
          The full path to a file that contains the admin's password. The password is
          set only in the initial setup of Nextcloud by the systemd service `nextcloud-setup.service`.
        '';
      };
      objectstore = {
        s3 = {
          enable = lib.mkEnableOption ''
            S3 object storage as primary storage.

            This mounts a bucket on an Amazon S3 object storage or compatible
            implementation into the virtual filesystem.

            Further details about this feature can be found in the
            [upstream documentation](https://docs.nextcloud.com/server/22/admin_manual/configuration_files/primary_storage.html)
          '';
          bucket = lib.mkOption {
            type = lib.types.str;
            example = "nextcloud";
            description = ''
              The name of the S3 bucket.
            '';
          };
          verify_bucket_exists = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = ''
              Create the objectstore bucket if it does not exist.
            '';
          };
          key = lib.mkOption {
            type = lib.types.str;
            example = "EJ39ITYZEUH5BGWDRUFY";
            description = ''
              The access key for the S3 bucket.
            '';
          };
          secretFile = lib.mkOption {
            type = lib.types.str;
            example = "/var/nextcloud-objectstore-s3-secret";
            description = ''
              The full path to a file that contains the access secret.
            '';
          };
          hostname = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            example = "example.com";
            description = ''
              Required for some non-Amazon implementations.
            '';
          };
          port = lib.mkOption {
            type = lib.types.nullOr lib.types.port;
            default = null;
            description = ''
              Required for some non-Amazon implementations.
            '';
          };
          useSsl = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = ''
              Use SSL for objectstore access.
            '';
          };
          region = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            example = "REGION";
            description = ''
              Required for some non-Amazon implementations.
            '';
          };
          usePathStyle = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = ''
              Required for some non-Amazon S3 implementations.

              Ordinarily, requests will be made with
              `http://bucket.hostname.domain/`, but with path style
              enabled requests are made with
              `http://hostname.domain/bucket` instead.
            '';
          };
          sseCKeyFile = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
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

              [1]: https://docs.aws.amazon.com/AmazonS3/latest/userguide/ServerSideEncryptionCustomerKeys.html
            '';
          };
        };
      };
    };

    enableImagemagick =
      lib.mkEnableOption ''
        the ImageMagick module for PHP.
        This is used by the theming app and for generating previews of certain images (e.g. SVG and HEIF).
        You may want to disable it for increased security. In that case, previews will still be available
        for some images (e.g. JPEG and PNG).
        See <https://github.com/nextcloud/server/issues/13099>
      ''
      // {
        default = true;
      };

    configureRedis = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to configure Nextcloud to use the recommended Redis settings for small instances.

        ::: {.note}
        The Nextcloud system check recommends to configure either Redis or Memcache for file lock caching.
        :::

        ::: {.note}
        The `notify_push` app requires Redis to be configured. If this option is turned off, this must be configured manually.
        :::
      '';
    };

    caching = {
      apcu = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to load the APCu module into PHP.
        '';
      };
      redis = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to load the Redis module into PHP.
          You still need to enable Redis in your config.php.
          See <https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/caching_configuration.html>
        '';
      };
      memcached = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to load the Memcached module into PHP.
          You still need to enable Memcached in your config.php.
          See <https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/caching_configuration.html>
        '';
      };
    };
    autoUpdateApps = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Run a regular auto-update of all apps installed from the Nextcloud app store.
        '';
      };
      startAt = lib.mkOption {
        type = lib.types.either lib.types.str (lib.types.listOf lib.types.str);
        default = "05:00:00";
        example = "Sun 14:00:00";
        description = ''
          When to run the update. See `systemd.services.<name>.startAt`.
        '';
      };
    };
    occ = lib.mkOption {
      type = lib.types.package;
      default = occ;
      defaultText = lib.literalMD "generated script";
      description = ''
        The nextcloud-occ program preconfigured to target this Nextcloud instance.
      '';
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = jsonFormat.type;
        options = {

          loglevel = lib.mkOption {
            type = lib.types.ints.between 0 4;
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
          log_type = lib.mkOption {
            type = lib.types.enum [
              "errorlog"
              "file"
              "syslog"
              "systemd"
            ];
            default = "syslog";
            description = ''
              Logging backend to use.
              systemd automatically adds the php-systemd extensions to services.nextcloud.phpExtraExtensions.
              See the [nextcloud documentation](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/logging_configuration.html) for details.
            '';
          };
          skeletondirectory = lib.mkOption {
            default = "";
            type = lib.types.str;
            description = ''
              The directory where the skeleton files are located. These files will be
              copied to the data directory of new users. Leave empty to not copy any
              skeleton files.
            '';
          };
          trusted_domains = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = ''
              Trusted domains, from which the nextcloud installation will be
              accessible. You don't need to add
              `services.nextcloud.hostname` here.
            '';
          };
          trusted_proxies = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = ''
              Trusted proxies, to provide if the nextcloud installation is being
              proxied to secure against e.g. spoofing.
            '';
          };
          overwriteprotocol = lib.mkOption {
            type = lib.types.enum [
              ""
              "http"
              "https"
            ];
            default = "";
            example = "https";
            description = ''
              Force Nextcloud to always use HTTP or HTTPS i.e. for link generation.
              Nextcloud uses the currently used protocol by default, but when
              behind a reverse-proxy, it may use `http` for everything although
              Nextcloud may be served via HTTPS.
            '';
          };
          default_phone_region = lib.mkOption {
            default = "";
            type = lib.types.str;
            example = "DE";
            description = ''
              An [ISO 3166-1](https://www.iso.org/iso-3166-country-codes.html)
              country code which replaces automatic phone-number detection
              without a country code.

              As an example, with `DE` set as the default phone region,
              the `+49` prefix can be omitted for phone numbers.
            '';
          };
          "profile.enabled" = lib.mkEnableOption "global profiles" // {
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
          enabledPreviewProviders = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [
              "OC\\Preview\\PNG"
              "OC\\Preview\\JPEG"
              "OC\\Preview\\GIF"
              "OC\\Preview\\BMP"
              "OC\\Preview\\XBitmap"
              "OC\\Preview\\Krita"
              "OC\\Preview\\WebP"
              "OC\\Preview\\MarkDown"
              "OC\\Preview\\TXT"
              "OC\\Preview\\OpenDocument"
            ];
            description = ''
              The preview providers that should be explicitly enabled.
            '';
          };
          mail_domain = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = ''
              The return address that you want to appear on emails sent by the Nextcloud server, for example `nc-admin@example.com`, substituting your own domain, of course.
            '';
          };
          mail_from_address = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = ''
              FROM address that overrides the built-in `sharing-noreply` and `lostpassword-noreply` FROM addresses.
              Defaults to different FROM addresses depending on the feature.
            '';
          };
          mail_smtpdebug = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = ''
              Enable SMTP class debugging.
              `loglevel` will likely need to be adjusted too.
              [See docs](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/email_configuration.html#enabling-debug-mode).
            '';
          };
          mail_smtpmode = lib.mkOption {
            type = lib.types.enum [
              "sendmail"
              "smtp"
              "qmail"
              "null" # Yes, this is really a string null and not null.
            ];
            default = "smtp";
            description = ''
              Which mode to use for sending mail.
              If you are using local or remote SMTP, set this to `smtp`.
              For the `sendmail` option, you need an installed and working email system on the server, with your local `sendmail` installation.
              For `qmail`, the binary is /var/qmail/bin/sendmail, and it must be installed on your Unix system.
              Use the string null to send no mails (disable mail delivery). This can be useful if mails should be sent via APIs and rendering messages is not necessary.
            '';
          };
          mail_smtphost = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1";
            description = ''
              This depends on `mail_smtpmode`. Specify the IP address of your mail server host. This may contain multiple hosts separated by a semicolon. If you need to specify the port number, append it to the IP address separated by a colon, like this: `127.0.0.1:24`.
            '';
          };
          mail_smtpport = lib.mkOption {
            type = lib.types.port;
            default = 25;
            description = ''
              This depends on `mail_smtpmode`. Specify the port for sending mail.
            '';
          };
          mail_smtptimeout = lib.mkOption {
            type = lib.types.int;
            default = 10;
            description = ''
              This depends on `mail_smtpmode`. This sets the SMTP server timeout, in seconds. You may need to increase this if you are running an anti-malware or spam scanner.
            '';
          };
          mail_smtpsecure = lib.mkOption {
            type = lib.types.enum [
              ""
              "ssl"
            ];
            default = "";
            description = ''
              This depends on `mail_smtpmode`. Specify `ssl` when you are using SSL/TLS. Any other value will be ignored.
              If the server advertises STARTTLS capabilities, they might be used, but they cannot be enforced by this config option.
            '';
          };
          mail_smtpauth = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = ''
              This depends on `mail_smtpmode`. Change this to `true` if your mail server requires authentication.
            '';
          };
          mail_smtpname = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = ''
              This depends on `mail_smtpauth`. Specify the username for authenticating to the SMTP server.
            '';
          };
          # mail_smtppassword is skipped as it must be set through services.nextcloud.secrets
          mail_template_class = lib.mkOption {
            type = lib.types.str;
            default = "\\OC\\Mail\\EMailTemplate";
            description = ''
              Replaces the default mail template layout. This can be utilized if the options to modify the mail texts with the theming app are not enough.
              The class must extend `\OC\Mail\EMailTemplate`
            '';
          };
          mail_send_plaintext_only = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = ''
              Email will be sent by default with an HTML and a plain text body. This option allows sending only plain text emails.
            '';
          };
          mail_smtpstreamoptions = lib.mkOption {
            type = lib.types.attrsOf (lib.types.attrsOf lib.types.anything);
            default = { };
            description = ''
              This depends on `mail_smtpmode`. Array of additional streams options that will be passed to underlying Swift mailer implementation.
            '';
          };
          mail_sendmailmode = lib.mkOption {
            type = lib.types.enum [
              "smtp"
              "pipe"
            ];
            default = "smtp";
            description = ''
              For `smtp`, the sendmail binary is started with the parameter `-bs`: Use the SMTP protocol on standard input and output.
              For `pipe`, the binary is started with the parameters `-t`: Read message from STDIN and extract recipients.
            '';
          };
        };
      };
      default = { };
      description = ''
        Extra options which should be appended to Nextcloud's config.php file.
      '';
      example = lib.literalExpression ''
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

    secretFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Secret options which will be appended to Nextcloud's config.php file (written as JSON, in the same
        form as the [](#opt-services.nextcloud.settings) option), for example
        `{"redis":{"password":"secret"}}`.
      '';
    };

    nginx = {
      hstsMaxAge = lib.mkOption {
        type = lib.types.ints.positive;
        default = 15552000;
        description = ''
          Value for the `max-age` directive of the HTTP
          `Strict-Transport-Security` header.

          See section 6.1.1 of IETF RFC 6797 for detailed information on this
          directive and header.
        '';
      };
      enableFastcgiRequestBuffering = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to buffer requests against fastcgi requests. This is a workaround
          for `PUT` requests with the `Transfer-Encoding: chunked` header set and
          an unspecified `Content-Length`. Without request buffering for these requests,
          Nextcloud will create files with zero bytes length as described in
          [nextcloud/server#7995](https://github.com/nextcloud/server/issues/7995).

          ::: {.note}
          Please keep in mind that upstream suggests to not enable this as it might
          lead to timeouts on large files being uploaded as described in the
          [administrator manual](https://docs.nextcloud.com/server/latest/admin_manual/configuration_files/big_file_upload_configuration.html#nginx).
          :::
        '';
      };
    };

    cli.memoryLimit = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "1G";
      description = ''
        The `memory_limit` of PHP is equal to [](#opt-services.nextcloud.maxUploadSize).
        The value can be customized for `nextcloud-cron.service` using this option.
      '';
    };

    imaginary.enable = lib.mkEnableOption "Imaginary";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        warnings =
          let
            latest = 32;
            upgradeWarning = major: nixos: ''
              A legacy Nextcloud install (from before NixOS ${nixos}) may be installed.

              After nextcloud${toString major} is installed successfully, you can safely upgrade
              to ${toString (major + 1)}. The latest version available is Nextcloud${toString latest}.

              Please note that Nextcloud doesn't support upgrades across multiple major versions
              (i.e. an upgrade from 16 is possible to 17, but not 16 to 18).

              The package can be upgraded by explicitly declaring the service-option
              `services.nextcloud.package`.
            '';

          in
          (lib.optional (cfg.poolConfig != null) ''
            Using config.services.nextcloud.poolConfig is deprecated and will become unsupported in a future release.
            Please migrate your configuration to config.services.nextcloud.poolSettings.
          '')
          ++ (lib.optional (cfg.config.dbtableprefix != null) ''
            Using `services.nextcloud.config.dbtableprefix` is deprecated. Fresh installations with this
            option set are not allowed anymore since v20.

            If you have an existing installation with a custom table prefix, make sure it is
            set correctly in `config.php` and remove the option from your NixOS config.
          '')
          ++ (lib.optional (lib.versionOlder overridePackage.version "26") (upgradeWarning 25 "23.05"))
          ++ (lib.optional (lib.versionOlder overridePackage.version "27") (upgradeWarning 26 "23.11"))
          ++ (lib.optional (lib.versionOlder overridePackage.version "28") (upgradeWarning 27 "24.05"))
          ++ (lib.optional (lib.versionOlder overridePackage.version "29") (upgradeWarning 28 "24.11"))
          ++ (lib.optional (lib.versionOlder overridePackage.version "30") (upgradeWarning 29 "24.11"))
          ++ (lib.optional (lib.versionOlder overridePackage.version "31") (upgradeWarning 30 "25.05"))
          ++ (lib.optional (lib.versionOlder overridePackage.version "32") (upgradeWarning 31 "25.11"));

        services.nextcloud.package = lib.mkDefault (
          if pkgs ? nextcloud then
            throw ''
              The `pkgs.nextcloud`-attribute has been removed. If it's supposed to be the default
              nextcloud defined in an overlay, please set `services.nextcloud.package` to
              `pkgs.nextcloud`.
            ''
          else if lib.versionOlder stateVersion "25.05" then
            pkgs.nextcloud30
          else if lib.versionOlder stateVersion "25.11" then
            pkgs.nextcloud31
          else
            pkgs.nextcloud32
        );

        services.nextcloud.phpOptions = lib.mkMerge [
          (lib.mapAttrs (lib.const lib.mkOptionDefault) defaultPHPSettings)
          {
            upload_max_filesize = cfg.maxUploadSize;
            post_max_size = cfg.maxUploadSize;
            memory_limit = cfg.maxUploadSize;
          }
          (lib.mkIf cfg.caching.apcu {
            "apc.enable_cli" = "1";
          })
        ];
      }

      {
        assertions = [
          {
            assertion = cfg.database.createLocally -> cfg.config.dbpassFile == null;
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
          {
            assertion = cfg.config.dbtype != null;
            message = ''
              `services.nextcloud.config.dbtype` must be set explicitly (pgsql, mysql, or sqlite)

              Before 25.05, it used to default to sqlite but that is not recommended by upstream.
              Either set it to sqlite as it used to be, or convert to another type as described
              in the official db conversion page:
              https://docs.nextcloud.com/server/latest/admin_manual/configuration_database/db_conversion.html
            '';
          }
          {
            assertion =
              lib.versionAtLeast overridePackage.version "32.0.0"
              || (cfg.config.adminuser != null && cfg.config.adminpassFile != null);
            message = ''
              Disabling initial admin user creation is only available on Nextcloud >= 32.0.0.
            '';
          }
          {
            assertion = cfg.config.adminuser == null -> cfg.config.adminpassFile == null;
            message = ''
              If `services.nextcloud.config.adminuser` is null, `services.nextcloud.config.adminpassFile` must be null as well in order to disable initial admin user creation.
            '';
          }
          {
            assertion = cfg.config.adminpassFile == null -> cfg.config.adminuser == null;
            message = ''
              If `services.nextcloud.config.adminpassFile` is null, `services.nextcloud.config.adminuser` must be null as well in order to disable initial admin user creation.
            '';
          }
          {
            assertion = !(cfg.settings ? mail_smtppassword);
            message = ''
              The option `services.nextcloud.settings.mail_smtppassword` must not be used, as it puts the password into the world-readable nix store.
              Use `services.nextcloud.secrets.mail_smtppassword` instead and set it to a file containing the password.
            '';
          }
        ];
      }

      {
        systemd.timers.nextcloud-cron = {
          wantedBy = [ "timers.target" ];
          after = [ "nextcloud-setup.service" ];
          timerConfig = {
            OnBootSec = "5m";
            OnUnitActiveSec = "5m";
            Unit = "nextcloud-cron.service";
          };
        };

        systemd.tmpfiles.rules =
          map (dir: "d ${dir} 0750 nextcloud nextcloud - -") [
            "${cfg.home}"
            "${datadir}/config"
            "${datadir}/data"
            "${cfg.home}/store-apps"
          ]
          ++ [
            "L+ ${datadir}/config/override.config.php - - - - ${overrideConfig}"
          ];

        services.nextcloud.finalPackage = webroot;

        systemd.services = {
          nextcloud-setup =
            let
              c = cfg.config;
              occInstallCmd =
                let
                  mkExport =
                    { arg, value }:
                    ''
                      ${arg}=${value};
                      export ${arg};
                    '';
                  dbpass = {
                    arg = "DBPASS";
                    value = if c.dbpassFile != null then ''"$(<"$CREDENTIALS_DIRECTORY/dbpass")"'' else ''""'';
                  };
                  adminpass =
                    if c.adminpassFile != null then
                      {
                        arg = "ADMINPASS";
                        value = ''"$(<"$CREDENTIALS_DIRECTORY/adminpass")"'';
                      }
                    else
                      null;
                  installFlags = lib.concatStringsSep " \\\n    " (
                    lib.mapAttrsToList (k: v: "${k} ${toString v}") {
                      "--database" = ''"${c.dbtype}"'';
                      # The following attributes are optional depending on the type of
                      # database.  Those that evaluate to null on the left hand side
                      # will be omitted.
                      ${if c.dbname != null then "--database-name" else null} = ''"${c.dbname}"'';
                      ${if c.dbhost != null then "--database-host" else null} = ''"${c.dbhost}"'';
                      ${if c.dbuser != null then "--database-user" else null} = ''"${c.dbuser}"'';
                      "--database-pass" = "\"\$${dbpass.arg}\"";
                      ${if c.adminuser != null then "--admin-user" else null} = ''"${c.adminuser}"'';
                      ${if adminpass != null then "--admin-pass" else null} = "\"\$${adminpass.arg}\"";
                      ${if c.adminuser == null && adminpass == null then "--disable-admin-user" else null} = "";
                      "--data-dir" = ''"${datadir}/data"'';
                    }
                  );
                in
                ''
                  ${mkExport dbpass}
                  ${lib.optionalString (adminpass != null) (mkExport adminpass)}
                  ${lib.getExe occ} maintenance:install \
                      ${installFlags}
                '';
              occSetTrustedDomainsCmd = lib.concatStringsSep "\n" (
                lib.imap0 (i: v: ''
                  ${lib.getExe occ} config:system:set trusted_domains \
                    ${toString i} --value="${toString v}"
                '') (lib.unique ([ cfg.hostName ] ++ cfg.settings.trusted_domains))
              );

            in
            {
              wantedBy = [ "multi-user.target" ];
              wants = [ "nextcloud-update-db.service" ];
              before = [ "phpfpm-nextcloud.service" ];
              after = lib.optional mysqlLocal "mysql.service" ++ lib.optional pgsqlLocal "postgresql.target";
              requires = lib.optional mysqlLocal "mysql.service" ++ lib.optional pgsqlLocal "postgresql.target";
              path = [ occ ];
              restartTriggers = [ overrideConfig ];
              script = ''
                export OCC_BIN="${lib.getExe occ}"

                ${lib.optionalString (c.dbpassFile != null) ''
                  if [ -z "$(<"$CREDENTIALS_DIRECTORY/dbpass")" ]; then
                    echo "dbpassFile ${c.dbpassFile} is empty!"
                    exit 1
                  fi
                ''}
                ${lib.optionalString (c.adminpassFile != null) ''
                  if [ -z "$(<"$CREDENTIALS_DIRECTORY/adminpass")" ]; then
                    echo "adminpassFile ${c.adminpassFile} is empty!"
                    exit 1
                  fi
                ''}

                # Check if systemd-tmpfiles setup worked correctly
                if [[ ! -O "${datadir}/config" ]]; then
                  echo "${datadir}/config is not owned by user 'nextcloud'!"
                  echo "Please check the logs via 'journalctl -u systemd-tmpfiles-setup'"
                  echo "and make sure there are no unsafe path transitions."
                  echo "(https://nixos.org/manual/nixos/stable/#module-services-nextcloud-pitfalls-during-upgrade)"
                  exit 1
                fi

                ${lib.concatMapStrings
                  (name: ''
                    if [ -d "${cfg.home}"/${name} ]; then
                      echo "Cleaning up ${name}; these are now bundled in the webroot store-path!"
                      rm -r "${cfg.home}"/${name}
                    fi
                  '')
                  [
                    "nix-apps"
                    "apps"
                  ]
                }

                # Do not install if already installed
                if [[ ! -s ${datadir}/config/config.php ]]; then
                  ${occInstallCmd}
                fi

                $OCC_BIN upgrade

                $OCC_BIN config:system:delete trusted_domains

                ${lib.optionalString (cfg.extraAppsEnable && cfg.extraApps != { }) ''
                  # Try to enable apps
                  $OCC_BIN app:enable ${lib.concatStringsSep " " (lib.attrNames cfg.extraApps)}
                ''}

                ${occSetTrustedDomainsCmd}
              '';
              serviceConfig.Type = "oneshot";
              serviceConfig.User = "nextcloud";
              serviceConfig.LoadCredential =
                lib.optional (cfg.config.adminpassFile != null) "adminpass:${cfg.config.adminpassFile}"
                ++ runtimeSystemdCredentials;
              # On Nextcloud ≥ 26, it is not necessary to patch the database files to prevent
              # an automatic creation of the database user.
              environment.NC_setup_create_db_user = "false";
            };
          nextcloud-cron = {
            after = [ "nextcloud-setup.service" ];
            # NOTE: In contrast to the occ wrapper script running phpCli directly will not
            #       set NEXTCLOUD_CONFIG_DIR by itself currently.
            environment.NEXTCLOUD_CONFIG_DIR = "${datadir}/config";
            script = ''
              # NOTE: This early returns the script when nextcloud is in maintenance mode
              #       or needs `occ upgrade`. Using ExecCondition= is not possible here
              #       because it doesn't work with systemd credentials.
              if [[ $(${lib.getExe occ} status --output=json | ${lib.getExe pkgs.jq} '. | if .maintenance or .needsDbUpgrade then "skip" else "" end' --raw-output) == "skip" ]]; then
                echo "Nextcloud is in maintenance mode or needs DB upgrade, exiting."
                exit 0
              fi

              ${phpCli} -f ${webroot}/cron.php
            '';
            serviceConfig = {
              Type = "exec";
              User = "nextcloud";
              KillMode = "process";
              LoadCredential = runtimeSystemdCredentials;
            };
          };
          nextcloud-update-plugins = lib.mkIf cfg.autoUpdateApps.enable {
            after = [ "nextcloud-setup.service" ];
            serviceConfig = {
              Type = "oneshot";
              ExecStart = "${lib.getExe occ} app:update --all";
              User = "nextcloud";
              LoadCredential = runtimeSystemdCredentials;
            };
            startAt = cfg.autoUpdateApps.startAt;
          };
          nextcloud-update-db = {
            after = [ "nextcloud-setup.service" ];
            script = ''
              # NOTE: This early returns the script when nextcloud is in maintenance mode
              #       or needs `occ upgrade`. Using ExecCondition= is not possible here
              #       because it doesn't work with systemd credentials.
              if [[ $(${lib.getExe occ} status --output=json | ${lib.getExe pkgs.jq} '. | if .maintenance or .needsDbUpgrade then "skip" else "" end' --raw-output) == "skip" ]]; then
                echo "Nextcloud is in maintenance mode or needs DB upgrade, exiting."
                exit 0
              fi

              ${lib.getExe occ} db:add-missing-columns
              ${lib.getExe occ} db:add-missing-indices
              ${lib.getExe occ} db:add-missing-primary-keys
            '';
            serviceConfig = {
              Type = "exec";
              User = "nextcloud";
              LoadCredential = runtimeSystemdCredentials;
            };
          };

          phpfpm-nextcloud = {
            # When upgrading the Nextcloud package, Nextcloud can report errors such as
            # "The files of the app [all apps in /var/lib/nextcloud/apps] were not replaced correctly"
            # Restarting phpfpm on Nextcloud package update fixes these issues (but this is a workaround).
            restartTriggers = [
              webroot
              overrideConfig
            ];
          }
          // lib.optionalAttrs requiresRuntimeSystemdCredentials {
            serviceConfig.LoadCredential = runtimeSystemdCredentials;

            # FIXME: We use a hack to make the credential files readable by the nextcloud
            #        user by copying them somewhere else and overriding CREDENTIALS_DIRECTORY
            #        for php. This is currently necessary as the unit runs as root.
            serviceConfig.RuntimeDirectory = lib.mkForce "phpfpm phpfpm-nextcloud";
            preStart = ''
              umask 0077

              # NOTE: Runtime directories for this service are currently preserved
              #       between restarts.
              rm -rf /run/phpfpm-nextcloud/credentials/
              mkdir -p /run/phpfpm-nextcloud/credentials/
              cp "$CREDENTIALS_DIRECTORY"/* /run/phpfpm-nextcloud/credentials/
              chown -R nextcloud:nextcloud /run/phpfpm-nextcloud/credentials/
            '';
          };
        };

        services.phpfpm = {
          pools.nextcloud = {
            user = "nextcloud";
            group = "nextcloud";
            phpPackage = phpPackage;
            phpEnv = {
              CREDENTIALS_DIRECTORY = "/run/phpfpm-nextcloud/credentials/";
              NEXTCLOUD_CONFIG_DIR = "${datadir}/config";
              PATH = "/run/wrappers/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:/usr/bin:/bin";
            };
            settings =
              lib.mapAttrs (name: lib.mkDefault) {
                "listen.owner" = config.services.nginx.user;
                "listen.group" = config.services.nginx.group;
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
          config.services.nginx.user
        ];

        environment.systemPackages = [ occ ];

        services.mysql = lib.mkIf mysqlLocal {
          enable = true;
          package = lib.mkDefault pkgs.mariadb;
          ensureDatabases = [ cfg.config.dbname ];
          ensureUsers = [
            {
              name = cfg.config.dbuser;
              ensurePermissions = {
                "${cfg.config.dbname}.*" = "ALL PRIVILEGES";
              };
            }
          ];
        };

        services.postgresql = lib.mkIf pgsqlLocal {
          enable = true;
          ensureDatabases = [ cfg.config.dbname ];
          ensureUsers = [
            {
              name = cfg.config.dbuser;
              ensureDBOwnership = true;
            }
          ];
        };

        services.redis.servers.nextcloud = lib.mkIf cfg.configureRedis {
          enable = true;
          user = "nextcloud";
        };

        services.nextcloud = {
          caching.redis = lib.mkIf cfg.configureRedis true;
          settings = lib.mkMerge [
            {
              datadirectory = lib.mkDefault "${datadir}/data";
              trusted_domains = [ cfg.hostName ];
              "upgrade.disable-web" = true;
              # NixOS already provides its own integrity check and the nix store is read-only, therefore Nextcloud does not need to do its own integrity checks.
              "integrity.check.disabled" = true;
            }
            (lib.mkIf cfg.configureRedis {
              "memcache.distributed" = ''\OC\Memcache\Redis'';
              "memcache.locking" = ''\OC\Memcache\Redis'';
              redis = {
                host = config.services.redis.servers.nextcloud.unixSocket;
                port = 0;
              };
            })
            # https://docs.nextcloud.com/server/latest/admin_manual/installation/server_tuning.html#previews
            (lib.mkIf cfg.imaginary.enable {
              preview_imaginary_url = "http://${config.services.imaginary.address}:${toString config.services.imaginary.port}";

              # Imaginary replaces a few of the built-in providers, so the default value has to be adjusted.
              enabledPreviewProviders = lib.mkDefault [
                "OC\\Preview\\Imaginary"
                "OC\\Preview\\ImaginaryPDF"
                "OC\\Preview\\Krita"
                "OC\\Preview\\MarkDown"
                "OC\\Preview\\TXT"
                "OC\\Preview\\OpenDocument"
              ];
            })
          ];
        };

        services.nginx.enable = lib.mkDefault true;

        services.nginx.virtualHosts.${cfg.hostName} = {
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
                rewrite ^/(?!index|remote|public|cron|core\/ajax\/update|status|ocs\/v[12]|updater\/.+|ocs-provider\/.+|.+\/richdocumentscode(_arm64)?\/proxy) /index.php$request_uri;
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
                fastcgi_request_buffering ${if cfg.nginx.enableFastcgiRequestBuffering then "on" else "off"};
                fastcgi_read_timeout ${builtins.toString cfg.fastcgiTimeout}s;
              '';
            };
            "~ \\.(?:css|js|mjs|svg|gif|ico|jpg|jpeg|png|webp|wasm|tflite|map|html|ttf|bcmap|mp4|webm|ogg|flac)$".extraConfig =
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
            "~ ^\\/(?:updater|ocs-provider)(?:$|\\/)".extraConfig = ''
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
            add_header X-Content-Type-Options nosniff;
            add_header X-Robots-Tag "noindex, nofollow";
            add_header X-Permitted-Cross-Domain-Policies none;
            add_header X-Frame-Options sameorigin;
            add_header Referrer-Policy no-referrer;
            ${lib.optionalString (cfg.https) ''
              add_header Strict-Transport-Security "max-age=${toString cfg.nginx.hstsMaxAge}; includeSubDomains" always;
            ''}
            client_max_body_size ${cfg.maxUploadSize};
            fastcgi_buffers 64 4K;
            fastcgi_hide_header X-Powered-By;
            # mirror upstream htaccess file https://github.com/nextcloud/server/blob/v32.0.0/.htaccess#L40-L41
            fastcgi_hide_header Referrer-Policy;
            fastcgi_hide_header X-Content-Type-Options;
            fastcgi_hide_header X-Frame-Options;
            fastcgi_hide_header X-Permitted-Cross-Domain-Policies;
            fastcgi_hide_header X-Robots-Tag;
            gzip on;
            gzip_vary on;
            gzip_comp_level 4;
            gzip_min_length 256;
            gzip_proxied expired no-cache no-store private no_last_modified no_etag auth;
            gzip_types application/atom+xml text/javascript application/javascript application/json application/ld+json application/manifest+json application/rss+xml application/vnd.geo+json application/vnd.ms-fontobject application/wasm application/x-font-ttf application/x-web-app-manifest+json application/xhtml+xml application/xml font/opentype image/bmp image/svg+xml image/x-icon text/cache-manifest text/css text/plain text/vcard text/vnd.rim.location.xloc text/vtt text/x-component text/x-cross-domain-policy;

            ${lib.optionalString cfg.webfinger ''
              rewrite ^/.well-known/host-meta /public.php?service=host-meta last;
              rewrite ^/.well-known/host-meta.json /public.php?service=host-meta-json last;
            ''}
          '';
        };

        services.imaginary = lib.mkIf cfg.imaginary.enable {
          enable = true;
          # add -return-size flag recommend by Nextcloud
          # https://github.com/h2non/imaginary/pull/382
          settings.return-size = true;
        };
      }
    ]
  );

  meta.doc = ./nextcloud.md;
  meta.maintainers = lib.teams.nextcloud.members;
}
