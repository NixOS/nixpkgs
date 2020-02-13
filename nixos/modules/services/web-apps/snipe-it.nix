{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.snipe-it;

  group = config.services.nginx.group;
  user = config.services.nginx.user;

  configurationDirectory = let
    databaseDumpPath =
      if config.services.mysql.package == pkgs.mariadb
      then "${pkgs.mariadb}/bin/" else "${pkgs.mysql-client}/bin/";
    moduleConfiguration = ''
      # Regular configuration options set by NixOS module.
      APP_URL=http://${cfg.hostName}

    '' + optionalString cfg.database.enable ''
      # Database configuration set by NixOS module.
      DB_CONNECTION=mysql
      DB_HOST=localhost:${builtins.toString config.services.mysql.port}
      DB_DATABASE=${cfg.database.name}
      DB_USERNAME=${user}
      DB_PREFIX=${cfg.database.prefix}_
      DB_DUMP_PATH=${databaseDumpPath}
      DB_SOCKET=/run/mysqld/mysqld.sock
      DB_CHARSET=utf8mb4
      DB_COLLATION=utf8mb4_unicode_ci

    '';
    configuration = pkgs.writeText "snipeit-config" (moduleConfiguration + cfg.config);
  in
    pkgs.runCommand "snipeit-config-root" {} "mkdir -p $out; ln -s ${configuration} $out/.env";

  # Normalise the data directory for use in string interpolation.
  dataDirectory =
    if hasSuffix "/" cfg.dataDirectory
    then removeSuffix "/" cfg.dataDirectory
    else cfg.dataDirectory;

  environment = {
    # These environment variables are expected because of the patches applied to the
    # Laravel framework.
    "LARAVEL_NIX_ENVIRONMENT_PATH" = "${configurationDirectory}";
    "LARAVEL_NIX_STORAGE_PATH" = "${dataDirectory}/data/storage";
    "LARAVEL_NIX_BOOTSTRAP_CACHE_PATH" = "${dataDirectory}/data/bootstrap/cache";
    # These environment variables are expected because of the patches applied to Snipe-IT.
    "SNIPEIT_PUBLIC_UPLOADS_DIR" = "${dataDirectory}/data/uploads";
  };

  # Helper script for running Snipe IT's `artisan` administration script with the same
  # environment variables as Snipe IT is run as.
  artisanScript = pkgs.writeScriptBin "snipeit-artisan" ''
    #! ${pkgs.runtimeShell} -e
    ${builtins.concatStringsSep " " (mapAttrsToList (k: v: "${k}=${v}") environment)} \
      ${pkgs.php}/bin/php ${cfg.package}/artisan "$@"
  '';
in
{
  options.services.snipe-it = {
    enable = mkEnableOption "Snipe-IT asset management application";

    addHelperScriptToEnvironment = mkOption {
      type = types.bool;
      default = true;
      description = "Should helper script for running `artisan` be added to the environment?";
    };

    config = mkOption {
      type = types.lines;
      description = ''
        Configuration options for Snipe-IT. Must provide value for all required settings - if
        `services.snipe-it.database.enable` is true then database configuration options will be
        set by module. `APP_URL` setting is set by module.

        See <link xlink:href="https://snipe-it.readme.io/docs/configuration"/> for full list of
        settings.
      '';
    };

    database = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable database configuration for Snipe-IT.

          This option will enable a MySQL database on the current host and configure Snipe-IT
          to connect. If you wish to configure Snipe-IT's database connection differently, then
          disable this and add appropriate configuration to the `services.snipe-it.config' option.

          The same user as runs nginx will be used as the database user, so that unix socket
          authentication can be used.
        '';
      };

      name = mkOption {
        type = types.str;
        default = "snipeit";
        description = "Name of Snipe-IT database";
      };

      prefix = mkOption {
        type = types.str;
        default = "snipeit";
        description = "Prefix for database tables from Snipe-IT.";
      };
    };

    dataDirectory = mkOption {
      type = types.path;
      default = "/var/lib/snipeit";
      description = "Location of Snipe-IT storage directory.";
    };

    hostName = mkOption {
      type = types.str;
      default = "localhost";
      description = "Hostname of instance, used in nginx virtualhost.";
    };

    nginxConfig = mkOption {
      type = types.submodule
        (import ../web-servers/nginx/vhost-options.nix { inherit config lib; });
      default = {};
      example = {
        serverAliases = [ "wiki.\${config.networking.domain}" ];
      };
      description = "Extra configuration for the nginx virtual host of Snipe-IT.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.snipe-it;
      description = ''
        Snipe-IT package to use. `dataDirectory` argument to package much match
        `services.snipe-it.dataDirectory` option.
      '';
    };

    poolConfig = mkOption {
      type = with types; attrsOf (oneOf [ str int bool ]);
      default = {
        "pm" = "dynamic";
        "pm.max_children" = 32;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 2;
        "pm.max_spare_servers" = 4;
        "pm.max_requests" = 500;
      };
      description = ''
        Options for Snipe-IT PHP pool. See documentation on <literal>php-fpm.conf</literal> for
        details on configuration directives.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = mkIf cfg.addHelperScriptToEnvironment [ artisanScript ];

    services = {
      mysql = mkIf cfg.database.enable {
        enable = true;
        ensureDatabases = [ cfg.database.name ];
        ensureUsers = [
          {
            name = user;
            ensurePermissions = { "${cfg.database.name}.*" = "ALL PRIVILEGES"; };
          }
        ];
        package = mkDefault pkgs.mariadb;
      };

      nginx = {
        enable = true;
        virtualHosts."${cfg.hostName}" = mkMerge [
          cfg.nginxConfig
          {
            locations = {
              "/".tryFiles = "$uri $uri/ /index.php$is_args$args";
              # Snipe-IT is patched to write uploads to data directory instead of in
              # `public/uploads`, so make these match up.
              "/uploads" = {
                root = "${dataDirectory}/data/";
                extraConfig = ''
                  autoindex on;
                '';
              };
              "~ \\.php$" = {
                extraConfig = ''
                  fastcgi_pass unix:${config.services.phpfpm.pools.snipe-it.socket};
                  fastcgi_index index.php;
                  fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                  include ${config.services.nginx.package}/conf/fastcgi_params;
                '';
                tryFiles = "$uri $uri/ =404";
              };
            };
            root = mkForce "${cfg.package}/public";
            extraConfig = ''
              index index.php index.html index.htm;
            '';
          }
        ];
      };

      phpfpm.pools.snipe-it = {
        inherit group user;
        phpEnv = environment;
        settings = {
          "listen.mode" = "0660";
          "listen.owner" = user;
          "listen.group" = group;
        } // cfg.poolConfig;
      };
    };

    systemd = {
      services = {
        phpfpm-snipe-it.after = optional cfg.database.enable "mysql.service";

        snipe-it-cron = {
          inherit environment;
          after = [ "snipe-it-init.service" ];
          enable = true;
          script = "${pkgs.php}/bin/php ${cfg.package}/artisan schedule:run";
          startAt = "1 minute";
          serviceConfig = {
            User = user;
            Group = group;
            Type = "oneshot";
          };
          wantedBy = [ "multi-user.target" ];
        };

        snipe-it-init = {
          inherit environment;
          after = optional cfg.database.enable "mysql.service";
          before = [ "phpfpm-snipe-it.service" ];
          enable = true;
          script = ''
            ${pkgs.php}/bin/php ${cfg.package}/artisan migrate
            ${pkgs.php}/bin/php ${cfg.package}/artisan config:clear
            ${pkgs.php}/bin/php ${cfg.package}/artisan config:cache
          '';
          serviceConfig = {
            User = user;
            Group = group;
            Type = "oneshot";
          };
          wantedBy = [ "multi-user.target" ];
        };
      };

      tmpfiles.rules = let
        directories = [
          ""
          "data"
          "data/bootstrap"
          "data/bootstrap/cache"
          "data/storage"
          "data/storage/app"
          "data/storage/app/backups"
          "data/storage/debugbar"
          "data/storage/framework"
          "data/storage/framework/cache"
          "data/storage/framework/sessions"
          "data/storage/framework/views"
          "data/storage/logs"
          "data/storage/private_uploads"
          "data/uploads"
          "data/uploads/accessories"
          "data/uploads/avatars"
          "data/uploads/barcodes"
          "data/uploads/categories"
          "data/uploads/companies"
          "data/uploads/components"
          "data/uploads/consumables"
          "data/uploads/departments"
          "data/uploads/locations"
          "data/uploads/manufacturers"
          "data/uploads/models"
          "data/uploads/suppliers"
        ];
      in
        builtins.map (dir: "d ${dataDirectory}/${dir} 0750 ${user} ${group} - -") directories;
    };
  };
}
