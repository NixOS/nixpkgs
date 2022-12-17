{ config, lib, options, pkgs, ... }:

with lib;

let
  cfg = config.services.forgejo;
  opt = options.services.forgejo;
  forgejo = cfg.package;
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
    (mkRenamedOptionModule [ "services" "forgejo" "cookieSecure" ] [ "services" "forgejo" "settings" "session" "COOKIE_SECURE" ])
    (mkRenamedOptionModule [ "services" "forgejo" "disableRegistration" ] [ "services" "forgejo" "settings" "service" "DISABLE_REGISTRATION" ])
    (mkRenamedOptionModule [ "services" "forgejo" "log" "level" ] [ "services" "forgejo" "settings" "log" "LEVEL" ])
    (mkRenamedOptionModule [ "services" "forgejo" "log" "rootPath" ] [ "services" "forgejo" "settings" "log" "ROOT_PATH" ])
    (mkRenamedOptionModule [ "services" "forgejo" "ssh" "clonePort" ] [ "services" "forgejo" "settings" "server" "SSH_PORT" ])

    (mkRemovedOptionModule [ "services" "forgejo" "ssh" "enable" ] "services.forgejo.ssh.enable has been migrated into freeform setting services.forgejo.settings.server.DISABLE_SSH. Keep in mind that the setting is inverted")
  ];

  options = {
    services.forgejo = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc "Enable Forgejo Service.";
      };

      package = mkOption {
        default = pkgs.forgejo;
        type = types.package;
        defaultText = literalExpression "pkgs.forgejo";
        description = lib.mdDoc "forgejo derivation to use";
      };

      useWizard = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc "Do not generate a configuration and use forgejo' installation wizard instead. The first registered user will be administrator.";
      };

      stateDir = mkOption {
        default = "/var/lib/forgejo";
        type = types.str;
        description = lib.mdDoc "forgejo data directory.";
      };

      user = mkOption {
        type = types.str;
        default = "forgejo";
        description = lib.mdDoc "User account under which forgejo runs.";
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
          default = "forgejo";
          description = lib.mdDoc "Database name.";
        };

        user = mkOption {
          type = types.str;
          default = "forgejo";
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
          example = "/run/keys/forgejo-dbpassword";
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
          default = "${cfg.stateDir}/data/forgejo.db";
          defaultText = literalExpression ''"''${config.${opt.stateDir}}/data/forgejo.db"'';
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
            Enable a timer that runs forgejo dump to generate backup-files of the
            current forgejo database and repositories.
          '';
        };

        interval = mkOption {
          type = types.str;
          default = "04:31";
          example = "hourly";
          description = lib.mdDoc ''
            Run a forgejo dump at this interval. Runs by default at 04:31 every day.

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
          description = lib.mdDoc "Filename to be used for the dump. If `null` a default name is choosen by forgejo.";
          example = "forgejo-dump";
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
        default = "forgejo: Forgejo Service";
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
        description = lib.mdDoc "Full public URL of forgejo server.";
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
        description = lib.mdDoc "Configure Forgejo to listen on a unix socket instead of the default TCP port.";
      };

      staticRootPath = mkOption {
        type = types.either types.str types.path;
        default = forgejo.data;
        defaultText = literalExpression "package.data";
        example = "/var/lib/forgejo/data";
        description = lib.mdDoc "Upper level of template and static files path.";
      };

      mailerPasswordFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "/var/lib/secrets/forgejo/mailpw";
        description = lib.mdDoc "Path to a file containing the SMTP password.";
      };

      settings = mkOption {
        default = { };
        description = lib.mdDoc ''
          Forgejo configuration. Refer to <https://docs.gitea.io/en-us/config-cheat-sheet/>
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
                  By default any user can create an account on this `forgejo` instance.
                  This can be disabled by using this option.

                  *Note:* please keep in mind that this should be added after the initial
                  deploy unless [](#opt-services.forgejo.useWizard)
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
                  them via HTTPS. This option is recommend, if forgejo is being served over HTTPS.
                '';
              };
            };
          };
        };
      };

      extraConfig = mkOption {
        type = with types; nullOr str;
        default = null;
        description = lib.mdDoc "Configuration lines appended to the generated forgejo configuration file.";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.database.createDatabase -> cfg.database.user == cfg.user;
        message = "services.forgejo.database.user must match services.forgejo.user if the database is to be automatically provisioned";
      }
    ];

    services.forgejo.settings = {
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
          PROTOCOL = "unix";
          HTTP_ADDR = "/run/forgejo/forgejo.sock";
        })
        (mkIf (!cfg.enableUnixSocket) {
          HTTP_ADDR = cfg.httpAddress;
          HTTP_PORT = cfg.httpPort;
        })
        (mkIf cfg.lfs.enable {
          LFS_START_SERVER = true;
          LFS_CONTENT_PATH = cfg.lfs.contentDir;
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
    };

    services.postgresql = optionalAttrs (usePostgresql && cfg.database.createDatabase) {
      enable = mkDefault true;

      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensurePermissions = { "DATABASE ${cfg.database.name}" = "ALL PRIVILEGES"; };
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
          ensurePermissions = { "${cfg.database.name}.*" = "ALL PRIVILEGES"; };
        }
      ];
    };

    systemd.tmpfiles.rules = [
      "d '${cfg.dump.backupDir}' 0750 ${cfg.user} forgejo - -"
      "z '${cfg.dump.backupDir}' 0750 ${cfg.user} forgejo - -"
      "Z '${cfg.dump.backupDir}' - ${cfg.user} forgejo - -"
      "d '${cfg.lfs.contentDir}' 0750 ${cfg.user} forgejo - -"
      "z '${cfg.lfs.contentDir}' 0750 ${cfg.user} forgejo - -"
      "Z '${cfg.lfs.contentDir}' - ${cfg.user} forgejo - -"
      "d '${cfg.repositoryRoot}' 0750 ${cfg.user} forgejo - -"
      "z '${cfg.repositoryRoot}' 0750 ${cfg.user} forgejo - -"
      "Z '${cfg.repositoryRoot}' - ${cfg.user} forgejo - -"
      "d '${cfg.stateDir}' 0750 ${cfg.user} forgejo - -"
      "d '${cfg.stateDir}/conf' 0750 ${cfg.user} forgejo - -"
      "d '${cfg.stateDir}/custom' 0750 ${cfg.user} forgejo - -"
      "d '${cfg.stateDir}/custom/conf' 0750 ${cfg.user} forgejo - -"
      "d '${cfg.stateDir}/log' 0750 ${cfg.user} forgejo - -"
      "z '${cfg.stateDir}' 0750 ${cfg.user} forgejo - -"
      "z '${cfg.stateDir}/.ssh' 0700 ${cfg.user} forgejo - -"
      "z '${cfg.stateDir}/conf' 0750 ${cfg.user} forgejo - -"
      "z '${cfg.stateDir}/custom' 0750 ${cfg.user} forgejo - -"
      "z '${cfg.stateDir}/custom/conf' 0750 ${cfg.user} forgejo - -"
      "z '${cfg.stateDir}/log' 0750 ${cfg.user} forgejo - -"
      "Z '${cfg.stateDir}' - ${cfg.user} forgejo - -"

      # If we have a folder or symlink with forgejo locales, remove it
      # And symlink the current forgejo locales in place
      "L+ '${cfg.stateDir}/conf/locale' - - - - ${forgejo.out}/locale"
    ];

    systemd.services.forgejo = {
      description = "forgejo";
      after = [ "network.target" ] ++ lib.optional usePostgresql "postgresql.service" ++ lib.optional useMysql "mysql.service";
      wantedBy = [ "multi-user.target" ];
      path = [ forgejo pkgs.git pkgs.gnupg ];

      # In older versions the secret naming for JWT was kind of confusing.
      # The file jwt_secret hold the value for LFS_JWT_SECRET and JWT_SECRET
      # wasn't persistant at all.
      # To fix that, there is now the file oauth2_jwt_secret containing the
      # values for JWT_SECRET and the file jwt_secret gets renamed to
      # lfs_jwt_secret.
      # We have to consider this to stay compatible with older installations.
      preStart =
        let
          runConfig = "${cfg.stateDir}/custom/conf/app.ini";
          secretKey = "${cfg.stateDir}/custom/conf/secret_key";
          oauth2JwtSecret = "${cfg.stateDir}/custom/conf/oauth2_jwt_secret";
          oldLfsJwtSecret = "${cfg.stateDir}/custom/conf/jwt_secret"; # old file for LFS_JWT_SECRET
          lfsJwtSecret = "${cfg.stateDir}/custom/conf/lfs_jwt_secret"; # new file for LFS_JWT_SECRET
          internalToken = "${cfg.stateDir}/custom/conf/internal_token";
          replaceSecretBin = "${pkgs.replace-secret}/bin/replace-secret";
        in
        ''
          # copy custom configuration and generate a random secret key if needed
          ${optionalString (!cfg.useWizard) ''
            function forgejo_setup {
              cp -f ${configFile} ${runConfig}

              if [ ! -s ${secretKey} ]; then
                  ${forgejo}/bin/forgejo generate secret SECRET_KEY > ${secretKey}
              fi

              # Migrate LFS_JWT_SECRET filename
              if [[ -s ${oldLfsJwtSecret} && ! -s ${lfsJwtSecret} ]]; then
                  mv ${oldLfsJwtSecret} ${lfsJwtSecret}
              fi

              if [ ! -s ${oauth2JwtSecret} ]; then
                  ${forgejo}/bin/forgejo generate secret JWT_SECRET > ${oauth2JwtSecret}
              fi

              if [ ! -s ${lfsJwtSecret} ]; then
                  ${forgejo}/bin/forgejo generate secret LFS_JWT_SECRET > ${lfsJwtSecret}
              fi

              if [ ! -s ${internalToken} ]; then
                  ${forgejo}/bin/forgejo generate secret INTERNAL_TOKEN > ${internalToken}
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
            (umask 027; forgejo_setup)
          ''}

          # run migrations/init the database
          ${forgejo}/bin/forgejo migrate

          # update all hooks' binary paths
          ${forgejo}/bin/forgejo admin regenerate hooks

          # update command option in authorized_keys
          if [ -r ${cfg.stateDir}/.ssh/authorized_keys ]
          then
            ${forgejo}/bin/forgejo admin regenerate keys
          fi
        '';

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = "forgejo";
        WorkingDirectory = cfg.stateDir;
        ExecStart = "${forgejo}/bin/forgejo web --pid /run/forgejo/forgejo.pid";
        Restart = "always";
        # Runtime directory and mode
        RuntimeDirectory = "forgejo";
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
        FORGEJO_WORK_DIR = cfg.stateDir;
      };
    };

    users.users = mkIf (cfg.user == "forgejo") {
      forgejo = {
        description = "Forgejo Service";
        home = cfg.stateDir;
        useDefaultShell = true;
        group = "forgejo";
        isSystemUser = true;
      };
    };

    users.groups.forgejo = { };

    warnings =
      optional (cfg.database.password != "") "config.services.forgejo.database.password will be stored as plaintext in the Nix store. Use database.passwordFile instead." ++
      optional (cfg.extraConfig != null) ''
        services.forgejo.`extraConfig` is deprecated, please use services.forgejo.`settings`.
      '';

    # Create database passwordFile default when password is configured.
    services.forgejo.database.passwordFile =
      mkDefault (toString (pkgs.writeTextFile {
        name = "forgejo-database-password";
        text = cfg.database.password;
      }));

    systemd.services.forgejo-dump = mkIf cfg.dump.enable {
      description = "forgejo dump";
      after = [ "forgejo.service" ];
      wantedBy = [ "default.target" ];
      path = [ forgejo ];

      environment = {
        USER = cfg.user;
        HOME = cfg.stateDir;
        FORGEJO_WORK_DIR = cfg.stateDir;
      };

      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
        ExecStart = "${forgejo}/bin/forgejo dump --type ${cfg.dump.type}" + optionalString (cfg.dump.file != null) " --file ${cfg.dump.file}";
        WorkingDirectory = cfg.dump.backupDir;
      };
    };

    systemd.timers.forgejo-dump = mkIf cfg.dump.enable {
      description = "Update timer for forgejo-dump";
      partOf = [ "forgejo-dump.service" ];
      wantedBy = [ "timers.target" ];
      timerConfig.OnCalendar = cfg.dump.interval;
    };
  };
  meta.maintainers = with lib.maintainers; [ infinidoge ];
}
