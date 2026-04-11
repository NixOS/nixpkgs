{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    any
    attrValues
    flatten
    getExe
    literalExpression
    mapAttrs
    mapAttrs'
    mapAttrsToList
    mkDefault
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    nameValuePair
    optionalAttrs
    optionalString
    types
    ;
  inherit (lib.strings)
    removePrefix
    removeSuffix
    ;
  inherit (pkgs)
    mariadb
    stdenv
    writeShellScript
    ;
  cfg = config.services.drupal;
  eachSite = cfg.sites;
  user = "drupal";
  webserver = config.services.${cfg.webserver};

  pkg =
    hostName: cfg:
    stdenv.mkDerivation (finalAttrs: {
      pname = "drupal-${hostName}";
      name = "drupal-${hostName}";
      src = cfg.package;

      buildInputs = [ pkgs.rsync ];

      installPhase = ''
        runHook preInstall

        mkdir -p $out
        EXCLUDES="--exclude=${removePrefix "/" cfg.webRoot}/sites --exclude=sites"

        if [ ! -z "${cfg.configRoot}" ]; then
          EXCLUDES="$EXCLUDES --exclude=${removePrefix "/" cfg.configRoot}"
        fi

        rsync -aq * $out/ $EXCLUDES

        runHook postInstall
      '';

      postInstall = ''
        ln -s ${cfg.stateDir}/sites $out/share/php/${cfg.package.pname}${cfg.webRoot}
        ln -s ${cfg.modulesDir} $out/share/php/${cfg.package.pname}/modules
        ln -s ${cfg.themesDir} $out/share/php/${cfg.package.pname}/themes
      '';
    });

  sites =
    hostName: cfg:
    stdenv.mkDerivation (finalAttrs: {
      pname = "drupal-sites-${hostName}";
      name = "drupal-sites-${hostName}";
      src = cfg.package;
      buildInputs = with pkgs; [ rsync ];

      installPhase = ''
        runHook preInstall

        mkdir -p $out/sites
        rsync -a ./share/php/${cfg.package.pname}${cfg.webRoot}/sites/* $out/sites/

        runHook postInstall
      '';
    });

  configSync =
    hostName: cfg:
    optionalString (cfg.configRoot != "") (
      stdenv.mkDerivation (finalAttrs: {
        pname = "drupal-config-${hostName}";
        name = "drupal-config-${hostName}";
        src = cfg.package;
        buildInputs = with pkgs; [ rsync ];

        installPhase = ''
          runHook preInstall

          mkdir -p $out/config
          rsync -a ./share/php/${cfg.package.pname}${cfg.configRoot}/* $out/config/

          runHook postInstall
        '';
      })
    );

  drupalSettings =
    hostName: cfg:
    pkgs.writeTextFile {
      name = "settings.nixos-${hostName}.php";
      text = ''
        <?php

          // NixOS automatically generated settings
          $settings['file_private_path'] = '${cfg.privateFilesDir}';
          $settings['config_sync_directory'] = '${cfg.configSyncDir}';

          // Extra config
          ${cfg.extraConfig}
      '';
      checkPhase = "${pkgs.php}/bin/php --syntax-check $target";
    };

  appendSettings =
    hostName:
    pkgs.writeTextFile {
      name = "append-drupal-settings-${hostName}";
      text = ''

        // NixOS settings file import.
        require dirname(__FILE__) . '/settings.nixos-${hostName}.php';

      '';
    };

  # Required .htaccess for private files directory
  # See: https://www.drupal.org/docs/getting-started/installing-drupal/securing-drupal-file-directories
  privateFilesHtAccess = pkgs.writeTextFile {
    name = "private-files-htaccess";
    text = ''
      # Turn off all options we don't need.
      Options -Indexes -ExecCGI -Includes -MultiViews

      # Set the catch-all handler to prevent scripts from being executed.
      SetHandler Drupal_Security_Do_Not_Remove_See_SA_2006_006
      <Files *>
        # Override the handler again if we're run later in the evaluation list.
        SetHandler Drupal_Security_Do_Not_Remove_See_SA_2013_003
      </Files>

      # If we know how to do it safely, disable the PHP engine entirely.
      <IfModule mod_php.c>
        php_flag engine off
      </IfModule>
    '';
  };

  stateDirManage =
    hostName: cfg:
    pkgs.writeShellApplication {
      name = "drupal-state-init-${hostName}";
      excludeShellChecks = [
        "SC2194"
        "SC2157"
      ];
      runtimeInputs = with pkgs; [ rsync ];
      text = ''
        echo "Updating the sites directory for ${hostName}..."
        rsync -auq "${sites hostName cfg}/sites/" "${cfg.stateDir}/sites/" \
          --exclude "*/files" \
          --delete-before

        if [ ! -z "${cfg.configRoot}" ]; then
          echo "Updating config sync directory for ${hostName}..."
          rsync -auq "${configSync hostName cfg}/config/" "${removeSuffix "/sync" cfg.configSyncDir}" \
            --delete-before
        fi

        if [ ! -d "${cfg.filesDir}" ]; then
          echo "Preparing files directory..."
          mkdir -p "${cfg.filesDir}"
          chown -R ${user}:${webserver.group} ${cfg.filesDir}
        fi

        case ${cfg.filesDir} in
          ${cfg.stateDir}/sites*) echo "Files directory is in sites directory. Skipping optional link!";;
          *) ln -sf "${cfg.filesDir}" "${cfg.stateDir}/sites/default/files";;
        esac

        if [ ! -f "${cfg.privateFilesDir}/.htaccess" ]; then
          echo "Linking .htaccess file for private files directory..."
          ln -s "${privateFilesHtAccess}" "${cfg.privateFilesDir}/.htaccess"
        fi

        echo "Preparing settings.php for ${hostName}..."
        settings_file="${cfg.stateDir}/sites/default/settings.php"

        if [ ! -f "$settings_file" ]; then
          default_settings_file="${cfg.stateDir}/sites/default/default.settings.php";
          cp "$default_settings_file" "$settings_file"
        fi

        if ! grep -qF "require dirname(__FILE__) . '/settings.nixos-${hostName}.php';" ${cfg.stateDir}/sites/default/settings.php; then
          echo "Appending NixOS generated settings..."
          cat < ${appendSettings hostName} >> "$settings_file"
        fi

        # Link the NixOS-managed settings file to the state directory.
        ln -sf ${drupalSettings hostName cfg} ${cfg.stateDir}/sites/default/settings.nixos-${hostName}.php

        # Set or reset file permissions so that the web user and webserver owns them.
        chown -R ${user}:${webserver.group} ${cfg.stateDir}
      '';
    };

  siteOpts =
    {
      options,
      config,
      lib,
      name,
      ...
    }:
    {
      options = {
        enable = mkEnableOption "Drupal web application";
        package = mkPackageOption pkgs "drupal" { };

        filesDir = mkOption {
          type = types.path;
          default = "/var/lib/drupal/${name}/sites/default/files";
          defaultText = "/var/lib/drupal/<name>/sites/default/files";
          description = ''
            The location of the Drupal files directory.

            Many of the files in this directory are variable, so they must be located
            in a location writeable by users of the webgroup.
          '';
        };

        privateFilesDir = mkOption {
          type = types.path;
          default = "/var/lib/drupal/${name}/private";
          defaultText = "/var/lib/drupal/<name>/private";
          description = "The location of the Drupal private files directory.";
        };

        configSyncDir = mkOption {
          type = types.path;
          default = "/var/lib/drupal/${name}/config/sync";
          defaultText = "/var/lib/drupal/<name>/config/sync";
          description = ''
            The location of the user-managed Drupal config sync directory.
            Drupal will both read from and write to this directory when executing
            configuration management operations.

            This option differs from the `configRoot` option,
            which this service uses to discover
            the location of the config sync directory in the package's source code.
          '';
        };

        webRoot = mkOption {
          type = types.str;
          default = "";
          description = ''
            An optional path string with a leading slash
            indicating the location of the Drupal webroot
            in your package's source code.

            The path relative to the project root directory.
          '';
          example = "/web";
        };

        configRoot = mkOption {
          type = types.str;
          default = "";
          description = ''
            An optional path string with a leading slash
            indicating the location of the config sync directory on
            the Drupal package. Your package will probably have a config sync
            directory if it has been significantly customized.

            The path must be relative to the project root directory.

            This option differs from the `configSyncDir` option, which
            tells this service where to create a user-writeable config directory
            on NixOS.
          '';
          example = "/config";
        };

        extraConfig = mkOption {
          type = types.lines;
          default = "";
          description = ''
            Extra configuration values that you want to insert into settings.php.
            All configuration must be written as PHP script.
          '';
          example = ''
            $config['user.settings']['anonymous'] = 'Visitor';
            $settings['entity_update_backup'] = TRUE;
          '';
        };

        stateDir = mkOption {
          type = types.path;
          default = "/var/lib/drupal/${name}";
          defaultText = "/var/lib/drupal/<name>";
          description = ''
            The location of the user-managed Drupal site state directory.
            This directory will contain the settings and configuration files for
            your Drupal instance. It may also contain your files directory if the
            `filesDir` option remains unchanged.

            Many of the files in this directory are variable, so they must be located
            in a location writeable by users of the webgroup.
          '';
        };

        modulesDir = mkOption {
          type = types.path;
          default = "/var/lib/drupal/${name}/modules";
          defaultText = "/var/lib/drupal/<name>/modules";
          description = ''
            The location for users to manually install Drupal modules.

            Note: in most instances, it is preferable to install modules using
            composer, or to package them with your source code repository, if
            you are using a custom Drupal.
          '';
        };

        themesDir = mkOption {
          type = types.path;
          default = "/var/lib/drupal/${name}/themes";
          defaultText = "/var/lib/drupal/<name>/themes";
          description = ''
            The location for users to manually install Drupal themes.

            Note: in most instances, it is preferable to install themes using
            composer, or to package them with your source code repository, if
            you are using a custom Drupal.
          '';
        };

        phpOptions = mkOption {
          type = types.attrsOf types.str;
          default = { };
          description = ''
            Options for PHP's php.ini file for this Drupal site.
          '';
          example = literalExpression ''
            {
              "opcache.interned_strings_buffer" = "8";
              "opcache.max_accelerated_files" = "10000";
              "opcache.memory_consumption" = "128";
              "opcache.revalidate_freq" = "15";
              "opcache.fast_shutdown" = "1";
            }
          '';
        };

        database = {
          host = mkOption {
            type = types.str;
            default = "localhost";
            description = "Database host address.";
          };

          port = mkOption {
            type = types.port;
            default = 3306;
            description = "Database host port.";
          };

          name = mkOption {
            type = types.str;
            default = "drupal";
            description = "Database name.";
          };

          user = mkOption {
            type = types.str;
            default = "drupal";
            description = "Database user.";
          };

          passwordFile = mkOption {
            type = types.nullOr types.path;
            default = null;
            example = "/run/keys/database-dbpassword";
            description = ''
              A file containing the password corresponding to
              {option}`database.user`.
            '';
          };

          tablePrefix = mkOption {
            type = types.str;
            default = "dp_";
            description = ''
              The $table_prefix is the value placed in the front of your database tables.
              Change the value if you want to use something other than dp_ for your database
              prefix. Typically this is changed if you are installing multiple Drupal sites
              in the same database.
            '';
          };

          socket = mkOption {
            type = types.nullOr types.path;
            default = null;
            defaultText = literalExpression "/run/mysqld/mysqld.sock";
            description = "Path to the unix socket file to use for authentication.";
          };

          createLocally = mkOption {
            type = types.bool;
            default = true;
            description = "Create the database and database user locally.";
          };
        };

        virtualHost = mkOption {
          type = types.submodule (import ../web-servers/apache-httpd/vhost-options.nix);
          example = literalExpression ''
            {
              adminAddr = "webmaster@example.org";
              forceSSL = true;
              enableACME = true;
            }
          '';
          description = ''
            Apache configuration can be done by adapting {option}`services.httpd.virtualHosts`.
          '';
        };

        poolConfig = mkOption {
          type =
            with types;
            attrsOf (oneOf [
              str
              int
              bool
            ]);
          default = {
            "pm" = "dynamic";
            "pm.max_children" = 32;
            "pm.start_servers" = 2;
            "pm.min_spare_servers" = 2;
            "pm.max_spare_servers" = 4;
            "pm.max_requests" = 500;
          };
          description = ''
            Options for the Drupal PHP pool. See the documentation on `php-fpm.conf`
            for details on configuration directives.
          '';
        };
      };

      config.virtualHost.hostName = mkDefault name;
    };
