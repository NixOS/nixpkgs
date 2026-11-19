{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.pelican-panel;

  inherit (lib)
    mkOption
    mkEnableOption
    mkPackageOption
    types
    maintainers
    generators
    mkIf
    mkMerge
    optional
    pipe
    isString
    match
    optionalAttrs
    getExe
    ;

  artisan = pkgs.writeShellApplication {
    name = "pelican-artisan";
    runtimeInputs = config.systemd.services.pelican-queue.path;
    runtimeEnv = config.systemd.services.pelican-queue.environment;
    text = ''
      cd ${cfg.stateDir}/www
      exec ${getExe pkgs.sudo} -u ${cfg.user} -E -- ${getExe cfg.phpPackage} artisan "$@"
    '';
  };

  autoConfig = {
    APP_DEBUG = false;
    APP_ENV = "production";
    APP_INSTALLED = true;
    APP_URL = cfg.domain;

    DB_DATABASE = "pelican";
    DB_USERNAME = "pelican";
    DB_CONNECTION = cfg.database.type;
    DB_HOST = if (cfg.database.type == "pgsql") then "/var/run/postgresql" else "localhost";
    DB_SOCKET = if (cfg.database.type == "mariadb") then "/run/mysqld/mysqld.sock" else "";

    REDIS_SCHEME = "unix";
    REDIS_PATH = config.services.redis.servers.pelican.unixSocket;
    CACHE_STORE = "redis";
    QUEUE_DRIVER = "redis";
    SESSION_DRIVER = "redis";

    MAIL_DRIVER = "log";
  };

  mergedConfig = autoConfig // cfg.environment;

  storeEnv =
    let
      mkValueString =
        v:
        if isString v then
          ''"${v}"''
        else if v == false then
          "false"
        else if v == true then
          "true"
        else
          toString v;
      mkKeyValue = generators.mkKeyValueDefault { inherit mkValueString; } "=";
    in
    pipe mergedConfig [
      (generators.toKeyValue { inherit mkKeyValue; })
      (pkgs.writeText "pelican-base.env")
    ];

  setupScript = pkgs.writeShellScript "pelican-setup" ''
    set -euo pipefail

    STATE="${cfg.stateDir}"
    WWW="$STATE/www"
    STORE="${cfg.package}"

    # Rebuild the working webroot when the panel package changes
    if [ "$(cat $WWW/.nix-store-path 2>/dev/null || true)" != "$STORE" ]; then
      rm -rf "$WWW"
      cp -r "$STORE" "$WWW"
      chmod -R u+w "$WWW"
      echo "$STORE" > "$WWW/.nix-store-path"
    fi

    sort -u -t '=' -k 1,1 ${cfg.secretEnvironmentFile} ${storeEnv} > "$STATE/.env"
    chmod 640 "$STATE/.env"

    # Writable overlay symlinks
    ln -sfn "$STATE/storage" "$WWW/storage"
    ln -sfn "$STATE/bootstrap-cache" "$WWW/bootstrap/cache"
    ln -sfn "$STATE/plugins" "$WWW/plugins"
    ln -sfn "$STATE/storage/app/public" "$WWW/public/storage"
    ln -sfn "$STATE/.env" "$WWW/.env"

    chmod -R o+rX "$WWW/public"
    chown -R pelican:pelican "$STATE"

    ${getExe artisan} migrate --force
    ${getExe artisan} filament:optimize
  '';
in
{
  options.services.pelican-panel = {
    enable = mkEnableOption "Pelican Panel";

    database = {
      type = mkOption {
        type = types.enum [
          "mariadb"
          "pgsql"
        ];
        default = "mariadb";
        description = "Database used by pelican panel.";
      };
      createLocally = mkOption {
        type = types.bool;
        default = true;
        description = ''
          If set to `true` the database gets created locally.
          If set to `false`, please set the environment variables according to your needs.
          See more [here](https://github.com/pelican/panel/blob/main/config/database.php).
        '';
      };
    };

    webserver = mkOption {
      type = types.enum [
        "caddy"
        "none"
      ];
      default = "caddy";
      example = "none";
      description = "Webserver to serve Pelican Panel with. Set to `none` to configure it yourself.";
    };

    package = mkPackageOption pkgs "pelican-panel" { };

    phpPackage = mkOption {
      type = types.package;
      default = cfg.package.passthru.php;
      defaultText = lib.literalExpression "config.services.pelican-panel.package.passthru.php";
      description = "The php package to use.";
    };

    openFirewall = mkEnableOption "firewall rules for Pelican";

    port = mkOption {
      type = types.port;
      default = 8081;
      description = "The port the webserver listens on";
    };

    domain = mkOption {
      type = with types; nullOr str;
      description = "The URL where the users access the panel. This must be reachable from the wings nodes.";
      example = "https://panel.example.com";
    };

    caddy.domain = mkOption {
      type = types.str;
      description = "URL that caddy serves the panel on";
      default =
        if (cfg.domain != null) then "${cfg.domain}:${toString cfg.port}" else ":${toString cfg.port}";
      defaultText = lib.literalExpression ''
        if (config.services.pelican-panel.domain != null) then
          "''${config.services.pelican-panel.domain}:''${toString config.services.pelican-panel.port}"
        else
          ":''${toString config.services.pelican-panel.port}"
      '';
      example = lib.literalExpression ":\${toString config.pelican-panel.port}";
    };

    stateDir = mkOption {
      type = types.path;
      default = "/var/lib/pelican";
      description = "The state directory for Pelican Panel.";
    };

    user = lib.mkOption {
      default = "pelican";
      type = types.str;
      description = ''
        User account under which the Pelican Panel runs.

        ::: {.note}
        If left as the default value this user will automatically be created
        on system activation, otherwise the sysadmin is responsible for
        ensuring the user exists before the Pelican Panel service starts.
        :::
      '';
    };

    group = lib.mkOption {
      default = "pelican";
      type = types.str;
      description = ''
        Group under which the Pelican Panel runs.

        ::: {.note}
        If left as the default value this group will automatically be created
        on system activation, otherwise the sysadmin is responsible for
        ensuring the group exists before the Pelican Panel service starts.
        :::
      '';
    };

    environment = mkOption {
      type = types.attrsOf (
        types.oneOf [
          types.str
          types.int
          types.bool
        ]
      );
      default = { };
      description = "Base Pelican Panel configuration written to the Nix store at eval time as a .env file. Merged with secretEnvironmentFile at runtime, with secrets taking precedence.";
    };

    secretEnvironmentFile = mkOption {
      type = types.path;
      description = "Path to a .env file containing secret configuration values. Merged before configuration at runtime so its values take precedence.";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = (cfg.domain == null || match "https?://.*" cfg.domain != null);
        message = "`services.pelican-panel.domain` must be `null` or a valid URL";
      }
      {
        assertion =
          !(
            cfg.database.type == "pgsql"
            && (mergedConfig.DB_USERNAME != mergedConfig.DB_DATABASE)
            && cfg.database.createLocally
          );
        message = "`services.pelican-panel.environment.DB_USERNAME` must match `services.pelican-panel.environment.DB_DATABASE` when using postgresql locally";
      }
      {
        assertion =
          !(
            cfg.database.type == "pgsql" && (mergedConfig.DB_USERNAME != cfg.user) && cfg.database.createLocally
          );
        message = "`services.pelican-panel.environment.DB_USERNAME` must match `services.pelican-panel.user` when using postgresql locally";
      }
    ];

    users.users = optionalAttrs (cfg.user == "pelican") {
      pelican = {
        isSystemUser = true;
        inherit (cfg) group;
        home = cfg.stateDir;
      };
    };

    users.groups = optionalAttrs (cfg.group == "pelican") {
      pelican = { };
    };

    services = {
      mysql = mkIf (cfg.database.type == "mariadb" && cfg.database.createLocally) {
        enable = true;
        package = pkgs.mariadb;
        ensureDatabases = [ mergedConfig.DB_DATABASE ];
        ensureUsers = [
          {
            name = mergedConfig.DB_USERNAME;
            ensurePermissions."${mergedConfig.DB_DATABASE}.*" = "ALL PRIVILEGES";
          }
        ];
      };

      postgresql = mkIf (cfg.database.type == "pgsql" && cfg.database.createLocally) {
        enable = true;
        ensureDatabases = [ mergedConfig.DB_DATABASE ];
        ensureUsers = [
          {
            name = mergedConfig.DB_USERNAME;
            ensureDBOwnership = true;
          }
        ];
      };

      redis.servers.pelican = {
        enable = true;
        group = "pelican";
      };

      phpfpm.pools.pelican = {
        inherit (cfg) phpPackage user group;

        settings = mkMerge [
          {
            "pm" = "dynamic";
            "pm.max_children" = 10;
            "pm.start_servers" = 2;
            "pm.min_spare_servers" = 2;
            "pm.max_spare_servers" = 5;
            "chdir" = "${cfg.stateDir}/www";
            "catch_workers_output" = "yes";
            "decorate_workers_output" = "no";
            "env[LOG_CHANNEL]" = "stderr";
          }

          (mkIf (cfg.webserver == "caddy") {
            "listen.owner" = config.services.caddy.user;
            "listen.group" = config.services.caddy.group;
          })
        ];

        phpOptions = {
          "opcache.enable" = 1;
          "opcache.memory_consumption" = 128;
          "opcache.interned_strings_buffer" = 8;
          "opcache.max_accelerated_files" = 10000;
          "opcache.validate_timestamps" = 0;
        };
      };

      caddy = mkIf (cfg.webserver == "caddy") {
        enable = true;

        virtualHosts."${cfg.caddy.domain}".extraConfig = ''
          root * ${cfg.stateDir}/www/public
          encode gzip
          file_server
          php_fastcgi unix//run/phpfpm/pelican.sock
        '';
      };
    };

    systemd =
      let
        dbService = if (cfg.database.type == "mariadb") then "mysql.service" else "postgresql.service";
      in
      {
        services = {
          phpfpm-pelican = {
            after = [ "pelican-setup.service" ];
            requires = [ "pelican-setup.service" ];
          };

          caddy = mkIf (cfg.webserver == "caddy") {
            after = [ "pelican-setup.service" ];
            requires = [ "pelican-setup.service" ];
          };

          pelican-setup = {
            description = "Pelican Panel Setup";
            wantedBy = [ "multi-user.target" ];
            after = [
              "redis-pelican.service"
            ]
            ++ optional cfg.database.createLocally dbService;
            requires = [
              "redis-pelican.service"
            ]
            ++ optional cfg.database.createLocally dbService;
            before = [
              "phpfpm-pelican.service"
              "pelican-queue.service"
            ]
            ++ optional (cfg.webserver == "caddy") "caddy.service";

            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStart = setupScript;
            };
          };

          pelican-queue = {
            description = "Pelican Panel Queue Worker";
            after = [ "pelican-setup.service" ];
            requires = [ "pelican-setup.service" ];
            wantedBy = [ "multi-user.target" ];

            path = with pkgs; [
              phpPackages
              phpPackages.packages.composer
              yarn-berry
              git
              unzip
            ];

            environment = {
              COMPOSER_HOME = "${cfg.stateDir}/.composer";
              COMPOSER_CACHE_DIR = "/var/cache/pelican/composer";
            };

            serviceConfig = {
              User = cfg.user;
              Group = cfg.group;
              WorkingDirectory = "${cfg.stateDir}/www";
              CacheDirectory = "pelican/composer";
              ExecStart = "${getExe cfg.phpPackage} artisan queue:work --tries=3";
              Restart = "on-failure";
              RestartSec = "5s";
            };
          };

          pelican-scheduler = {
            description = "Pelican Panel Scheduler";
            after = [ "pelican-setup.service" ];

            serviceConfig = {
              Type = "oneshot";
              User = cfg.user;
              Group = cfg.group;
              WorkingDirectory = "${cfg.stateDir}/www";
              ExecStart = "${getExe cfg.phpPackage} artisan schedule:run";
            };
          };
        };

        timers.pelican-scheduler = {
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = "*-*-* *:*:12";
            Persistent = true;
          };
        };

        # Create persistent state directories
        tmpfiles.settings."10-pelican-panel" =
          let
            stateDirList =
              list:
              lib.attrsets.genAttrs' list (
                dir: lib.nameValuePair (cfg.stateDir + "/" + dir) { d = { inherit (cfg) user group; }; }
              );
          in
          stateDirList [
            "plugins"
            "bootstrap-cache"
            "storage/app/public"
            "storage/framework/cache/data"
            "storage/framework/sessions"
            "storage/framework/views"
            "storage/logs/install"
          ];
      };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    environment.systemPackages = [ artisan ];
  };

  meta = {
    maintainers = with maintainers; [
      oskardotglobal
      nullcube
      Svenum
      keenanweaver
    ];
    doc = ./pelican-panel.md;
  };
}
