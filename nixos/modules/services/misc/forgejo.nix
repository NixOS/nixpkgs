{
  config,
  lib,
  options,
  pkgs,
  ...
}:

let
  cfg = config.services.forgejo;
  opt = options.services.forgejo;
  format = pkgs.formats.ini { };

  exe = lib.getExe cfg.package;

  pg = config.services.postgresql;
  useMysql = cfg.database.type == "mysql";
  usePostgresql = cfg.database.type == "postgres";
  useSqlite = cfg.database.type == "sqlite3";

  secrets =
    let
      mkSecret =
        section: values:
        lib.mapAttrsToList (key: value: {
          env = envEscape "FORGEJO__${section}__${key}__FILE";
          path = value;
        }) values;
      # https://codeberg.org/forgejo/forgejo/src/tag/v7.0.2/contrib/environment-to-ini/environment-to-ini.go
      envEscape =
        string: lib.replaceStrings [ "." "-" ] [ "_0X2E_" "_0X2D_" ] (lib.strings.toUpper string);
    in
    lib.flatten (lib.mapAttrsToList mkSecret cfg.secrets);

  inherit (lib)
    literalExpression
    mkChangedOptionModule
    mkDefault
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    mkRemovedOptionModule
    mkRenamedOptionModule
    optionalAttrs
    optionals
    optionalString
    types
    ;
