{ config, lib, options, pkgs, ... }:

let
  cfg = config.services.gitea;
  opt = options.services.gitea;
  exe = lib.getExe cfg.package;
  pg = config.services.postgresql;
  useMysql = cfg.database.type == "mysql";
  usePostgresql = cfg.database.type == "postgres";
  useSqlite = cfg.database.type == "sqlite3";
  format = pkgs.formats.ini { };
  configFile = pkgs.writeText "app.ini" ''
    APP_NAME = ${cfg.appName}
    RUN_USER = ${cfg.user}
    RUN_MODE = prod
    WORK_PATH = ${cfg.stateDir}

    ${lib.generators.toINI {} cfg.settings}

    ${lib.optionalString (cfg.extraConfig != null) cfg.extraConfig}
  '';
in

{
  imports = [
    (lib.mkRenamedOptionModule [ "services" "gitea" "cookieSecure" ] [ "services" "gitea" "settings" "session" "COOKIE_SECURE" ])
    (lib.mkRenamedOptionModule [ "services" "gitea" "disableRegistration" ] [ "services" "gitea" "settings" "service" "DISABLE_REGISTRATION" ])
    (lib.mkRenamedOptionModule [ "services" "gitea" "domain" ] [ "services" "gitea" "settings" "server" "DOMAIN" ])
    (lib.mkRenamedOptionModule [ "services" "gitea" "httpAddress" ] [ "services" "gitea" "settings" "server" "HTTP_ADDR" ])
    (lib.mkRenamedOptionModule [ "services" "gitea" "httpPort" ] [ "services" "gitea" "settings" "server" "HTTP_PORT" ])
    (lib.mkRenamedOptionModule [ "services" "gitea" "log" "level" ] [ "services" "gitea" "settings" "log" "LEVEL" ])
    (lib.mkRenamedOptionModule [ "services" "gitea" "log" "rootPath" ] [ "services" "gitea" "settings" "log" "ROOT_PATH" ])
    (lib.mkRenamedOptionModule [ "services" "gitea" "rootUrl" ] [ "services" "gitea" "settings" "server" "ROOT_URL" ])
    (lib.mkRenamedOptionModule [ "services" "gitea" "ssh" "clonePort" ] [ "services" "gitea" "settings" "server" "SSH_PORT" ])
    (lib.mkRenamedOptionModule [ "services" "gitea" "staticRootPath" ] [ "services" "gitea" "settings" "server" "STATIC_ROOT_PATH" ])

    (lib.mkChangedOptionModule [ "services" "gitea" "enableUnixSocket" ] [ "services" "gitea" "settings" "server" "PROTOCOL" ] (
      config: if config.services.gitea.enableUnixSocket then "http+unix" else "http"
    ))

    (lib.mkRemovedOptionModule [ "services" "gitea" "ssh" "enable" ] "services.gitea.ssh.enable has been migrated into freeform setting services.gitea.settings.server.DISABLE_SSH. Keep in mind that the setting is inverted")
  ];

  options = {
    services.gitea = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Enable Gitea Service.";
      };

      package = lib.mkPackageOption pkgs "gitea" { };

      useWizard = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Do not generate a configuration and use gitea' installation wizard instead. The first registered user will be administrator.";
      };

      stateDir = lib.mkOption {
        default = "/var/lib/gitea";
        type = lib.types.str;
        description = "Gitea data directory.";
      };

      customDir = lib.mkOption {
        default = "${cfg.stateDir}/custom";
        defaultText = lib.literalExpression ''"''${config.${opt.stateDir}}/custom"'';
        type = lib.types.str;
        description = "Gitea custom directory. Used for config, custom templates and other options.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "gitea";
        description = "User account under which gitea runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "gitea";
        description = "Group under which gitea runs.";
      };

      database = {
        type = lib.mkOption {
          type = lib.types.enum [ "sqlite3" "mysql" "postgres" ];
          example = "mysql";
          default = "sqlite3";
          description = "Database engine to use.";
        };

        host = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1";
          description = "Database host address.";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = if usePostgresql then pg.settings.port else 3306;
          defaultText = lib.literalExpression ''
            if config.${opt.database.type} != "postgresql"
            then 3306
            else 5432
          '';
          description = "Database host port.";
        };

        name = lib.mkOption {
          type = lib.types.str;
          default = "gitea";
          description = "Database name.";
        };

        user = lib.mkOption {
          type = lib.types.str;
          default = "gitea";
          description = "Database user.";
        };

        password = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = ''
            The password corresponding to {option}`database.user`.
            Warning: this is stored in cleartext in the Nix store!
            Use {option}`database.passwordFile` instead.
          '';
        };

        passwordFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          example = "/run/keys/gitea-dbpassword";
          description = ''
            A file containing the password corresponding to
            {option}`database.user`.
          '';
        };

        socket = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = if (cfg.database.createDatabase && usePostgresql) then "/run/postgresql" else if (cfg.database.createDatabase && useMysql) then "/run/mysqld/mysqld.sock" else null;
          defaultText = lib.literalExpression "null";
          example = "/run/mysqld/mysqld.sock";
          description = "Path to the unix socket file to use for authentication.";
        };

        path = lib.mkOption {
          type = lib.types.str;
          default = "${cfg.stateDir}/data/gitea.db";
          defaultText = lib.literalExpression ''"''${config.${opt.stateDir}}/data/gitea.db"'';
          description = "Path to the sqlite3 database file.";
        };

        createDatabase = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Whether to create a local database automatically.";
        };
      };

      dump = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Enable a timer that runs gitea dump to generate backup-files of the
            current gitea database and repositories.
          '';
        };

        interval = lib.mkOption {
          type = lib.types.str;
          default = "04:31";
          example = "hourly";
          description = ''
            Run a gitea dump at this interval. Runs by default at 04:31 every day.

            The format is described in
            {manpage}`systemd.time(7)`.
          '';
        };

        backupDir = lib.mkOption {
          type = lib.types.str;
          default = "${cfg.stateDir}/dump";
          defaultText = lib.literalExpression ''"''${config.${opt.stateDir}}/dump"'';
          description = "Path to the dump files.";
        };

        type = lib.mkOption {
          type = lib.types.enum [ "zip" "rar" "tar" "sz" "tar.gz" "tar.xz" "tar.bz2" "tar.br" "tar.lz4" "tar.zst" ];
          default = "zip";
          description = "Archive format used to store the dump file.";
        };

        file = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Filename to be used for the dump. If `null` a default name is chosen by gitea.";
          example = "gitea-dump";
        };
      };

      lfs = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enables git-lfs support.";
        };

        contentDir = lib.mkOption {
          type = lib.types.str;
          default = "${cfg.stateDir}/data/lfs";
          defaultText = lib.literalExpression ''"''${config.${opt.stateDir}}/data/lfs"'';
          description = "Where to store LFS files.";
        };
      };

      appName = lib.mkOption {
        type = lib.types.str;
        default = "gitea: Gitea Service";
        description = "Application name.";
      };

      repositoryRoot = lib.mkOption {
        type = lib.types.str;
        default = "${cfg.stateDir}/repositories";
        defaultText = lib.literalExpression ''"''${config.${opt.stateDir}}/repositories"'';
        description = "Path to the git repositories.";
      };

      camoHmacKeyFile = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "/var/lib/secrets/gitea/camoHmacKey";
        description = "Path to a file containing the camo HMAC key.";
      };

      mailerPasswordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "/var/lib/secrets/gitea/mailpw";
        description = "Path to a file containing the SMTP password.";
      };

      metricsTokenFile = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "/var/lib/secrets/gitea/metrics_token";
        description = "Path to a file containing the metrics authentication token.";
      };

      settings = lib.mkOption {
        default = {};
        description = ''
          Gitea configuration. Refer to <https://docs.gitea.io/en-us/config-cheat-sheet/>
          for details on supported values.
        '';
        example = lib.literalExpression ''
          {
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
        type = lib.types.submodule {
          freeformType = format.type;
          options = {
            log = {
              ROOT_PATH = lib.mkOption {
                default = "${cfg.stateDir}/log";
                defaultText = lib.literalExpression ''"''${config.${opt.stateDir}}/log"'';
                type = lib.types.str;
                description = "Root path for log files.";
              };
              LEVEL = lib.mkOption {
                default = "Info";
                type = lib.types.enum [ "Trace" "Debug" "Info" "Warn" "Error" "Critical" ];
                description = "General log level.";
              };
            };

            server = {
              PROTOCOL = lib.mkOption {
                type = lib.types.enum [ "http" "https" "fcgi" "http+unix" "fcgi+unix" ];
                default = "http";
                description = ''Listen protocol. `+unix` means "over unix", not "in addition to."'';
              };

              HTTP_ADDR = lib.mkOption {
                type = lib.types.either lib.types.str lib.types.path;
                default = if lib.hasSuffix "+unix" cfg.settings.server.PROTOCOL then "/run/gitea/gitea.sock" else "0.0.0.0";
                defaultText = lib.literalExpression ''if lib.hasSuffix "+unix" cfg.settings.server.PROTOCOL then "/run/gitea/gitea.sock" else "0.0.0.0"'';
                description = "Listen address. Must be a path when using a unix socket.";
              };

              HTTP_PORT = lib.mkOption {
                type = lib.types.port;
                default = 3000;
                description = "Listen port. Ignored when using a unix socket.";
              };

              DOMAIN = lib.mkOption {
                type = lib.types.str;
                default = "localhost";
                description = "Domain name of your server.";
              };

              ROOT_URL = lib.mkOption {
                type = lib.types.str;
                default = "http://${cfg.settings.server.DOMAIN}:${toString cfg.settings.server.HTTP_PORT}/";
                defaultText = lib.literalExpression ''"http://''${config.services.gitea.settings.server.DOMAIN}:''${toString config.services.gitea.settings.server.HTTP_PORT}/"'';
                description = "Full public URL of gitea server.";
              };

              STATIC_ROOT_PATH = lib.mkOption {
                type = lib.types.either lib.types.str lib.types.path;
                default = cfg.package.data;
                defaultText = lib.literalExpression "config.${opt.package}.data";
                example = "/var/lib/gitea/data";
                description = "Upper level of template and static files path.";
              };

              DISABLE_SSH = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Disable external SSH feature.";
              };

              SSH_PORT = lib.mkOption {
                type = lib.types.port;
                default = 22;
                example = 2222;
                description = ''
                  SSH port displayed in clone URL.
                  The option is required to configure a service when the external visible port
                  differs from the local listening port i.e. if port forwarding is used.
                '';
              };
            };

            service = {
              DISABLE_REGISTRATION = lib.mkEnableOption "the registration lock" // {
                description = ''
                  By default any user can create an account on this `gitea` instance.
                  This can be disabled by using this option.

                  *Note:* please keep in mind that this should be added after the initial
                  deploy unless [](#opt-services.gitea.useWizard)
                  is `true` as the first registered user will be the administrator if
                  no install wizard is used.
                '';
              };
            };

            session = {
              COOKIE_SECURE = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = ''
                  Marks session cookies as "secure" as a hint for browsers to only send
                  them via HTTPS. This option is recommend, if gitea is being served over HTTPS.
                '';
              };
            };
          };
        };
      };

      extraConfig = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = "Configuration lines appended to the generated gitea configuration file.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      { assertion = cfg.database.createDatabase -> useSqlite || cfg.database.user == cfg.user;
        message = "services.gitea.database.user must match services.gitea.user if the database is to be automatically provisioned";
      }
      { assertion = cfg.database.createDatabase && usePostgresql -> cfg.database.user == cfg.database.name;
        message = ''
          When creating a database via NixOS, the db user and db name must be equal!
          If you already have an existing DB+user and this assertion is new, you can safely set
          `services.gitea.createDatabase` to `false` because removal of `ensureUsers`
          and `ensureDatabases` doesn't have any effect.
        '';
      }
    ];

    services.gitea.settings = {
      "cron.update_checker".ENABLED = lib.mkDefault false;

      database = lib.mkMerge [
        {
          DB_TYPE = cfg.database.type;
        }
        (lib.mkIf (useMysql || usePostgresql) {
          HOST = if cfg.database.socket != null then cfg.database.socket else cfg.database.host + ":" + toString cfg.database.port;
          NAME = cfg.database.name;
          USER = cfg.database.user;
          PASSWD = "#dbpass#";
        })
        (lib.mkIf useSqlite {
          PATH = cfg.database.path;
        })
        (lib.mkIf usePostgresql {
          SSL_MODE = "disable";
        })
      ];

      repository = {
        ROOT = cfg.repositoryRoot;
      };

      server = lib.mkIf cfg.lfs.enable {
        LFS_START_SERVER = true;
        LFS_JWT_SECRET = "#lfsjwtsecret#";
      };

      camo = lib.mkIf (cfg.camoHmacKeyFile != null) {
        HMAC_KEY = "#hmackey#";
      };

      session = {
        COOKIE_NAME = lib.mkDefault "session";
      };

      security = {
        SECRET_KEY = "#secretkey#";
        INTERNAL_TOKEN = "#internaltoken#";
        INSTALL_LOCK = true;
      };

      mailer = lib.mkIf (cfg.mailerPasswordFile != null) {
        PASSWD = "#mailerpass#";
      };

      metrics = lib.mkIf (cfg.metricsTokenFile != null) {
        TOKEN = "#metricstoken#";
      };

      oauth2 = {
        JWT_SECRET = "#oauth2jwtsecret#";
      };

      lfs = lib.mkIf cfg.lfs.enable {
        PATH = cfg.lfs.contentDir;
      };

      packages.CHUNKED_UPLOAD_PATH = "${cfg.stateDir}/tmp/package-upload";
    };

    services.postgresql = lib.optionalAttrs (usePostgresql && cfg.database.createDatabase) {
      enable = lib.mkDefault true;

      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        { name = cfg.database.user;
          ensureDBOwnership = true;
        }
      ];
    };

    services.mysql = lib.optionalAttrs (useMysql && cfg.database.createDatabase) {
      enable = lib.mkDefault true;
      package = lib.mkDefault pkgs.mariadb;

      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        { name = cfg.database.user;
          ensurePermissions = { "${cfg.database.name}.*" = "ALL PRIVILEGES"; };
        }
      ];
    };

    systemd.tmpfiles.rules = [
      "d '${cfg.dump.backupDir}' 0750 ${cfg.user} ${cfg.group} - -"
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

      # If we have a folder or symlink with gitea locales, remove it
      # And symlink the current gitea locales in place
      "L+ '${cfg.stateDir}/conf/locale' - - - - ${cfg.package.out}/locale"

    ] ++ lib.optionals cfg.lfs.enable [
      "d '${cfg.lfs.contentDir}' 0750 ${cfg.user} ${cfg.group} - -"
      "z '${cfg.lfs.contentDir}' 0750 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.gitea = {
      description = "gitea";
      after = [ "network.target" ] ++ lib.optional usePostgresql "postgresql.service" ++ lib.optional useMysql "mysql.service";
      requires = lib.optional (cfg.database.createDatabase && usePostgresql) "postgresql.service" ++ lib.optional (cfg.database.createDatabase && useMysql) "mysql.service";
      wantedBy = [ "multi-user.target" ];
      path = [ cfg.package pkgs.git pkgs.gnupg ];

      # In older versions the secret naming for JWT was kind of confusing.
      # The file jwt_secret hold the value for LFS_JWT_SECRET and JWT_SECRET
      # wasn't persistent at all.
      # To fix that, there is now the file oauth2_jwt_secret containing the
      # values for JWT_SECRET and the file jwt_secret gets renamed to
      # lfs_jwt_secret.
      # We have to consider this to stay compatible with older installations.
      preStart = let
        runConfig = "${cfg.customDir}/conf/app.ini";
        secretKey = "${cfg.customDir}/conf/secret_key";
        oauth2JwtSecret = "${cfg.customDir}/conf/oauth2_jwt_secret";
        oldLfsJwtSecret = "${cfg.customDir}/conf/jwt_secret"; # old file for LFS_JWT_SECRET
        lfsJwtSecret = "${cfg.customDir}/conf/lfs_jwt_secret"; # new file for LFS_JWT_SECRET
        internalToken = "${cfg.customDir}/conf/internal_token";
        replaceSecretBin = "${pkgs.replace-secret}/bin/replace-secret";
      in ''
        # copy custom configuration and generate random secrets if needed
        ${lib.optionalString (!cfg.useWizard) ''
          function gitea_setup {
            cp -f '${configFile}' '${runConfig}'

            if [ ! -s '${secretKey}' ]; then
                ${exe} generate secret SECRET_KEY > '${secretKey}'
            fi

            # Migrate LFS_JWT_SECRET filename
            if [[ -s '${oldLfsJwtSecret}' && ! -s '${lfsJwtSecret}' ]]; then
                mv '${oldLfsJwtSecret}' '${lfsJwtSecret}'
            fi

            if [ ! -s '${oauth2JwtSecret}' ]; then
                ${exe} generate secret JWT_SECRET > '${oauth2JwtSecret}'
            fi

            ${lib.optionalString cfg.lfs.enable ''
            if [ ! -s '${lfsJwtSecret}' ]; then
                ${exe} generate secret LFS_JWT_SECRET > '${lfsJwtSecret}'
            fi
            ''}

            if [ ! -s '${internalToken}' ]; then
                ${exe} generate secret INTERNAL_TOKEN > '${internalToken}'
            fi

            chmod u+w '${runConfig}'
            ${replaceSecretBin} '#secretkey#' '${secretKey}' '${runConfig}'
            ${replaceSecretBin} '#dbpass#' '${cfg.database.passwordFile}' '${runConfig}'
            ${replaceSecretBin} '#oauth2jwtsecret#' '${oauth2JwtSecret}' '${runConfig}'
            ${replaceSecretBin} '#internaltoken#' '${internalToken}' '${runConfig}'

            ${lib.optionalString cfg.lfs.enable ''
              ${replaceSecretBin} '#lfsjwtsecret#' '${lfsJwtSecret}' '${runConfig}'
            ''}

            ${lib.optionalString (cfg.camoHmacKeyFile != null) ''
              ${replaceSecretBin} '#hmackey#' '${cfg.camoHmacKeyFile}' '${runConfig}'
            ''}

            ${lib.optionalString (cfg.mailerPasswordFile != null) ''
              ${replaceSecretBin} '#mailerpass#' '${cfg.mailerPasswordFile}' '${runConfig}'
            ''}

            ${lib.optionalString (cfg.metricsTokenFile != null) ''
              ${replaceSecretBin} '#metricstoken#' '${cfg.metricsTokenFile}' '${runConfig}'
            ''}
            chmod u-w '${runConfig}'
          }
          (umask 027; gitea_setup)
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
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.stateDir;
        ExecStart = "${exe} web --pid /run/gitea/gitea.pid";
        Restart = "always";
        # Runtime directory and mode
        RuntimeDirectory = "gitea";
        RuntimeDirectoryMode = "0755";
        # Proc filesystem
        ProcSubset = "pid";
        ProtectProc = "invisible";
        # Access write directories
        ReadWritePaths = [ cfg.customDir cfg.dump.backupDir cfg.repositoryRoot cfg.stateDir cfg.lfs.contentDir ];
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
        RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        PrivateMounts = true;
        # System Call Filtering
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "~@cpu-emulation @debug @keyring @mount @obsolete @privileged @setuid" "setrlimit" ];
      };

      environment = {
        USER = cfg.user;
        HOME = cfg.stateDir;
        GITEA_WORK_DIR = cfg.stateDir;
        GITEA_CUSTOM = cfg.customDir;
      };
    };

    users.users = lib.mkIf (cfg.user == "gitea") {
      gitea = {
        description = "Gitea Service";
        home = cfg.stateDir;
        useDefaultShell = true;
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = lib.mkIf (cfg.group == "gitea") {
      gitea = {};
    };

    warnings =
      lib.optional (cfg.database.password != "") "config.services.gitea.database.password will be stored as plaintext in the Nix store. Use database.passwordFile instead." ++
      lib.optional (cfg.extraConfig != null) ''
        services.gitea.`extraConfig` is deprecated, please use services.gitea.`settings`.
      '' ++
      lib.optional (lib.getName cfg.package == "forgejo") ''
        Running forgejo via services.gitea.package is no longer supported.
        Please use services.forgejo instead.
        See https://nixos.org/manual/nixos/unstable/#module-forgejo for migration instructions.
      '';

    # Create database passwordFile default when password is configured.
    services.gitea.database.passwordFile =
      lib.mkDefault (toString (pkgs.writeTextFile {
        name = "gitea-database-password";
        text = cfg.database.password;
      }));

    systemd.services.gitea-dump = lib.mkIf cfg.dump.enable {
       description = "gitea dump";
       after = [ "gitea.service" ];
       path = [ cfg.package ];

       environment = {
         USER = cfg.user;
         HOME = cfg.stateDir;
         GITEA_WORK_DIR = cfg.stateDir;
         GITEA_CUSTOM = cfg.customDir;
       };

       serviceConfig = {
         Type = "oneshot";
         User = cfg.user;
         ExecStart = "${exe} dump --type ${cfg.dump.type}" + lib.optionalString (cfg.dump.file != null) " --file ${cfg.dump.file}";
         WorkingDirectory = cfg.dump.backupDir;
       };
    };

    systemd.timers.gitea-dump = lib.mkIf cfg.dump.enable {
      description = "Update timer for gitea-dump";
      partOf = [ "gitea-dump.service" ];
      wantedBy = [ "timers.target" ];
      timerConfig.OnCalendar = cfg.dump.interval;
    };
  };
  meta.maintainers = with lib.maintainers; [ ma27 techknowlogick SuperSandro2000 ];
}