in
{
  options = {
    services.drupal = {
      enable = mkEnableOption "drupal";
      package = mkPackageOption pkgs "drupal" { };

      sites = mkOption {
        type = types.attrsOf (types.submodule siteOpts);
        default = {
          "localhost" = {
            enable = true;
          };
        };
        description = "Specification of one or more Drupal sites to serve";
      };

      webserver = mkOption {
        type = types.enum [
          "nginx"
          "caddy"
        ];
        default = "nginx";
        description = ''
          Whether to use nginx or caddy for virtual host management.

          Further nginx configuration can be done by adapting `services.nginx.virtualHosts.<name>`.
          See [](#opt-services.nginx.virtualHosts) for further information.

          Further caddy configuration can be done by adapting `services.caddy.virtualHosts.<name>`.
          See [](#opt-services.caddy.virtualHosts) for further information.
        '';
      };
    };
  };

  config = mkIf (cfg.enable) (mkMerge [
    {

      assertions =
        (mapAttrsToList (hostName: cfg: {
          assertion = cfg.database.createLocally -> cfg.database.user == user;
          message = ''services.drupal.sites."${hostName}".database.user must be ${user} if the database is to be automatically provisioned'';
        }) eachSite)
        ++ (mapAttrsToList (hostName: cfg: {
          assertion = cfg.database.createLocally -> cfg.database.passwordFile == null;
          message = ''services.drupal.sites."${hostName}".database.passwordFile cannot be specified if services.drupal.sites."${hostName}".database.createLocally is set to true.'';
        }) eachSite);

      services.mysql = mkIf (any (v: v.database.createLocally) (attrValues eachSite)) {
        enable = true;
        package = mkDefault mariadb;
        ensureDatabases = mapAttrsToList (hostName: cfg: cfg.database.name) eachSite;
        ensureUsers = mapAttrsToList (hostName: cfg: {
          name = cfg.database.user;
          ensurePermissions = {
            "${cfg.database.name}.*" = "ALL PRIVILEGES";
          };
        }) eachSite;
      };

      services.phpfpm.pools = mapAttrs' (
        hostName: cfg:
        (nameValuePair "drupal-${hostName}" {
          inherit user;
          group = webserver.group;
          settings = {
            "listen.owner" = webserver.user;
            "listen.group" = webserver.group;
          }
          // cfg.poolConfig;
        })
      ) eachSite;
    }

    {
      systemd.tmpfiles.rules = flatten (
        mapAttrsToList (hostName: cfg: [
          "d '${cfg.stateDir}' 0750 ${user} ${webserver.group} - -"
          "d '${cfg.modulesDir}' 0750 ${user} ${webserver.group} - -"
          "Z '${cfg.modulesDir}' 0750 ${user} ${webserver.group} - -"
          "d '${cfg.themesDir}' 0750 ${user} ${webserver.group} - -"
          "Z '${cfg.themesDir}' 0750 ${user} ${webserver.group} - -"
          "d '${cfg.privateFilesDir}' 0750 ${user} ${webserver.group} - -"
          "d '${cfg.filesDir}' 0750 ${user} ${webserver.group} - -"
          "Z '${cfg.filesDir}' 0750 ${user} ${webserver.group} - -"
          "d '${cfg.configSyncDir}' 0750 ${user} ${webserver.group} - -"
        ]) eachSite
      );

      users.users.${user} = {
        group = webserver.group;
        isSystemUser = true;
      };
    }

    {
      # Run a service that prepares the state directory.
      systemd.services = mkMerge [
        (mapAttrs' (
          hostName: cfg:
          (nameValuePair "drupal-state-init-${hostName}" {
            wantedBy = [ "multi-user.target" ];
            before = [ "nginx.service" ];
            after = [ "local-fs.target" ];

            serviceConfig = {
              Type = "oneshot";
              User = "root";
              RemainAfterExit = true;

              ExecStart = getExe (stateDirManage hostName cfg);
            };

            # Rerun this service if certain settings were updated
            reloadTriggers = [
              cfg.extraConfig
              cfg.privateFilesDir
              cfg.filesDir
              cfg.stateDir
              cfg.configSyncDir
            ];
          })
        ) eachSite)

        (optionalAttrs (any (v: v.database.createLocally) (attrValues eachSite)) {
          httpd.after = [ "mysql.service" ];
        })
      ];
    }

    (mkIf (cfg.webserver == "nginx") {
      services.nginx = {
        enable = true;
        virtualHosts = mapAttrs (hostName: cfg: {
          serverName = mkDefault hostName;
          root = "${pkg hostName cfg}/share/php/${cfg.package.pname}${cfg.webRoot}";
          extraConfig = ''
            index index.php index.htm index.html;
          '';
          locations = {
            "~ '\\.php$|^/update\\.php'" = {
              extraConfig = ''
                fastcgi_split_path_info ^(.+\.php)(/.+)$;
                fastcgi_pass unix:${config.services.phpfpm.pools."drupal-${hostName}".socket};
                fastcgi_index index.php;
                include "${config.services.nginx.package}/conf/fastcgi.conf";
                fastcgi_param PATH_INFO $fastcgi_path_info;
                fastcgi_param PATH_TRANSLATED $document_root$fastcgi_path_info;
                # Mitigate https://httpoxy.org/ vulnerabilities
                fastcgi_param HTTP_PROXY "";
                fastcgi_intercept_errors off;
                fastcgi_buffer_size 16k;
                fastcgi_buffers 4 16k;
                fastcgi_connect_timeout 300;
                fastcgi_send_timeout 300;
                fastcgi_read_timeout 300;
              '';
            };
            "= /favicon.ico" = {
              extraConfig = ''
                log_not_found off;
                access_log off;
              '';
            };
            "= /robots.txt" = {
              extraConfig = ''
                allow all;
                log_not_found off;
                access_log off;
              '';
            };
            "~ \\..*/.*\\.php$" = {
              extraConfig = ''
                return 403;
              '';
            };
            "~ ^/sites/.*/private/" = {
              extraConfig = ''
                return 403;
              '';
            };
            "~ ^/sites/[^/]+/files/.*\\.php$" = {
              extraConfig = ''
                deny all;
              '';
            };
            "~* ^/.well-known/" = {
              extraConfig = ''
                allow all;
              '';
            };
            "/" = {
              extraConfig = ''
                try_files $uri /index.php?$query_string;
              '';
            };
            "@rewrite" = {
              extraConfig = ''
                rewrite ^ /index.php;
              '';
            };
            "~ /vendor/.*\\.php$" = {
              extraConfig = ''
                deny all;
                return 404;
              '';
            };
            "~* \\.(js|css|png|jpg|jpeg|gif|ico|svg)$" = {
              extraConfig = ''
                try_files $uri @rewrite;
                expires max;
                log_not_found off;
              '';
            };
            "~ ^/sites/.*/files/styles/" = {
              extraConfig = ''
                alias ${cfg.filesDir}/;
                try_files $uri @rewrite;
              '';
            };
            "^~ /sites/.*/files/" = {
              extraConfig = ''
                alias ${cfg.filesDir}/;
                try_files $uri @rewrite;
              '';
            };
            "~ ^(/[a-z\\-]+)?/system/files/" = {
              extraConfig = ''
                alias ${cfg.privateFilesDir}/;
                try_files $uri /index.php?$query_string;
              '';
            };
          };
        }) eachSite;
      };
    })

    (mkIf (cfg.webserver == "caddy") {
      services.caddy = {
        enable = true;
        virtualHosts = mapAttrs' (
          hostName: cfg:
          (nameValuePair hostName {
            extraConfig = ''
              root * ${pkg hostName cfg}/share/php/${cfg.package.pname}${cfg.webRoot}
              file_server
              root /sites/*/files ${cfg.filesDir}

              encode zstd gzip
              php_fastcgi unix/${config.services.phpfpm.pools."drupal-${hostName}".socket}
            '';
          })
        ) cfg.sites;
      };
    })

  ]);
}
