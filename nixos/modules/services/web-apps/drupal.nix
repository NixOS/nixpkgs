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
    types
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

      installPhase = ''
        runHook preInstall

        mkdir -p $out
        cp -r * $out/

        runHook postInstall
      '';

      postInstall = ''
        ln -s ${cfg.filesDir} $out/share/php/drupal/sites/default/files
        ln -s ${cfg.stateDir}/sites/default/settings.php $out/share/php/drupal/sites/default/settings.php
        ln -s ${cfg.modulesDir} $out/share/php/drupal/modules
        ln -s ${cfg.themesDir} $out/share/php/drupal/themes
      '';
    });

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
          description = "The location of the Drupal config sync directory.";
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
          description = "The location of the Drupal site state directory.";
        };

        modulesDir = mkOption {
          type = types.path;
          default = "/var/lib/drupal/${name}/modules";
          defaultText = "/var/lib/drupal/<name>/modules";
          description = "The location for users to install Drupal modules.";
        };

        themesDir = mkOption {
          type = types.path;
          default = "/var/lib/drupal/${name}/themes";
          defaultText = "/var/lib/drupal/<name>/themes";
          description = "The location for users to install Drupal themes.";
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

              ExecStart = writeShellScript "drupal-state-init-${hostName}" ''
                set -e

                if [ ! -d "${cfg.stateDir}/sites" ]; then
                  echo "Preparing sites directory..."
                  cp -r "${cfg.package}/share/php/drupal/sites" "${cfg.stateDir}"
                fi

                if [ ! -d "${cfg.filesDir}" ]; then
                  echo "Preparing files directory..."
                  mkdir -p "${cfg.filesDir}"
                  chown -R ${user}:${webserver.group} ${cfg.filesDir}
                fi

                settings_file="${cfg.stateDir}/sites/default/settings.php"
                default_settings="${cfg.package}/share/php/drupal/sites/default/default.settings.php"

                if [ ! -f "$settings_file" ]; then
                  echo "Preparing settings.php for ${hostName}..."
                  cp "$default_settings" "$settings_file"
                  cat < ${appendSettings hostName} >> "$settings_file"
                  chmod 644 "$settings_file"
                fi

                # Link the NixOS-managed settings file to the state directory.
                ln -sf ${drupalSettings hostName cfg} ${cfg.stateDir}/sites/default/settings.nixos-${hostName}.php

                # Set or reset file permissions so that the web user and webserver owns them.
                chown -R ${user}:${webserver.group} ${cfg.stateDir}
              '';
            };

            # Rerun this service if certain settings were updated
            reloadTriggers = [
              cfg.extraConfig
              cfg.privateFilesDir
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
          root = "${pkg hostName cfg}/share/php/drupal";
          extraConfig = ''
            index index.php;
          '';
          locations = {
            "~ '\.php$|^/update.php'" = {
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
            "~ \..*/.*\.php$" = {
              extraConfig = ''
                return 403;
              '';
            };
            "~ ^/sites/.*/private/" = {
              extraConfig = ''
                return 403;
              '';
            };
            "~ ^/sites/[^/]+/files/.*\.php$" = {
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
            "~ /vendor/.*\.php$" = {
              extraConfig = ''
                deny all;
                return 404;
              '';
            };
            "~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$" = {
              extraConfig = ''
                try_files $uri @rewrite;
                expires max;
                log_not_found off;
              '';
            };
            "~ ^/sites/.*/files/styles/" = {
              extraConfig = ''
                try_files $uri @rewrite;
              '';
            };
            "~ ^(/[a-z\-]+)?/system/files/" = {
              extraConfig = ''
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
              root * ${pkg hostName cfg}/share/php/drupal
              file_server

              encode zstd gzip
              php_fastcgi unix/${config.services.phpfpm.pools."drupal-${hostName}".socket}
            '';
          })
        ) cfg.sites;
      };
    })

  ]);
}
