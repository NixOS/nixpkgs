{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.services.firefly-pico;

  user = cfg.user;
  group = cfg.group;

  defaultUser = "firefly-pico";
  defaultGroup = "firefly-pico";

  artisan = "${cfg.package}/share/php/firefly-pico/artisan";

  env-file-values = lib.attrsets.mapAttrs' (
    n: v: lib.attrsets.nameValuePair (lib.strings.removeSuffix "_FILE" n) v
  ) (lib.attrsets.filterAttrs (n: v: lib.strings.hasSuffix "_FILE" n) cfg.settings);
  env-nonfile-values = lib.attrsets.filterAttrs (n: v: !lib.strings.hasSuffix "_FILE" n) cfg.settings;

  firefly-pico-maintenance = pkgs.writeShellScript "firefly-pico-maintenance.sh" ''
    set -a
    ${lib.strings.toShellVars env-nonfile-values}
    ${lib.strings.concatLines (
      lib.attrsets.mapAttrsToList (n: v: "${n}=\"$(< ${v})\"") env-file-values
    )}
    set +a
    ${lib.optionalString (
      cfg.settings.DB_CONNECTION == "sqlite"
    ) "touch ${cfg.dataDir}/storage/database/database.sqlite"}
    ${artisan} migrate --isolated --force
    ${artisan} config:clear
    ${artisan} config:cache
    ${artisan} cache:clear
  '';

  commonServiceConfig = {
    Type = "oneshot";
    User = user;
    Group = group;
    StateDirectory = "firefly-pico";
    ReadWritePaths = [ cfg.dataDir ];
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

in
{

  options.services.firefly-pico = {

    enable = lib.mkEnableOption "Firefly-Pico: A delightful Firefly III companion web app for effortless transaction tracking";

    user = lib.mkOption {
      type = lib.types.str;
      default = defaultUser;
      description = "User account under which firefly-pico runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = if cfg.enableNginx then "nginx" else defaultGroup;
      defaultText = "If `services.firefly-pico.enableNginx` is true then `nginx` else ${defaultGroup}";
      description = ''
        Group under which firefly-pico runs. It is best to set this to the group
        of whatever webserver is being used as the frontend.
      '';
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/firefly-pico";
      description = ''
        The place where firefly-pico stores its state.
      '';
    };

    package =
      lib.mkPackageOption pkgs "firefly-pico" { }
      // lib.mkOption {
        apply =
          firefly-pico:
          firefly-pico.override (prev: {
            dataDir = cfg.dataDir;
          });
      };

    enableNginx = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to enable nginx or not. If enabled, an nginx virtual host will
        be created for access to firefly-pico. If not enabled, then you may use
        `''${config.services.firefly-pico.package}` as your document root in
        whichever webserver you wish to setup.
      '';
    };

    virtualHost = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      description = ''
        The hostname at which you wish firefly-pico to be served. If you have
        enabled nginx using `services.firefly-pico.enableNginx` then this will
        be used.
      '';
    };

    poolConfig = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.oneOf [
          lib.types.str
          lib.types.int
          lib.types.bool
        ]
      );
      default = { };
      defaultText = ''
        {
          "pm" = "dynamic";
          "pm.max_children" = 32;
          "pm.start_servers" = 2;
          "pm.min_spare_servers" = 2;
          "pm.max_spare_servers" = 4;
          "pm.max_requests" = 500;
        }
      '';
      description = ''
        Options for the Firefly-Pico PHP pool. See the documentation on <literal>php-fpm.conf</literal>
        for details on configuration directives.
      '';
    };

    settings = lib.mkOption {
      default = { };
      description = ''
        Options for firefly-Pico configuration. Refer to
        <https://github.com/cioraneanu/firefly-pico/blob/main/back/.env.example> for
        details on supported values. All <option>_FILE values supported by
        upstream are supported here.

        APP_URL will be the same as `services.firefly-pico.virtualHost` if the
        former is unset in `services.firefly-pico.settings`.
      '';
      example = lib.literalExpression ''
        {
          APP_ENV = "production";
          APP_KEY_FILE = "/var/secrets/firefly-pico-app-key.txt";
          DB_CONNECTION = "mysql";
          DB_HOST = "db";
          DB_PORT = 3306;
          DB_DATABASE = "firefly-pico";
          DB_USERNAME = "firefly-pico";
          DB_PASSWORD_FILE = "/var/secrets/firefly-pico-mysql-password.txt";
        }
      '';
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf (
          lib.types.oneOf [
            lib.types.str
            lib.types.int
            lib.types.bool
          ]
        );
        options = {
          LOG_CHANNEL = lib.mkOption {
            type = lib.types.str;
            default = "syslog";
            example = "single";
            description = ''
              The output channel for your firefly-pico backend logs.
              For available drivers see <https://laravel.com/docs/12.x/logging#available-channel-drivers>.
            '';
          };
          DB_CONNECTION = lib.mkOption {
            type = lib.types.enum [
              "sqlite"
              "pgsql"
              "mysql"
            ];
            default = "sqlite";
            example = "pgsql";
            description = ''
              The type of database you wish to use. Can be one of "sqlite",
              "mysql" or "pgsql".
            '';
          };
          APP_ENV = lib.mkOption {
            type = lib.types.enum [
              "local"
              "production"
              "testing"
            ];
            default = "local";
            example = "production";
            description = ''
              The app environment. It is recommended to keep this at "local".
              Possible values are "local", "production" and "testing"
            '';
          };
          DB_DATABASE = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default =
              if cfg.settings.DB_CONNECTION == "pgsql" then
                "firefly-pico"
              else if cfg.settings.DB_CONNECTION == "mysql" then
                "firefly-pico"
              else
                cfg.dataDir + "/storage/database/database.sqlite";
            defaultText = ''
              `cfg.dataDir + "/storage/database/database.sqlite` if DB_CONNECTION is "sqlite", `firefly-pico` if "mysql" or "pgsql"
            '';
            description = ''
              The absolute path to, in case of sqlite, or name of your firefly-pico database.
            '';
          };
          DB_PORT = lib.mkOption {
            type = lib.types.nullOr lib.types.int;
            default =
              if cfg.settings.DB_CONNECTION == "pgsql" then
                5432
              else if cfg.settings.DB_CONNECTION == "mysql" then
                3306
              else
                null;
            defaultText = ''
              `null` if DB_CONNECTION is "sqlite", `3306` if "mysql", `5432` if "pgsql"
            '';
            description = ''
              The port your database is listening at. sqlite does not require
              this value to be filled.
            '';
          };
          DB_HOST = lib.mkOption {
            type = lib.types.str;
            default = if cfg.settings.DB_CONNECTION == "pgsql" then "/run/postgresql" else "localhost";
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
          APP_KEY_FILE = lib.mkOption {
            type = lib.types.path;
            description = ''
              The path to your appkey. The file should contain a 32 character
              random app key. This may be set using `echo "base64:$(head -c 32
              /dev/urandom | base64)" > /path/to/key-file`.
            '';
          };
          APP_URL = lib.mkOption {
            type = lib.types.str;
            default =
              if cfg.virtualHost == "localhost" then
                "http://${cfg.virtualHost}"
              else
                "https://${cfg.virtualHost}";
            defaultText = ''
              http(s)://''${config.services.firefly-pico.virtualHost}
            '';
            description = ''
              The APP_URL used by firefly-pico internally. Please make sure this
              URL matches the external URL of your Firefly pico installation.
            '';
          };
          FIREFLY_URL = lib.mkOption {
            type = lib.types.str;
            example = ''
              https://firefly.example
            '';
            description = ''
              The public URL of your firefly-iii api instance. Has to be reachable by the client
              opening firefly-pico.
            '';
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {

    services.phpfpm.pools.firefly-pico = {
      inherit user group;
      phpPackage = cfg.package.phpPackage;
      phpOptions = ''
        log_errors = on
      '';
      settings = {
        "listen.mode" = lib.mkDefault "0660";
        "listen.owner" = lib.mkDefault user;
        "listen.group" = lib.mkDefault group;
        "pm" = lib.mkDefault "dynamic";
        "pm.max_children" = lib.mkDefault 32;
        "pm.start_servers" = lib.mkDefault 2;
        "pm.min_spare_servers" = lib.mkDefault 2;
        "pm.max_spare_servers" = lib.mkDefault 4;
        "pm.max_requests" = lib.mkDefault 500;
      }
      // cfg.poolConfig;
    };

    systemd.services.firefly-pico-setup = {
      after = [
        "postgresql.service"
        "mysql.service"
      ];
      requiredBy = [ "phpfpm-firefly-pico.service" ];
      before = [ "phpfpm-firefly-pico.service" ];
      serviceConfig = {
        ExecStart = firefly-pico-maintenance;
        RemainAfterExit = true;
      }
      // commonServiceConfig;
      unitConfig.JoinsNamespaceOf = "phpfpm-firefly-pico.service";
      restartTriggers = [ cfg.package ];
      partOf = [ "phpfpm-firefly-pico.service" ];
    };

    services.nginx = lib.mkIf cfg.enableNginx {
      enable = true;
      recommendedTlsSettings = lib.mkDefault true;
      recommendedOptimisation = lib.mkDefault true;
      recommendedGzipSettings = lib.mkDefault true;
      virtualHosts.${cfg.virtualHost} = {
        root = "${cfg.package.frontend}/share/firefly-pico/public";
        locations = {
          "/api" = {
            root = "${cfg.package}/share/php/firefly-pico/public";
            tryFiles = "$uri $uri/ /index.php?$query_string";
            index = "index.php";
          };
          "~ \\.php$" = {
            root = "${cfg.package}/share/php/firefly-pico/public";
            extraConfig = ''
              include ${config.services.nginx.package}/conf/fastcgi_params ;
              fastcgi_param SCRIPT_FILENAME $request_filename;
              fastcgi_param modHeadersAvailable true; #Avoid sending the security headers twice
              fastcgi_pass unix:${config.services.phpfpm.pools.firefly-pico.socket};
            '';
          };
        };
      };
    };

    systemd.tmpfiles.settings."10-firefly-pico" =
      lib.attrsets.genAttrs
        [
          "${cfg.dataDir}/storage"
          "${cfg.dataDir}/storage/app"
          "${cfg.dataDir}/storage/database"
          "${cfg.dataDir}/storage/framework"
          "${cfg.dataDir}/storage/framework/cache"
          "${cfg.dataDir}/storage/framework/sessions"
          "${cfg.dataDir}/storage/framework/views"
          "${cfg.dataDir}/storage/logs"
          "${cfg.dataDir}/cache"
        ]
        (n: {
          d = {
            group = group;
            mode = "0700";
            user = user;
          };
        })
      // {
        "${cfg.dataDir}".d = {
          group = group;
          mode = "0710";
          user = user;
        };
      };

    users = {
      users = lib.mkIf (user == defaultUser) {
        ${defaultUser} = {
          description = "Firefly-pico service user";
          inherit group;
          isSystemUser = true;
          home = cfg.dataDir;
        };
      };
      groups = lib.mkIf (group == defaultGroup) { ${defaultGroup} = { }; };
    };
  };
}
