{ pkgs, config, lib, ... }:

let
  inherit (lib) optionalString mkDefault mkIf mkOption mkEnableOption literalExpression;
  inherit (lib.types) nullOr attrsOf oneOf str int bool path package enum submodule;
  inherit (lib.strings) concatLines removePrefix toShellVars removeSuffix hasSuffix;
  inherit (lib.attrsets) mapAttrsToList attrValues genAttrs filterAttrs mapAttrs' nameValuePair;
  inherit (builtins) isInt isString toString typeOf;

  cfg = config.services.firefly-iii;

  user = cfg.user;
  group = cfg.group;

  defaultUser = "firefly-iii";
  defaultGroup = "firefly-iii";

  artisan = "${cfg.package}/artisan";

  env-file-values = mapAttrs' (n: v: nameValuePair (removeSuffix "_FILE" n) v)
    (filterAttrs (n: v: hasSuffix "_FILE" n) cfg.settings);
  env-nonfile-values = filterAttrs (n: v: ! hasSuffix "_FILE" n) cfg.settings;

  fileenv-func = ''
    set -a
    ${toShellVars env-nonfile-values}
    ${concatLines (mapAttrsToList (n: v: "${n}=\"$(< ${v})\"") env-file-values)}
    set +a
  '';

  firefly-iii-maintenance = pkgs.writeShellScript "firefly-iii-maintenance.sh" ''
    ${fileenv-func}

    ${optionalString (cfg.settings.DB_CONNECTION == "sqlite")
      "touch ${cfg.dataDir}/storage/database/database.sqlite"}
    ${artisan} cache:clear
    ${artisan} package:discover
    ${artisan} firefly-iii:upgrade-database
    ${artisan} firefly-iii:laravel-passport-keys
    ${artisan} view:cache
    ${artisan} route:cache
    ${artisan} config:cache
  '';

  commonServiceConfig = {
    Type = "oneshot";
    User = user;
    Group = group;
    StateDirectory = "firefly-iii";
    ReadWritePaths = [cfg.dataDir];
    WorkingDirectory = cfg.package;
    PrivateTmp = true;
    PrivateDevices = true;
    CapabilityBoundingSet = "";
    AmbientCapabilities = "";
    ProtectSystem = "strict";
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectControlGroups = true;
    ProtectClock = true;
    ProtectHostname = true;
    ProtectHome = "tmpfs";
    ProtectKernelLogs = true;
    ProtectProc = "invisible";
    ProcSubset = "pid";
    PrivateNetwork = false;
    RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX";
    SystemCallArchitectures = "native";
    SystemCallFilter = [
      "@system-service @resources"
      "~@obsolete @privileged"
    ];
    RestrictSUIDSGID = true;
    RemoveIPC = true;
    NoNewPrivileges = true;
    RestrictRealtime = true;
    RestrictNamespaces = true;
    LockPersonality = true;
    PrivateUsers = true;
  };