in
{
  imports = [
    (mkRenamedOptionModule
      [ "services" "forgejo" "appName" ]
      [ "services" "forgejo" "settings" "DEFAULT" "APP_NAME" ]
    )
    (mkRemovedOptionModule [ "services" "forgejo" "extraConfig" ]
      "services.forgejo.extraConfig has been removed. Please use the freeform services.forgejo.settings option instead"
    )
    (mkRemovedOptionModule [ "services" "forgejo" "database" "password" ]
      "services.forgejo.database.password has been removed. Please use services.forgejo.database.passwordFile instead"
    )
    (mkRenamedOptionModule
      [ "services" "forgejo" "mailerPasswordFile" ]
      [ "services" "forgejo" "secrets" "mailer" "PASSWD" ]
    )

    # copied from services.gitea; remove at some point
    (mkRenamedOptionModule
      [ "services" "forgejo" "cookieSecure" ]
      [ "services" "forgejo" "settings" "session" "COOKIE_SECURE" ]
    )
    (mkRenamedOptionModule
      [ "services" "forgejo" "disableRegistration" ]
      [ "services" "forgejo" "settings" "service" "DISABLE_REGISTRATION" ]
    )
    (mkRenamedOptionModule
      [ "services" "forgejo" "domain" ]
      [ "services" "forgejo" "settings" "server" "DOMAIN" ]
    )
    (mkRenamedOptionModule
      [ "services" "forgejo" "httpAddress" ]
      [ "services" "forgejo" "settings" "server" "HTTP_ADDR" ]
    )
    (mkRenamedOptionModule
      [ "services" "forgejo" "httpPort" ]
      [ "services" "forgejo" "settings" "server" "HTTP_PORT" ]
    )
    (mkRenamedOptionModule
      [ "services" "forgejo" "log" "level" ]
      [ "services" "forgejo" "settings" "log" "LEVEL" ]
    )
    (mkRenamedOptionModule
      [ "services" "forgejo" "log" "rootPath" ]
      [ "services" "forgejo" "settings" "log" "ROOT_PATH" ]
    )
    (mkRenamedOptionModule
      [ "services" "forgejo" "rootUrl" ]
      [ "services" "forgejo" "settings" "server" "ROOT_URL" ]
    )
    (mkRenamedOptionModule
      [ "services" "forgejo" "ssh" "clonePort" ]
      [ "services" "forgejo" "settings" "server" "SSH_PORT" ]
    )
    (mkRenamedOptionModule
      [ "services" "forgejo" "staticRootPath" ]
      [ "services" "forgejo" "settings" "server" "STATIC_ROOT_PATH" ]
    )
    (mkChangedOptionModule
      [ "services" "forgejo" "enableUnixSocket" ]
      [ "services" "forgejo" "settings" "server" "PROTOCOL" ]
      (config: if config.services.forgejo.enableUnixSocket then "http+unix" else "http")
    )
    (mkRemovedOptionModule [ "services" "forgejo" "ssh" "enable" ]
      "services.forgejo.ssh.enable has been migrated into freeform setting services.forgejo.settings.server.DISABLE_SSH. Keep in mind that the setting is inverted"
    )
  ];

  options = {
    services.forgejo = {
      enable = mkEnableOption "Forgejo, a software forge";

      package = mkPackageOption pkgs "forgejo-lts" { };

      useWizard = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to use the built-in installation wizard instead of
          declaratively managing the {file}`app.ini` config file in nix.
        '';
      };

      stateDir = mkOption {
        default = "/var/lib/forgejo";
        type = types.str;
        description = "Forgejo data directory.";
      };

      customDir = mkOption {
        default = "${cfg.stateDir}/custom";
        defaultText = literalExpression ''"''${config.${opt.stateDir}}/custom"'';
        type = types.str;
        description = ''
          Base directory for custom templates and other options.

          If {option}`${opt.useWizard}` is disabled (default), this directory will also
          hold secrets and the resulting {file}`app.ini` config at runtime.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "forgejo";
        description = "User account under which Forgejo runs.";
      };

      group = mkOption {
        type = types.str;
        default = "forgejo";
        description = "Group under which Forgejo runs.";
      };

      database = {
        type = mkOption {
          type = types.enum [
            "sqlite3"
            "mysql"
            "postgres"
          ];
          example = "mysql";
          default = "sqlite3";
          description = "Database engine to use.";
        };

        host = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = "Database host address.";
        };

        port = mkOption {
          type = types.port;
          default = if usePostgresql then pg.settings.port else 3306;
          defaultText = literalExpression ''
            if config.${opt.database.type} != "postgresql"
            then 3306
            else 5432
          '';
          description = "Database host port.";
        };

        name = mkOption {
          type = types.str;
          default = "forgejo";
          description = "Database name.";
        };

        user = mkOption {
          type = types.str;
          default = "forgejo";
          description = "Database user.";
        };

        passwordFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          example = "/run/keys/forgejo-dbpassword";
          description = ''
            A file containing the password corresponding to
            {option}`${opt.database.user}`.
          '';
        };

        socket = mkOption {
          type = types.nullOr types.path;
          default =
            if (cfg.database.createDatabase && usePostgresql) then
              "/run/postgresql"
            else if (cfg.database.createDatabase && useMysql) then
              "/run/mysqld/mysqld.sock"
            else
              null;
          defaultText = literalExpression "null";
          example = "/run/mysqld/mysqld.sock";
          description = "Path to the unix socket file to use for authentication.";
        };

        path = mkOption {
          type = types.str;
          default = "${cfg.stateDir}/data/forgejo.db";
          defaultText = literalExpression ''"''${config.${opt.stateDir}}/data/forgejo.db"'';
          description = "Path to the sqlite3 database file.";
        };

        createDatabase = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to create a local database automatically.";
        };
      };

      dump = {
        enable = mkEnableOption "periodic dumps via the [built-in {command}`dump` command](https://forgejo.org/docs/latest/admin/command-line/#dump)";

        interval = mkOption {
          type = types.str;
          default = "04:31";
          example = "hourly";
          description = ''
            Run a Forgejo dump at this interval. Runs by default at 04:31 every day.

            The format is described in
            {manpage}`systemd.time(7)`.
          '';
        };

        backupDir = mkOption {
          type = types.str;
          default = "${cfg.stateDir}/dump";
          defaultText = literalExpression ''"''${config.${opt.stateDir}}/dump"'';
          description = "Path to the directory where the dump archives will be stored.";
        };

        type = mkOption {
          type = types.enum [
            "zip"
            "tar"
            "tar.sz"
            "tar.gz"
            "tar.xz"
            "tar.bz2"
            "tar.br"
            "tar.lz4"
            "tar.zst"
          ];
          default = "zip";
          description = "Archive format used to store the dump file.";
        };

        file = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Filename to be used for the dump. If `null` a default name is chosen by forgejo.";
          example = "forgejo-dump";
        };

        age = mkOption {
          type = types.str;
          default = "4w";
          example = "5d";
          description = ''
            Age of backup used to decide what files to delete when cleaning.
            If a file or directory is older than the current time minus the age field, it is deleted.

            The format is described in
            {manpage}`tmpfiles.d(5)`.
          '';
        };
      };

      lfs = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enables git-lfs support.";
        };

        contentDir = mkOption {
          type = types.str;
          default = "${cfg.stateDir}/data/lfs";
          defaultText = literalExpression ''"''${config.${opt.stateDir}}/data/lfs"'';
          description = "Where to store LFS files.";
        };
      };

      repositoryRoot = mkOption {
        type = types.str;
        default = "${cfg.stateDir}/repositories";
        defaultText = literalExpression ''"''${config.${opt.stateDir}}/repositories"'';
        description = "Path to the git repositories.";
      };

      settings = mkOption {
        default = { };
        description = ''
          Free-form settings written directly to the `app.ini` configfile file.
          Refer to <https://forgejo.org/docs/latest/admin/config-cheat-sheet/> for supported values.
        '';
        example = literalExpression ''
          {
            DEFAULT = {
              RUN_MODE = "dev";
            };
            "cron.sync_external_users" = {
              RUN_AT_START = true;
              SCHEDULE = "@every 24h";
              UPDATE_EXISTING = true;
            };
            mailer = {
              ENABLED = true;
              MAILER_TYPE = "sendmail";
              FROM = "do-not-reply@example.org";
              SENDMAIL_PATH = "''${pkgs.system-sendmail}/bin/sendmail";
            };
            other = {
              SHOW_FOOTER_VERSION = false;
            };
          }
        '';
        type = types.submodule {
          freeformType = format.type;
          options = {
            log = {
              ROOT_PATH = mkOption {
                default = "${cfg.stateDir}/log";
                defaultText = literalExpression ''"''${config.${opt.stateDir}}/log"'';
                type = types.str;
                description = "Root path for log files.";
              };
              LEVEL = mkOption {
                default = "Info";
                type = types.enum [
                  "Trace"
                  "Debug"
                  "Info"
                  "Warn"
                  "Error"
                  "Critical"
                ];
                description = "General log level.";
              };
            };

            server = {
              PROTOCOL = mkOption {
                type = types.enum [
                  "http"
                  "https"
                  "fcgi"
                  "http+unix"
                  "fcgi+unix"
                ];
                default = "http";
                description = ''Listen protocol. `+unix` means "over unix", not "in addition to."'';
              };

              HTTP_ADDR = mkOption {
                type = types.either types.str types.path;
                default =
                  if lib.hasSuffix "+unix" cfg.settings.server.PROTOCOL then
                    "/run/forgejo/forgejo.sock"
                  else
                    "0.0.0.0";
                defaultText = literalExpression ''if lib.hasSuffix "+unix" cfg.settings.server.PROTOCOL then "/run/forgejo/forgejo.sock" else "0.0.0.0"'';
                description = "Listen address. Must be a path when using a unix socket.";
              };

              HTTP_PORT = mkOption {
                type = types.port;
                default = 3000;
                description = "Listen port. Ignored when using a unix socket.";
              };

              DOMAIN = mkOption {
                type = types.str;
                default = "localhost";
                description = "Domain name of your server.";
              };

              ROOT_URL = mkOption {
                type = types.str;
                default = "http://${cfg.settings.server.DOMAIN}:${toString cfg.settings.server.HTTP_PORT}/";
                defaultText = literalExpression ''"http://''${config.services.forgejo.settings.server.DOMAIN}:''${toString config.services.forgejo.settings.server.HTTP_PORT}/"'';
                description = "Full public URL of Forgejo server.";
              };

              STATIC_ROOT_PATH = mkOption {
                type = types.either types.str types.path;
                default = cfg.package.data;
                defaultText = literalExpression "config.${opt.package}.data";
                example = "/var/lib/forgejo/data";
                description = "Upper level of template and static files path.";
              };

              DISABLE_SSH = mkOption {
                type = types.bool;
                default = false;
                description = "Disable external SSH feature.";
              };

              SSH_PORT = mkOption {
                type = types.port;
                default = 22;
                example = 2222;
                description = ''
                  SSH port displayed in clone URL.
                  The option is required to configure a service when the external visible port
                  differs from the local listening port i.e. if port forwarding is used.
                '';
              };
            };

            session = {
              COOKIE_SECURE = mkOption {
                type = types.bool;
                default = false;
                description = ''
                  Marks session cookies as "secure" as a hint for browsers to only send
                  them via HTTPS. This option is recommend, if Forgejo is being served over HTTPS.
                '';
              };
            };
          };
        };
      };

      secrets = mkOption {
        default = { };
        description = ''
          This is a small wrapper over systemd's `LoadCredential`.

          It takes the same sections and keys as {option}`services.forgejo.settings`,
          but the value of each key is a path instead of a string or bool.

          The path is then loaded as credential, exported as environment variable
          and then feed through
          <https://codeberg.org/forgejo/forgejo/src/branch/forgejo/contrib/environment-to-ini/environment-to-ini.go>.

          It does the required environment variable escaping for you.

          ::: {.note}
          Keys specified here take priority over the ones in {option}`services.forgejo.settings`!
          :::
        '';
        example = literalExpression ''
          {
            metrics = {
              TOKEN = "/run/keys/forgejo-metrics-token";
            };
            camo = {
              HMAC_KEY = "/run/keys/forgejo-camo-hmac";
            };
            service = {
              HCAPTCHA_SECRET = "/run/keys/forgejo-hcaptcha-secret";
              HCAPTCHA_SITEKEY = "/run/keys/forgejo-hcaptcha-sitekey";
            };
          }
        '';
        type = types.submodule {
          freeformType = with types; attrsOf (attrsOf path);
          options = { };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.database.createDatabase -> useSqlite || cfg.database.user == cfg.user;
        message = "services.forgejo.database.user must match services.forgejo.user if the database is to be automatically provisioned";
      }
      {
        assertion = cfg.database.createDatabase && usePostgresql -> cfg.database.user == cfg.database.name;
        message = ''
          When creating a database via NixOS, the db user and db name must be equal!
          If you already have an existing DB+user and this assertion is new, you can safely set
          `services.forgejo.createDatabase` to `false` because removal of `ensureUsers`
          and `ensureDatabases` doesn't have any effect.
        '';
      }
    ];

    services.forgejo.settings = {
      DEFAULT = {
        RUN_MODE = mkDefault "prod";
        RUN_USER = mkDefault cfg.user;
        WORK_PATH = mkDefault cfg.stateDir;
      };

      database = mkMerge [
        {
          DB_TYPE = cfg.database.type;
        }
        (mkIf (useMysql || usePostgresql) {
          HOST =
            if cfg.database.socket != null then
              cfg.database.socket
            else
              cfg.database.host + ":" + toString cfg.database.port;
          NAME = cfg.database.name;
          USER = cfg.database.user;
        })
        (mkIf useSqlite {
          PATH = cfg.database.path;
        })
        (mkIf usePostgresql {
          SSL_MODE = "disable";
        })
      ];

      repository = {
        ROOT = cfg.repositoryRoot;
      };

      server = mkIf cfg.lfs.enable {
        LFS_START_SERVER = true;
      };

      session = {
        COOKIE_NAME = mkDefault "session";
      };

      security = {
        INSTALL_LOCK = true;
      };

      lfs = mkIf cfg.lfs.enable {
        PATH = cfg.lfs.contentDir;
      };
    };

    services.forgejo.secrets = {
      security = {
        SECRET_KEY = "${cfg.customDir}/conf/secret_key";
        INTERNAL_TOKEN = "${cfg.customDir}/conf/internal_token";
      };

      oauth2 = {
        JWT_SECRET = "${cfg.customDir}/conf/oauth2_jwt_secret";
      };

      database = mkIf (cfg.database.passwordFile != null) {
        PASSWD = cfg.database.passwordFile;
      };

      server = mkIf cfg.lfs.enable {
        LFS_JWT_SECRET = "${cfg.customDir}/conf/lfs_jwt_secret";
      };
    };

    services.postgresql = optionalAttrs (usePostgresql && cfg.database.createDatabase) {
      enable = mkDefault true;

      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensureDBOwnership = true;
        }
      ];
    };

    services.mysql = optionalAttrs (useMysql && cfg.database.createDatabase) {
      enable = mkDefault true;
      package = mkDefault pkgs.mariadb;

      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensurePermissions = {
            "${cfg.database.name}.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    systemd.tmpfiles.rules = [
      "d '${cfg.dump.backupDir}' 0750 ${cfg.user} ${cfg.group} ${cfg.dump.age} -"
      "z '${cfg.dump.backupDir}' 0750 ${cfg.user} ${cfg.group} - -"
      "d '${cfg.repositoryRoot}' 0750 ${cfg.user} ${cfg.group} - -"
      "z '${cfg.repositoryRoot}' 0750 ${cfg.user} ${cfg.group} - -"
      "d '${cfg.stateDir}' 0750 ${cfg.user} ${cfg.group} - -"
      "d '${cfg.stateDir}/conf' 0750 ${cfg.user} ${cfg.group} - -"
      "d '${cfg.customDir}' 0750 ${cfg.user} ${cfg.group} - -"
      "d '${cfg.customDir}/conf' 0750 ${cfg.user} ${cfg.group} - -"
      "d '${cfg.stateDir}/data' 0750 ${cfg.user} ${cfg.group} - -"
      "d '${cfg.stateDir}/log' 0750 ${cfg.user} ${cfg.group} - -"
      "z '${cfg.stateDir}' 0750 ${cfg.user} ${cfg.group} - -"
      "z '${cfg.stateDir}/.ssh' 0700 ${cfg.user} ${cfg.group} - -"
      "z '${cfg.stateDir}/conf' 0750 ${cfg.user} ${cfg.group} - -"
      "z '${cfg.customDir}' 0750 ${cfg.user} ${cfg.group} - -"
      "z '${cfg.customDir}/conf' 0750 ${cfg.user} ${cfg.group} - -"
      "z '${cfg.stateDir}/data' 0750 ${cfg.user} ${cfg.group} - -"
      "z '${cfg.stateDir}/log' 0750 ${cfg.user} ${cfg.group} - -"

      # If we have a folder or symlink with Forgejo locales, remove it
      # And symlink the current Forgejo locales in place
      "L+ '${cfg.stateDir}/conf/locale' - - - - ${cfg.package.out}/locale"

    ]
    ++ optionals cfg.lfs.enable [
      "d '${cfg.lfs.contentDir}' 0750 ${cfg.user} ${cfg.group} - -"
      "z '${cfg.lfs.contentDir}' 0750 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.forgejo-secrets = mkIf (!cfg.useWizard) {
      description = "Forgejo secret bootstrap helper";
      script = ''
        if [ ! -s '${cfg.secrets.security.SECRET_KEY}' ]; then
            ${exe} generate secret SECRET_KEY > '${cfg.secrets.security.SECRET_KEY}'
        fi

        if [ ! -s '${cfg.secrets.oauth2.JWT_SECRET}' ]; then
            ${exe} generate secret JWT_SECRET > '${cfg.secrets.oauth2.JWT_SECRET}'
        fi

        ${optionalString cfg.lfs.enable ''
          if [ ! -s '${cfg.secrets.server.LFS_JWT_SECRET}' ]; then
              ${exe} generate secret LFS_JWT_SECRET > '${cfg.secrets.server.LFS_JWT_SECRET}'
          fi
        ''}

        if [ ! -s '${cfg.secrets.security.INTERNAL_TOKEN}' ]; then
            ${exe} generate secret INTERNAL_TOKEN > '${cfg.secrets.security.INTERNAL_TOKEN}'
        fi
      '';
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = cfg.user;
        Group = cfg.group;
        ReadWritePaths = [ cfg.customDir ];
        UMask = "0077";
      };
    };

    systemd.services.forgejo = {
      description = "Forgejo (Beyond coding. We forge.)";
      after = [
        "network.target"
      ]
      ++ optionals usePostgresql [
        "postgresql.target"
      ]
      ++ optionals useMysql [
        "mysql.service"
      ]
      ++ optionals (!cfg.useWizard) [
        "forgejo-secrets.service"
      ];
      requires =
        optionals (cfg.database.createDatabase && usePostgresql) [
          "postgresql.target"
        ]
        ++ optionals (cfg.database.createDatabase && useMysql) [
          "mysql.service"
        ]
        ++ optionals (!cfg.useWizard) [
          "forgejo-secrets.service"
        ];
      wantedBy = [ "multi-user.target" ];
      path = [
        cfg.package
        pkgs.git
        pkgs.gnupg
      ];

      # In older versions the secret naming for JWT was kind of confusing.
      # The file jwt_secret hold the value for LFS_JWT_SECRET and JWT_SECRET
      # wasn't persistent at all.
      # To fix that, there is now the file oauth2_jwt_secret containing the
      # values for JWT_SECRET and the file jwt_secret gets renamed to
      # lfs_jwt_secret.
      # We have to consider this to stay compatible with older installations.
      preStart = ''
        ${optionalString (!cfg.useWizard) ''
          function forgejo_setup {
            config='${cfg.customDir}/conf/app.ini'
            cp -f '${format.generate "app.ini" cfg.settings}' "$config"

            chmod u+w "$config"
            ${lib.getExe' cfg.package "environment-to-ini"} --config "$config"
            chmod u-w "$config"
          }
          (umask 027; forgejo_setup)
        ''}

        # run migrations/init the database
        ${exe} migrate

        # update all hooks' binary paths
        ${exe} admin regenerate hooks

        # update command option in authorized_keys
        if [ -r ${cfg.stateDir}/.ssh/authorized_keys ]
        then
          ${exe} admin regenerate keys
        fi
      '';

      serviceConfig = {
        Type = "notify";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.stateDir;
        ExecStart = "${exe} web --pid /run/forgejo/forgejo.pid";
        Restart = "always";
        # Runtime directory and mode
        RuntimeDirectory = "forgejo";
        RuntimeDirectoryMode = "0755";
        # Proc filesystem
        ProcSubset = "pid";
        ProtectProc = "invisible";
        # Access write directories
        ReadWritePaths = [
          cfg.customDir
          cfg.dump.backupDir
          cfg.repositoryRoot
          cfg.stateDir
          cfg.lfs.contentDir
        ];
        UMask = "0027";
        # Capabilities
        CapabilityBoundingSet = "";
        # Security
        NoNewPrivileges = true;
        # Sandboxing
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        PrivateMounts = true;
        # System Call Filtering
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "~@cpu-emulation @debug @keyring @mount @obsolete @privileged @setuid"
          "setrlimit"
        ];
        # cfg.secrets
        LoadCredential = map (e: "${e.env}:${e.path}") secrets;
      };

      environment = {
        USER = cfg.user;
        HOME = cfg.stateDir;
        FORGEJO_WORK_DIR = cfg.stateDir;
        FORGEJO_CUSTOM = cfg.customDir;
      }
      // lib.listToAttrs (map (e: lib.nameValuePair e.env "%d/${e.env}") secrets);
    };

    services.openssh.settings.AcceptEnv = mkIf (
      !cfg.settings.server.START_SSH_SERVER or false
    ) "GIT_PROTOCOL";

    users.users = mkIf (cfg.user == "forgejo") {
      forgejo = {
        home = cfg.stateDir;
        useDefaultShell = true;
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.group == "forgejo") {
      forgejo = { };
    };

    systemd.services.forgejo-dump = mkIf cfg.dump.enable {
      description = "forgejo dump";
      after = [ "forgejo.service" ];
      path = [ cfg.package ];

      environment = {
        USER = cfg.user;
        HOME = cfg.stateDir;
        FORGEJO_WORK_DIR = cfg.stateDir;
        FORGEJO_CUSTOM = cfg.customDir;
      };

      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
        ExecStart =
          "${exe} dump --type ${cfg.dump.type}"
          + optionalString (cfg.dump.file != null) " --file ${cfg.dump.file}";
        WorkingDirectory = cfg.dump.backupDir;
      };
    };

    systemd.timers.forgejo-dump = mkIf cfg.dump.enable {
      description = "Forgejo dump timer";
      partOf = [ "forgejo-dump.service" ];
      wantedBy = [ "timers.target" ];
      timerConfig.OnCalendar = cfg.dump.interval;
    };
  };

  meta.doc = ./forgejo.md;
  meta.maintainers = with lib.maintainers; [
    bendlas
    emilylange
    pyrox0
  ];
}
