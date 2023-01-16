{ config, lib, options, pkgs, ... }:

with lib;

let
  cfg = config.services.gitea;
  opt = options.services.gitea;
  gitea = cfg.package;
  pg = config.services.postgresql;
  useMysql = cfg.database.type == "mysql";
  usePostgresql = cfg.database.type == "postgres";
  useSqlite = cfg.database.type == "sqlite3";
  format = pkgs.formats.ini { };
  configFile = pkgs.writeText "app.ini" ''
    APP_NAME = ${cfg.appName}
    RUN_USER = ${cfg.user}
    RUN_MODE = prod

    ${generators.toINI {} cfg.settings}

    ${optionalString (cfg.extraConfig != null) cfg.extraConfig}
  '';
in

{
  imports = [
    (mkRenamedOptionModule [ "services" "gitea" "cookieSecure" ] [ "services" "gitea" "settings" "session" "COOKIE_SECURE" ])
    (mkRenamedOptionModule [ "services" "gitea" "disableRegistration" ] [ "services" "gitea" "settings" "service" "DISABLE_REGISTRATION" ])
    (mkRenamedOptionModule [ "services" "gitea" "log" "level" ] [ "services" "gitea" "settings" "log" "LEVEL" ])
    (mkRenamedOptionModule [ "services" "gitea" "log" "rootPath" ] [ "services" "gitea" "settings" "log" "ROOT_PATH" ])
    (mkRenamedOptionModule [ "services" "gitea" "ssh" "clonePort" ] [ "services" "gitea" "settings" "server" "SSH_PORT" ])

    (mkRemovedOptionModule [ "services" "gitea" "ssh" "enable" ] "services.gitea.ssh.enable has been migrated into freeform setting services.gitea.settings.server.DISABLE_SSH. Keep in mind that the setting is inverted")
  ];

  options = {
    services.gitea = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc "Enable Gitea Service.";
      };

      package = mkOption {
        default = pkgs.gitea;
        type = types.package;
        defaultText = literalExpression "pkgs.gitea";
        description = lib.mdDoc "gitea derivation to use";
      };

      useWizard = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc "Do not generate a configuration and use gitea' installation wizard instead. The first registered user will be administrator.";
      };

      stateDir = mkOption {
        default = "/var/lib/gitea";
        type = types.str;
        description = lib.mdDoc "gitea data directory.";
      };

      user = mkOption {
        type = types.str;
        default = "gitea";
        description = lib.mdDoc "User account under which gitea runs.";
      };

      database = {
        type = mkOption {
          type = types.enum [ "sqlite3" "mysql" "postgres" ];
          example = "mysql";
          default = "sqlite3";
          description = lib.mdDoc "Database engine to use.";
        };

        host = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = lib.mdDoc "Database host address.";
        };

        port = mkOption {
          type = types.port;
          default = if !usePostgresql then 3306 else pg.port;
          defaultText = literalExpression ''
            if config.${opt.database.type} != "postgresql"
            then 3306
            else config.${options.services.postgresql.port}
          '';
          description = lib.mdDoc "Database host port.";
        };

        name = mkOption {
          type = types.str;
          default = "gitea";
          description = lib.mdDoc "Database name.";
        };

        user = mkOption {
          type = types.str;
          default = "gitea";
          description = lib.mdDoc "Database user.";
        };

        password = mkOption {
          type = types.str;
          default = "";
          description = lib.mdDoc ''
            The password corresponding to {option}`database.user`.
            Warning: this is stored in cleartext in the Nix store!
            Use {option}`database.passwordFile` instead.
          '';
        };

        passwordFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          example = "/run/keys/gitea-dbpassword";
          description = lib.mdDoc ''
            A file containing the password corresponding to
            {option}`database.user`.
          '';
        };

        socket = mkOption {
          type = types.nullOr types.path;
          default = if (cfg.database.createDatabase && usePostgresql) then "/run/postgresql" else if (cfg.database.createDatabase && useMysql) then "/run/mysqld/mysqld.sock" else null;
          defaultText = literalExpression "null";
          example = "/run/mysqld/mysqld.sock";
          description = lib.mdDoc "Path to the unix socket file to use for authentication.";
        };

        path = mkOption {
          type = types.str;
          default = "${cfg.stateDir}/data/gitea.db";
          defaultText = literalExpression ''"''${config.${opt.stateDir}}/data/gitea.db"'';
          description = lib.mdDoc "Path to the sqlite3 database file.";
        };

        createDatabase = mkOption {
          type = types.bool;
          default = true;
          description = lib.mdDoc "Whether to create a local database automatically.";
        };
      };

      dump = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = lib.mdDoc ''
            Enable a timer that runs gitea dump to generate backup-files of the
            current gitea database and repositories.
          '';
        };

        interval = mkOption {
          type = types.str;
          default = "04:31";
          example = "hourly";
          description = lib.mdDoc ''
            Run a gitea dump at this interval. Runs by default at 04:31 every day.

            The format is described in
            {manpage}`systemd.time(7)`.
          '';
        };

        backupDir = mkOption {
          type = types.str;
          default = "${cfg.stateDir}/dump";
          defaultText = literalExpression ''"''${config.${opt.stateDir}}/dump"'';
          description = lib.mdDoc "Path to the dump files.";
        };

        type = mkOption {
          type = types.enum [ "zip" "rar" "tar" "sz" "tar.gz" "tar.xz" "tar.bz2" "tar.br" "tar.lz4" ];
          default = "zip";
          description = lib.mdDoc "Archive format used to store the dump file.";
        };

        file = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc "Filename to be used for the dump. If `null` a default name is chosen by gitea.";
          example = "gitea-dump";
        };
      };

      lfs = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = lib.mdDoc "Enables git-lfs support.";
        };

        contentDir = mkOption {
          type = types.str;
          default = "${cfg.stateDir}/data/lfs";
          defaultText = literalExpression ''"''${config.${opt.stateDir}}/data/lfs"'';
          description = lib.mdDoc "Where to store LFS files.";
        };
      };

      appName = mkOption {
        type = types.str;
        default = "gitea: Gitea Service";
        description = lib.mdDoc "Application name.";
      };

      repositoryRoot = mkOption {
        type = types.str;
        default = "${cfg.stateDir}/repositories";
        defaultText = literalExpression ''"''${config.${opt.stateDir}}/repositories"'';
        description = lib.mdDoc "Path to the git repositories.";
      };

      domain = mkOption {
        type = types.str;
        default = "localhost";
        description = lib.mdDoc "Domain name of your server.";
      };

      rootUrl = mkOption {
        type = types.str;
        default = "http://localhost:3000/";
        description = lib.mdDoc "Full public URL of gitea server.";
      };

      httpAddress = mkOption {
        type = types.str;
        default = "0.0.0.0";
        description = lib.mdDoc "HTTP listen address.";
      };

      httpPort = mkOption {
        type = types.port;
        default = 3000;
        description = lib.mdDoc "HTTP listen port.";
      };

      enableUnixSocket = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Configure Gitea to listen on a unix socket instead of the default TCP port.";
      };

      staticRootPath = mkOption {
        type = types.either types.str types.path;
        default = gitea.data;
        defaultText = literalExpression "package.data";
        example = "/var/lib/gitea/data";
        description = lib.mdDoc "Upper level of template and static files path.";
      };

      mailerPasswordFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "/var/lib/secrets/gitea/mailpw";
        description = lib.mdDoc "Path to a file containing the SMTP password.";
      };

      settings = mkOption {
        default = {};
        description = lib.mdDoc ''
          Gitea configuration. Refer to <https://docs.gitea.io/en-us/config-cheat-sheet/>
          for details on supported values.
        '';
        example = literalExpression ''
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
        type = with types; submodule {
          freeformType = format.type;
          options = {
            log = {
              ROOT_PATH = mkOption {
                default = "${cfg.stateDir}/log";
                defaultText = literalExpression ''"''${config.${opt.stateDir}}/log"'';
                type = types.str;
                description = lib.mdDoc "Root path for log files.";
              };
              LEVEL = mkOption {
                default = "Info";
                type = types.enum [ "Trace" "Debug" "Info" "Warn" "Error" "Critical" ];
                description = lib.mdDoc "General log level.";
              };
            };

            server = {
              DISABLE_SSH = mkOption {
                type = types.bool;
                default = false;
                description = lib.mdDoc "Disable external SSH feature.";
              };

              SSH_PORT = mkOption {
                type = types.port;
                default = 22;
                example = 2222;
                description = lib.mdDoc ''
                  SSH port displayed in clone URL.
                  The option is required to configure a service when the external visible port
                  differs from the local listening port i.e. if port forwarding is used.
                '';
              };
            };

            service = {
              DISABLE_REGISTRATION = mkEnableOption (lib.mdDoc "the registration lock") // {
                description = lib.mdDoc ''
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
              COOKIE_SECURE = mkOption {
                type = types.bool;
                default = false;
                description = lib.mdDoc ''
                  Marks session cookies as "secure" as a hint for browsers to only send
                  them via HTTPS. This option is recommend, if gitea is being served over HTTPS.
                '';
              };
            };
          };
        };
      };

      extraConfig = mkOption {
        type = with types; nullOr str;
        default = null;
        description = lib.mdDoc "Configuration lines appended to the generated gitea configuration file.";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      { assertion = cfg.database.createDatabase -> cfg.database.user == cfg.user;
        message = "services.gitea.database.user must match services.gitea.user if the database is to be automatically provisioned";
      }
    ];

    services.gitea.settings = {
      database = mkMerge [
        {
          DB_TYPE = cfg.database.type;
        }
        (mkIf (useMysql || usePostgresql) {
          HOST = if cfg.database.socket != null then cfg.database.socket else cfg.database.host + ":" + toString cfg.database.port;
          NAME = cfg.database.name;
          USER = cfg.database.user;
          PASSWD = "#dbpass#";
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

      server = mkMerge [
        {
          DOMAIN = cfg.domain;
          STATIC_ROOT_PATH = toString cfg.staticRootPath;
          LFS_JWT_SECRET = "#lfsjwtsecret#";
          ROOT_URL = cfg.rootUrl;
        }
        (mkIf cfg.enableUnixSocket {
          PROTOCOL = "http+unix";
          HTTP_ADDR = "/run/gitea/gitea.sock";
        })
        (mkIf (!cfg.enableUnixSocket) {
          HTTP_ADDR = cfg.httpAddress;
          HTTP_PORT = cfg.httpPort;
        })
        (mkIf cfg.lfs.enable {
          LFS_START_SERVER = true;
        })

      ];

      session = {
        COOKIE_NAME = lib.mkDefault "session";
      };

      security = {
        SECRET_KEY = "#secretkey#";
        INTERNAL_TOKEN = "#internaltoken#";
        INSTALL_LOCK = true;
      };

      mailer = mkIf (cfg.mailerPasswordFile != null) {
        PASSWD = "#mailerpass#";
      };

      oauth2 = {
        JWT_SECRET = "#oauth2jwtsecret#";
      };

      lfs = mkIf (cfg.lfs.enable) {
        PATH = cfg.lfs.contentDir;
      };
    };

    services.postgresql = optionalAttrs (usePostgresql && cfg.database.createDatabase) {
      enable = mkDefault true;

      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        { name = cfg.database.user;
          ensurePermissions = { "DATABASE ${cfg.database.name}" = "ALL PRIVILEGES"; };
        }
      ];
    };

    services.mysql = optionalAttrs (useMysql && cfg.database.createDatabase) {
      enable = mkDefault true;
      package = mkDefault pkgs.mariadb;

      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        { name = cfg.database.user;
          ensurePermissions = { "${cfg.database.name}.*" = "ALL PRIVILEGES"; };
        }
      ];
    };

    systemd.tmpfiles.rules = [
      "d '${cfg.dump.backupDir}' 0750 ${cfg.user} gitea - -"
      "z '${cfg.dump.backupDir}' 0750 ${cfg.user} gitea - -"
      "Z '${cfg.dump.backupDir}' - ${cfg.user} gitea - -"
      "d '${cfg.lfs.contentDir}' 0750 ${cfg.user} gitea - -"
      "z '${cfg.lfs.contentDir}' 0750 ${cfg.user} gitea - -"
      "Z '${cfg.lfs.contentDir}' - ${cfg.user} gitea - -"
      "d '${cfg.repositoryRoot}' 0750 ${cfg.user} gitea - -"
      "z '${cfg.repositoryRoot}' 0750 ${cfg.user} gitea - -"
      "Z '${cfg.repositoryRoot}' - ${cfg.user} gitea - -"
      "d '${cfg.stateDir}' 0750 ${cfg.user} gitea - -"
      "d '${cfg.stateDir}/conf' 0750 ${cfg.user} gitea - -"
      "d '${cfg.stateDir}/custom' 0750 ${cfg.user} gitea - -"
      "d '${cfg.stateDir}/custom/conf' 0750 ${cfg.user} gitea - -"
      "d '${cfg.stateDir}/data' 0750 ${cfg.user} gitea - -"
      "d '${cfg.stateDir}/log' 0750 ${cfg.user} gitea - -"
      "z '${cfg.stateDir}' 0750 ${cfg.user} gitea - -"
      "z '${cfg.stateDir}/.ssh' 0700 ${cfg.user} gitea - -"
      "z '${cfg.stateDir}/conf' 0750 ${cfg.user} gitea - -"
      "z '${cfg.stateDir}/custom' 0750 ${cfg.user} gitea - -"
      "z '${cfg.stateDir}/custom/conf' 0750 ${cfg.user} gitea - -"
      "z '${cfg.stateDir}/data' 0750 ${cfg.user} gitea - -"
      "z '${cfg.stateDir}/log' 0750 ${cfg.user} gitea - -"
      "Z '${cfg.stateDir}' - ${cfg.user} gitea - -"

      # If we have a folder or symlink with gitea locales, remove it
      # And symlink the current gitea locales in place
      "L+ '${cfg.stateDir}/conf/locale' - - - - ${gitea.out}/locale"
    ];

    systemd.services.gitea = {
      description = "gitea";
      after = [ "network.target" ] ++ lib.optional usePostgresql "postgresql.service" ++ lib.optional useMysql "mysql.service";
      wantedBy = [ "multi-user.target" ];
      path = [ gitea pkgs.git pkgs.gnupg ];

      # In older versions the secret naming for JWT was kind of confusing.
      # The file jwt_secret hold the value for LFS_JWT_SECRET and JWT_SECRET
      # wasn't persistent at all.
      # To fix that, there is now the file oauth2_jwt_secret containing the
      # values for JWT_SECRET and the file jwt_secret gets renamed to
      # lfs_jwt_secret.
      # We have to consider this to stay compatible with older installations.
      preStart = let
        runConfig = "${cfg.stateDir}/custom/conf/app.ini";
        secretKey = "${cfg.stateDir}/custom/conf/secret_key";
        oauth2JwtSecret = "${cfg.stateDir}/custom/conf/oauth2_jwt_secret";
        oldLfsJwtSecret = "${cfg.stateDir}/custom/conf/jwt_secret"; # old file for LFS_JWT_SECRET
        lfsJwtSecret = "${cfg.stateDir}/custom/conf/lfs_jwt_secret"; # new file for LFS_JWT_SECRET
        internalToken = "${cfg.stateDir}/custom/conf/internal_token";
        replaceSecretBin = "${pkgs.replace-secret}/bin/replace-secret";
      in ''
        # copy custom configuration and generate a random secret key if needed
        ${optionalString (!cfg.useWizard) ''
          function gitea_setup {
            cp -f ${configFile} ${runConfig}

            if [ ! -s ${secretKey} ]; then
                ${gitea}/bin/gitea generate secret SECRET_KEY > ${secretKey}
            fi

            # Migrate LFS_JWT_SECRET filename
            if [[ -s ${oldLfsJwtSecret} && ! -s ${lfsJwtSecret} ]]; then
                mv ${oldLfsJwtSecret} ${lfsJwtSecret}
            fi

            if [ ! -s ${oauth2JwtSecret} ]; then
                ${gitea}/bin/gitea generate secret JWT_SECRET > ${oauth2JwtSecret}
            fi

            if [ ! -s ${lfsJwtSecret} ]; then
                ${gitea}/bin/gitea generate secret LFS_JWT_SECRET > ${lfsJwtSecret}
            fi

            if [ ! -s ${internalToken} ]; then
                ${gitea}/bin/gitea generate secret INTERNAL_TOKEN > ${internalToken}
            fi

            chmod u+w '${runConfig}'
            ${replaceSecretBin} '#secretkey#' '${secretKey}' '${runConfig}'
            ${replaceSecretBin} '#dbpass#' '${cfg.database.passwordFile}' '${runConfig}'
            ${replaceSecretBin} '#oauth2jwtsecret#' '${oauth2JwtSecret}' '${runConfig}'
            ${replaceSecretBin} '#lfsjwtsecret#' '${lfsJwtSecret}' '${runConfig}'
            ${replaceSecretBin} '#internaltoken#' '${internalToken}' '${runConfig}'

            ${lib.optionalString (cfg.mailerPasswordFile != null) ''
              ${replaceSecretBin} '#mailerpass#' '${cfg.mailerPasswordFile}' '${runConfig}'
            ''}
            chmod u-w '${runConfig}'
          }
          (umask 027; gitea_setup)
        ''}

        # run migrations/init the database
        ${gitea}/bin/gitea migrate

        # update all hooks' binary paths
        ${gitea}/bin/gitea admin regenerate hooks

        # update command option in authorized_keys
        if [ -r ${cfg.stateDir}/.ssh/authorized_keys ]
        then
          ${gitea}/bin/gitea admin regenerate keys
        fi
      '';

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = "gitea";
        WorkingDirectory = cfg.stateDir;
        ExecStart = "${gitea}/bin/gitea web --pid /run/gitea/gitea.pid";
        Restart = "always";
        # Runtime directory and mode
        RuntimeDirectory = "gitea";
        RuntimeDirectoryMode = "0755";
        # Access write directories
        ReadWritePaths = [ cfg.dump.backupDir cfg.repositoryRoot cfg.stateDir cfg.lfs.contentDir ];
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
        RestrictAddressFamilies = [ "AF_UNIX AF_INET AF_INET6" ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        PrivateMounts = true;
        # System Call Filtering
        SystemCallArchitectures = "native";
        SystemCallFilter = "~@clock @cpu-emulation @debug @keyring @memlock @module @mount @obsolete @raw-io @reboot @setuid @swap";
      };

      environment = {
        USER = cfg.user;
        HOME = cfg.stateDir;
        GITEA_WORK_DIR = cfg.stateDir;
      };
    };

    users.users = mkIf (cfg.user == "gitea") {
      gitea = {
        description = "Gitea Service";
        home = cfg.stateDir;
        useDefaultShell = true;
        group = "gitea";
        isSystemUser = true;
      };
    };

    users.groups.gitea = {};

    warnings =
      optional (cfg.database.password != "") "config.services.gitea.database.password will be stored as plaintext in the Nix store. Use database.passwordFile instead." ++
      optional (cfg.extraConfig != null) ''
        services.gitea.`extraConfig` is deprecated, please use services.gitea.`settings`.
      '';

    # Create database passwordFile default when password is configured.
    services.gitea.database.passwordFile =
      mkDefault (toString (pkgs.writeTextFile {
        name = "gitea-database-password";
        text = cfg.database.password;
      }));

    systemd.services.gitea-dump = mkIf cfg.dump.enable {
       description = "gitea dump";
       after = [ "gitea.service" ];
       path = [ gitea ];

       environment = {
         USER = cfg.user;
         HOME = cfg.stateDir;
         GITEA_WORK_DIR = cfg.stateDir;
       };

       serviceConfig = {
         Type = "oneshot";
         User = cfg.user;
         ExecStart = "${gitea}/bin/gitea dump --type ${cfg.dump.type}" + optionalString (cfg.dump.file != null) " --file ${cfg.dump.file}";
         WorkingDirectory = cfg.dump.backupDir;
       };
    };

    systemd.timers.gitea-dump = mkIf cfg.dump.enable {
      description = "Update timer for gitea-dump";
      partOf = [ "gitea-dump.service" ];
      wantedBy = [ "timers.target" ];
      timerConfig.OnCalendar = cfg.dump.interval;
    };
  };
  meta.maintainers = with lib.maintainers; [ srhb ma27 ];
}