in {

  options.services.firefly-iii = {

    enable = mkEnableOption "Firefly III: A free and open source personal finance manager";

    user = mkOption {
      type = str;
      default = defaultUser;
      description = "User account under which firefly-iii runs.";
    };

    group = mkOption {
      type = str;
      default = if cfg.enableNginx then "nginx" else defaultGroup;
      defaultText = "If `services.firefly-iii.enableNginx` is true then `nginx` else ${defaultGroup}";
      description = ''
        Group under which firefly-iii runs. It is best to set this to the group
        of whatever webserver is being used as the frontend.
      '';
    };

    dataDir = mkOption {
      type = path;
      default = "/var/lib/firefly-iii";
      description = ''
        The place where firefly-iii stores its state.
      '';
    };

    package = mkOption {
      type = package;
      default = pkgs.firefly-iii;
      defaultText = literalExpression "pkgs.firefly-iii";
      description = ''
        The firefly-iii package served by php-fpm and the webserver of choice.
        This option can be used to point the webserver to the correct root. It
        may also be used to set the package to a different version, say a
        development version.
      '';
      apply = firefly-iii : firefly-iii.override (prev: {
        dataDir = cfg.dataDir;
      });
    };

    enableNginx = mkOption {
      type = bool;
      default = false;
      description = ''
        Whether to enable nginx or not. If enabled, an nginx virtual host will
        be created for access to firefly-iii. If not enabled, then you may use
        `''${config.services.firefly-iii.package}` as your document root in
        whichever webserver you wish to setup.
      '';
    };

    virtualHost = mkOption {
      type = str;
      default = "localhost";
      description = ''
        The hostname at which you wish firefly-iii to be served. If you have
        enabled nginx using `services.firefly-iii.enableNginx` then this will
        be used.
      '';
    };

    poolConfig = mkOption {
      type = attrsOf (oneOf [ str int bool ]);
      default = {
        "pm" = "dynamic";
        "pm.max_children" = 32;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 2;
        "pm.max_spare_servers" = 4;
        "pm.max_requests" = 500;
      };
      description = ''
        Options for the Firefly III PHP pool. See the documentation on <literal>php-fpm.conf</literal>
        for details on configuration directives.
      '';
    };

    settings = mkOption {
      default = {};
      description = ''
        Options for firefly-iii configuration. Refer to
        <https://github.com/firefly-iii/firefly-iii/blob/main/.env.example> for
        details on supported values. All <option>_FILE values supported by
        upstream are supported here.

        APP_URL will be the same as `services.firefly-iii.virtualHost` if the
        former is unset in `services.firefly-iii.settings`.
      '';
      example = literalExpression ''
        {
          APP_ENV = "production";
          APP_KEY_FILE = "/var/secrets/firefly-iii-app-key.txt";
          SITE_OWNER = "mail@example.com";
          DB_CONNECTION = "mysql";
          DB_HOST = "db";
          DB_PORT = 3306;
          DB_DATABASE = "firefly";
          DB_USERNAME = "firefly";
          DB_PASSWORD_FILE = "/var/secrets/firefly-iii-mysql-password.txt;
        }
      '';
      type = submodule {
        freeformType = attrsOf (oneOf [str int bool]);
        options = {
          DB_CONNECTION = mkOption {
            type = enum [ "sqlite" "pgsql" "mysql" ];
            default = "sqlite";
            example = "pgsql";
            description = ''
              The type of database you wish to use. Can be one of "sqlite",
              "mysql" or "pgsql".
            '';
          };
          APP_ENV = mkOption {
            type = enum [ "local" "production" "testing" ];
            default = "local";
            example = "production";
            description = ''
              The app environment. It is recommended to keep this at "local".
              Possible values are "local", "production" and "testing"
            '';
          };
          DB_PORT = mkOption {
            type = nullOr int;
            default = if cfg.settings.DB_CONNECTION == "pgsql" then 5432
                      else if cfg.settings.DB_CONNECTION == "mysql" then 3306
                      else null;
            defaultText = ''
              `null` if DB_CONNECTION is "sqlite", `3306` if "mysql", `5432` if "pgsql"
            '';
            description = ''
              The port your database is listening at. sqlite does not require
              this value to be filled.
            '';
          };
          DB_HOST = mkOption {
            type = str;
            default = if cfg.settings.DB_CONNECTION == "pgsql" then "/run/postgresql"
                      else "localhost";
            defaultText = ''
              "localhost" if DB_CONNECTION is "sqlite" or "mysql", "/run/postgresql" if "pgsql".
            '';
            description = ''
              The machine which hosts your database. This is left at the
              default value for "mysql" because we use the "DB_SOCKET" option
              to connect to a unix socket instead. "pgsql" requires that the
              unix socket location be specified here instead of at "DB_SOCKET".
              This option does not affect "sqlite".
            '';
          };
          APP_KEY_FILE = mkOption {
            type = path;
            description = ''
              The path to your appkey. The file should contain a 32 character
              random app key. This may be set using `echo "base64:$(head -c 32
              /dev/urandom | base64)" > /path/to/key-file`.
            '';
          };
          APP_URL = mkOption {
            type = str;
            default = if cfg.virtualHost == "localhost" then "http://${cfg.virtualHost}"
                      else "https://${cfg.virtualHost}";
            defaultText = ''
              http(s)://''${config.services.firefly-iii.virtualHost}
            '';
            description = ''
              The APP_URL used by firefly-iii internally. Please make sure this
              URL matches the external URL of your Firefly III installation. It
              is used to validate specific requests and to generate URLs in
              emails.
            '';
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {

    services.phpfpm.pools.firefly-iii = {
      inherit user group;
      phpPackage = cfg.package.phpPackage;
      phpOptions = ''
        log_errors = on
      '';
      settings = {
        "listen.mode" = "0660";
        "listen.owner" = user;
        "listen.group" = group;
        "clear_env" = "no";
      } // cfg.poolConfig;
    };

    systemd.services.firefly-iii-setup = {
      after = [ "postgresql.service" "mysql.service" ];
      requiredBy = [ "phpfpm-firefly-iii.service" ];
      before = [ "phpfpm-firefly-iii.service" ];
      serviceConfig = {
        ExecStart = firefly-iii-maintenance;
        RemainAfterExit = true;
      } // commonServiceConfig;
      unitConfig.JoinsNamespaceOf = "phpfpm-firefly-iii.service";
      restartTriggers = [ cfg.package ];
    };

    systemd.services.firefly-iii-cron = {
      after = [ "firefly-iii-setup.service" "postgresql.service" "mysql.service" ];
      wants = [ "firefly-iii-setup.service" ];
      description = "Daily Firefly III cron job";
      serviceConfig = {
        ExecStart = "${artisan} firefly-iii:cron";
      } // commonServiceConfig;
    };

    systemd.timers.firefly-iii-cron = {
      description = "Trigger Firefly Cron";
      timerConfig = {
        OnCalendar = "Daily";
        RandomizedDelaySec = "1800s";
        Persistent = true;
      };
      wantedBy = [ "timers.target" ];
      restartTriggers = [ cfg.package ];
    };

    services.nginx = mkIf cfg.enableNginx {
      enable = true;
      recommendedTlsSettings = mkDefault true;
      recommendedOptimisation = mkDefault true;
      recommendedGzipSettings = mkDefault true;
      virtualHosts.${cfg.virtualHost} = {
        root = "${cfg.package}/public";
        locations = {
          "/" = {
            tryFiles = "$uri $uri/ /index.php?$query_string";
            index = "index.php";
            extraConfig = ''
              sendfile off;
            '';
          };
          "~ \.php$" = {
            extraConfig = ''
              include ${config.services.nginx.package}/conf/fastcgi_params ;
              fastcgi_param SCRIPT_FILENAME $request_filename;
              fastcgi_param modHeadersAvailable true; #Avoid sending the security headers twice
              fastcgi_pass unix:${config.services.phpfpm.pools.firefly-iii.socket};
            '';
          };
        };
      };
    };

    systemd.tmpfiles.settings."10-firefly-iii" = genAttrs [
      "${cfg.dataDir}/storage"
      "${cfg.dataDir}/storage/app"
      "${cfg.dataDir}/storage/database"
      "${cfg.dataDir}/storage/export"
      "${cfg.dataDir}/storage/framework"
      "${cfg.dataDir}/storage/framework/cache"
      "${cfg.dataDir}/storage/framework/sessions"
      "${cfg.dataDir}/storage/framework/views"
      "${cfg.dataDir}/storage/logs"
      "${cfg.dataDir}/storage/upload"
      "${cfg.dataDir}/cache"
    ] (n: {
      d = {
        group = group;
        mode = "0700";
        user = user;
      };
    }) // {
      "${cfg.dataDir}".d = {
        group = group;
        mode = "0710";
        user = user;
      };
    };

    users = {
      users = mkIf (user == defaultUser) {
        ${defaultUser} = {
          description = "Firefly-iii service user";
          inherit group;
          isSystemUser = true;
          home = cfg.dataDir;
        };
      };
      groups = mkIf (group == defaultGroup) {
        ${defaultGroup} = {};
      };
    };
  };
}
