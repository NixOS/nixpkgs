{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.pelican-panel;

  inherit (cfg) package;
  inherit (package.passthru) php;

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
    optionalString
    pipe
    isString
    match
    ;

  artisan = pkgs.writeShellScriptBin "pelican-artisan" ''
    cd /var/lib/pelican/www
    exec ${pkgs.sudo}/bin/sudo -u pelican ${php}/bin/php artisan "$@"
  '';

  autoConfig = {
    APP_DEBUG = false;
    APP_ENV = "production";
    APP_INSTALLED = true;
    APP_URL = cfg.domain;

    DB_DATABASE = "pelican";
    DB_USERNAME = "pelican";
    DB_CONNECTION = "mariadb";
    DB_HOST = "localhost";
    DB_SOCKET = "/run/mysqld/mysqld.sock";

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

    STATE="/var/lib/pelican"
    WWW="$STATE/www"
    STORE="${package}"

    # Create persistent state directories
    mkdir -p \
      $STATE/storage/{app/public,framework/{cache/data,sessions,views},logs/install} \
      $STATE/plugins \
      $STATE/bootstrap-cache

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

    ${artisan}/bin/pelican-artisan migrate --force
    ${artisan}/bin/pelican-artisan filament:optimize
  '';
in
{
  options.services.pelican-panel = {
    enable = mkEnableOption "Pelican Panel";

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
    ];

    users = {
      users.pelican = {
        isSystemUser = true;
        group = "pelican";
        home = "/var/lib/pelican";
      };
      groups.pelican = { };
    };

    services = {
      mysql = {
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

      redis.servers.pelican = {
        enable = true;
        group = "pelican";
      };

      phpfpm.pools.pelican = {
        phpPackage = php;
        user = "pelican";
        group = "pelican";

        settings = mkMerge [
          {
            "pm" = "dynamic";
            "pm.max_children" = 10;
            "pm.start_servers" = 2;
            "pm.min_spare_servers" = 2;
            "pm.max_spare_servers" = 5;
            "chdir" = "/var/lib/pelican/www";
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
          root * /var/lib/pelican/www/public
          encode gzip
          file_server
          php_fastcgi unix//run/phpfpm/pelican.sock
        '';
      };
    };

    systemd = {
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
            "mysql.service"
            "redis-pelican.service"
          ];
          requires = [
            "mysql.service"
            "redis-pelican.service"
          ];
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

          serviceConfig = {
            User = "pelican";
            Group = "pelican";
            WorkingDirectory = "/var/lib/pelican/www";
            ExecStart = "${php}/bin/php artisan queue:work --tries=3";
            Restart = "on-failure";
            RestartSec = "5s";
          };
        };

        pelican-scheduler = {
          description = "Pelican Panel Scheduler";
          after = [ "pelican-setup.service" ];

          serviceConfig = {
            Type = "oneshot";
            User = "pelican";
            Group = "pelican";
            WorkingDirectory = "/var/lib/pelican/www";
            ExecStart = "${php}/bin/php artisan schedule:run";
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
