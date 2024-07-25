{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.davis;
  db = cfg.database;
  mail = cfg.mail;

  mysqlLocal = db.createLocally && db.driver == "mysql";
  pgsqlLocal = db.createLocally && db.driver == "postgresql";

  user = cfg.user;
  group = cfg.group;

  isSecret = v: lib.isAttrs v && v ? _secret && (lib.isString v._secret || builtins.isPath v._secret);
  davisEnvVars = lib.generators.toKeyValue {
    mkKeyValue = lib.flip lib.generators.mkKeyValueDefault "=" {
      mkValueString =
        v:
        if builtins.isInt v then
          toString v
        else if lib.isString v then
          "\"${v}\""
        else if true == v then
          "true"
        else if false == v then
          "false"
        else if null == v then
          ""
        else if isSecret v then
          if (lib.isString v._secret) then
            builtins.hashString "sha256" v._secret
          else
            builtins.hashString "sha256" (builtins.readFile v._secret)
        else
          throw "unsupported type ${builtins.typeOf v}: ${(lib.generators.toPretty { }) v}";
    };
  };
  secretPaths = lib.mapAttrsToList (_: v: v._secret) (lib.filterAttrs (_: isSecret) cfg.config);
  mkSecretReplacement = file: ''
    replace-secret ${
      lib.escapeShellArgs [
        (
          if (lib.isString file) then
            builtins.hashString "sha256" file
          else
            builtins.hashString "sha256" (builtins.readFile file)
        )
        file
        "${cfg.dataDir}/.env.local"
      ]
    }
  '';
  secretReplacements = lib.concatMapStrings mkSecretReplacement secretPaths;
  filteredConfig = lib.converge (lib.filterAttrsRecursive (
    _: v:
    !lib.elem v [
      { }
      null
    ]
  )) cfg.config;
  davisEnv = pkgs.writeText "davis.env" (davisEnvVars filteredConfig);
in
{
  options.services.davis = {
    enable = lib.mkEnableOption "Davis is a caldav and carddav server";

    user = lib.mkOption {
      default = "davis";
      description = "User davis runs as.";
      type = lib.types.str;
    };

    group = lib.mkOption {
      default = "davis";
      description = "Group davis runs as.";
      type = lib.types.str;
    };

    package = lib.mkPackageOption pkgs "davis" { };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/davis";
      description = ''
        Davis data directory.
      '';
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      example = "davis.yourdomain.org";
      description = ''
        Domain of the host to serve davis under. You may want to change it if you
        run Davis on a different URL than davis.yourdomain.
      '';
    };

    config = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.nullOr (
          lib.types.either
            (lib.types.oneOf [
              lib.types.bool
              lib.types.int
              lib.types.port
              lib.types.path
              lib.types.str
            ])
            (
              lib.types.submodule {
                options = {
                  _secret = lib.mkOption {
                    type = lib.types.nullOr (
                      lib.types.oneOf [
                        lib.types.str
                        lib.types.path
                      ]
                    );
                    description = ''
                      The path to a file containing the value the
                      option should be set to in the final
                      configuration file.
                    '';
                  };
                };
              }
            )
        )
      );
      default = { };

      example = '''';
      description = '''';
    };

    adminLogin = lib.mkOption {
      type = lib.types.str;
      default = "root";
      description = ''
        Username for the admin account.
      '';
    };
    adminPasswordFile = lib.mkOption {
      type = lib.types.path;
      description = ''
        The full path to a file that contains the admin's password. Must be
        readable by the user.
      '';
      example = "/run/secrets/davis-admin-pass";
    };

    appSecretFile = lib.mkOption {
      type = lib.types.path;
      description = ''
        A file containing the Symfony APP_SECRET - Its value should be a series
        of characters, numbers and symbols chosen randomly and the recommended
        length is around 32 characters. Can be generated with <code>cat
        /dev/urandom | tr -dc a-zA-Z0-9 | fold -w 48 | head -n 1</code>.
      '';
      example = "/run/secrets/davis-appsecret";
    };

    database = {
      driver = lib.mkOption {
        type = lib.types.enum [
          "sqlite"
          "postgresql"
          "mysql"
        ];
        default = "sqlite";
        description = "Database type, required in all circumstances.";
      };
      urlFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/run/secrets/davis-db-url";
        description = ''
          A file containing the database connection url. If set then it
          overrides all other database settings (except driver). This is
          mandatory if you want to use an external database, that is when
          `services.davis.database.createLocally` is `false`.
        '';
      };
      name = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "davis";
        description = "Database name, only used when the databse is created locally.";
      };
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Create the database and database user locally.";
      };
    };

    mail = {
      dsn = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Mail DSN for sending emails. Mutually exclusive with `services.davis.mail.dsnFile`.";
        example = "smtp://username:password@example.com:25";
      };
      dsnFile = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "/run/secrets/davis-mail-dsn";
        description = "A file containing the mail DSN for sending emails.  Mutually exclusive with `servies.davis.mail.dsn`.";
      };
      inviteFromAddress = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Email address to send invitations from.";
        example = "no-reply@dav.example.com";
      };
    };

    nginx = lib.mkOption {
      type = lib.types.submodule (
        lib.recursiveUpdate (import ../web-servers/nginx/vhost-options.nix { inherit config lib; }) { }
      );
      default = null;
      example = ''
        {
          serverAliases = [
            "dav.''${config.networking.domain}"
          ];
          # To enable encryption and let let's encrypt take care of certificate
          forceSSL = true;
          enableACME = true;
        }
      '';
      description = ''
        With this option, you can customize the nginx virtualHost settings.
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
      default = {
        "pm" = "dynamic";
        "pm.max_children" = 32;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 2;
        "pm.max_spare_servers" = 4;
        "pm.max_requests" = 500;
      };
      description = ''
        Options for the davis PHP pool. See the documentation on <literal>php-fpm.conf</literal>
        for details on configuration directives.
      '';
    };
  };

  config =
    let
      defaultServiceConfig = {
        ReadWritePaths = "${cfg.dataDir}";
        User = user;
        UMask = 77;
        DeviceAllow = "";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@resources"
          "~@privileged"
        ];
        WorkingDirectory = "${cfg.package}/";
      };
    in
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = db.createLocally -> db.urlFile == null;
          message = "services.davis.database.urlFile must be unset if services.davis.database.createLocally is set true.";
        }
        {
          assertion = db.createLocally || db.urlFile != null;
          message = "One of services.davis.database.urlFile or services.davis.database.createLocally must be set.";
        }
        {
          assertion = (mail.dsn != null) != (mail.dsnFile != null);
          message = "One of (and only one of) services.davis.mail.dsn or services.davis.mail.dsnFile must be set.";
        }
      ];
      services.davis.config =
        {
          APP_ENV = "prod";
          APP_CACHE_DIR = "${cfg.dataDir}/var/cache";
          # note: we do not need the log dir (we log to stdout/journald), by davis/symfony will try to create it, and the default value is one in the nix-store
          #       so we set it to a path under dataDir to avoid something like: Unable to create the "logs" directory (/nix/store/5cfskz0ybbx37s1161gjn5klwb5si1zg-davis-4.4.1/var/log).
          APP_LOG_DIR = "${cfg.dataDir}/var/log";
          LOG_FILE_PATH = "/dev/stdout";
          DATABASE_DRIVER = db.driver;
          INVITE_FROM_ADDRESS = mail.inviteFromAddress;
          APP_SECRET._secret = cfg.appSecretFile;
          ADMIN_LOGIN = cfg.adminLogin;
          ADMIN_PASSWORD._secret = cfg.adminPasswordFile;
          APP_TIMEZONE = config.time.timeZone;
          WEBDAV_ENABLED = false;
          CALDAV_ENABLED = true;
          CARDDAV_ENABLED = true;
        }
        // (if mail.dsn != null then { MAILER_DSN = mail.dsn; } else { MAILER_DSN._secret = mail.dsnFile; })
        // (
          if db.createLocally then
            {
              DATABASE_URL =
                if db.driver == "sqlite" then
                  "sqlite:///${cfg.dataDir}/davis.db" # note: sqlite needs 4 slashes for an absolute path
                else if
                  pgsqlLocal
                # note: davis expects a non-standard postgres uri (due to the underlying doctrine library)
                # specifically the dummy hostname which is overriden by the host query parameter
                then
                  "postgres://${user}@localhost/${db.name}?host=/run/postgresql"
                else if mysqlLocal then
                  "mysql://${user}@localhost/${db.name}?socket=/run/mysqld/mysqld.sock"
                else
                  null;
            }
          else
            { DATABASE_URL._secret = db.urlFile; }
        );

      users = {
        users = lib.mkIf (user == "davis") {
          davis = {
            description = "Davis service user";
            group = cfg.group;
            isSystemUser = true;
            home = cfg.dataDir;
          };
        };
        groups = lib.mkIf (group == "davis") { davis = { }; };
      };

      systemd.tmpfiles.rules = [
        "d ${cfg.dataDir}                            0710 ${user} ${group} - -"
        "d ${cfg.dataDir}/var                        0700 ${user} ${group} - -"
        "d ${cfg.dataDir}/var/log                    0700 ${user} ${group} - -"
        "d ${cfg.dataDir}/var/cache                  0700 ${user} ${group} - -"
      ];

      services.phpfpm.pools.davis = {
        inherit user group;
        phpOptions = ''
          log_errors = on
        '';
        phpEnv = {
          ENV_DIR = "${cfg.dataDir}";
          APP_CACHE_DIR = "${cfg.dataDir}/var/cache";
          APP_LOG_DIR = "${cfg.dataDir}/var/log";
        };
        settings =
          {
            "listen.mode" = "0660";
            "pm" = "dynamic";
            "pm.max_children" = 256;
            "pm.start_servers" = 10;
            "pm.min_spare_servers" = 5;
            "pm.max_spare_servers" = 20;
          }
          // (
            if cfg.nginx != null then
              {
                "listen.owner" = config.services.nginx.user;
                "listen.group" = config.services.nginx.group;
              }
            else
              { }
          )
          // cfg.poolConfig;
      };

      # Reading the user-provided secret files requires root access
      systemd.services.davis-env-setup = {
        description = "Setup davis environment";
        before = [
          "phpfpm-davis.service"
          "davis-db-migrate.service"
        ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        path = [ pkgs.replace-secret ];
        restartTriggers = [
          cfg.package
          davisEnv
        ];
        script = ''
          # error handling
          set -euo pipefail
          # create .env file with the upstream values
          install -T -m 0600 -o ${user} ${cfg.package}/env-upstream "${cfg.dataDir}/.env"
          # create .env.local file with the user-provided values
          install -T -m 0600 -o ${user} ${davisEnv} "${cfg.dataDir}/.env.local"
          ${secretReplacements}
        '';
      };

      systemd.services.davis-db-migrate = {
        description = "Migrate davis database";
        before = [ "phpfpm-davis.service" ];
        after =
          lib.optional mysqlLocal "mysql.service"
          ++ lib.optional pgsqlLocal "postgresql.service"
          ++ [ "davis-env-setup.service" ];
        requires =
          lib.optional mysqlLocal "mysql.service"
          ++ lib.optional pgsqlLocal "postgresql.service"
          ++ [ "davis-env-setup.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = defaultServiceConfig // {
          Type = "oneshot";
          RemainAfterExit = true;
          Environment = [
            "ENV_DIR=${cfg.dataDir}"
            "APP_CACHE_DIR=${cfg.dataDir}/var/cache"
            "APP_LOG_DIR=${cfg.dataDir}/var/log"
          ];
          EnvironmentFile = "${cfg.dataDir}/.env.local";
        };
        restartTriggers = [
          cfg.package
          davisEnv
        ];
        script = ''
          set -euo pipefail
          ${cfg.package}/bin/console cache:clear --no-debug
          ${cfg.package}/bin/console cache:warmup --no-debug
          ${cfg.package}/bin/console doctrine:migrations:migrate
        '';
      };

      systemd.services.phpfpm-davis.after = [
        "davis-env-setup.service"
        "davis-db-migrate.service"
      ];
      systemd.services.phpfpm-davis.requires = [
        "davis-env-setup.service"
        "davis-db-migrate.service"
      ] ++ lib.optional mysqlLocal "mysql.service" ++ lib.optional pgsqlLocal "postgresql.service";
      systemd.services.phpfpm-davis.serviceConfig.ReadWritePaths = [ cfg.dataDir ];

      services.nginx = lib.mkIf (cfg.nginx != null) {
        enable = lib.mkDefault true;
        virtualHosts = {
          "${cfg.hostname}" = lib.mkMerge [
            cfg.nginx
            {
              root = lib.mkForce "${cfg.package}/public";
              extraConfig = ''
                charset utf-8;
                index index.php;
              '';
              locations = {
                "/" = {
                  extraConfig = ''
                    try_files $uri $uri/ /index.php$is_args$args;
                  '';
                };
                "~* ^/.well-known/(caldav|carddav)$" = {
                  extraConfig = ''
                    return 302 $http_x_forwarded_proto://$host/dav/;
                  '';
                };
                "~ ^(.+\.php)(.*)$" = {
                  extraConfig = ''
                    try_files                $fastcgi_script_name =404;
                    include                  ${config.services.nginx.package}/conf/fastcgi_params;
                    include                  ${config.services.nginx.package}/conf/fastcgi.conf;
                    fastcgi_pass             unix:${config.services.phpfpm.pools.davis.socket};
                    fastcgi_param            SCRIPT_FILENAME  $document_root$fastcgi_script_name;
                    fastcgi_param            PATH_INFO        $fastcgi_path_info;
                    fastcgi_split_path_info  ^(.+\.php)(.*)$;
                    fastcgi_param            X-Forwarded-Proto $http_x_forwarded_proto;
                    fastcgi_param            X-Forwarded-Port $http_x_forwarded_port;
                  '';
                };
                "~ /(\\.ht)" = {
                  extraConfig = ''
                    deny all;
                    return 404;
                  '';
                };
              };
            }
          ];
        };
      };

      services.mysql = lib.mkIf mysqlLocal {
        enable = true;
        package = lib.mkDefault pkgs.mariadb;
        ensureDatabases = [ db.name ];
        ensureUsers = [
          {
            name = user;
            ensurePermissions = {
              "${db.name}.*" = "ALL PRIVILEGES";
            };
          }
        ];
      };

      services.postgresql = lib.mkIf pgsqlLocal {
        enable = true;
        ensureDatabases = [ db.name ];
        ensureUsers = [
          {
            name = user;
            ensureDBOwnership = true;
          }
        ];
      };
    };

  meta = {
    doc = ./davis.md;
    maintainers = pkgs.davis.meta.maintainers;
  };
}
