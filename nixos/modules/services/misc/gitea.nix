{ config, lib, options, pkgs, ... }:

with lib;

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

    ${generators.toINI {} cfg.settings}

    ${optionalString (cfg.extraConfig != null) cfg.extraConfig}
  '';
in

{
  imports = [
    (mkRenamedOptionModule [ "services" "gitea" "cookieSecure" ] [ "services" "gitea" "settings" "session" "COOKIE_SECURE" ])
    (mkRenamedOptionModule [ "services" "gitea" "disableRegistration" ] [ "services" "gitea" "settings" "service" "DISABLE_REGISTRATION" ])
    (mkRenamedOptionModule [ "services" "gitea" "domain" ] [ "services" "gitea" "settings" "server" "DOMAIN" ])
    (mkRenamedOptionModule [ "services" "gitea" "httpAddress" ] [ "services" "gitea" "settings" "server" "HTTP_ADDR" ])
    (mkRenamedOptionModule [ "services" "gitea" "httpPort" ] [ "services" "gitea" "settings" "server" "HTTP_PORT" ])
    (mkRenamedOptionModule [ "services" "gitea" "log" "level" ] [ "services" "gitea" "settings" "log" "LEVEL" ])
    (mkRenamedOptionModule [ "services" "gitea" "log" "rootPath" ] [ "services" "gitea" "settings" "log" "ROOT_PATH" ])
    (mkRenamedOptionModule [ "services" "gitea" "rootUrl" ] [ "services" "gitea" "settings" "server" "ROOT_URL" ])
    (mkRenamedOptionModule [ "services" "gitea" "ssh" "clonePort" ] [ "services" "gitea" "settings" "server" "SSH_PORT" ])
    (mkRenamedOptionModule [ "services" "gitea" "staticRootPath" ] [ "services" "gitea" "settings" "server" "STATIC_ROOT_PATH" ])

    (mkChangedOptionModule [ "services" "gitea" "enableUnixSocket" ] [ "services" "gitea" "settings" "server" "PROTOCOL" ] (
      config: if config.services.gitea.enableUnixSocket then "http+unix" else "http"
    ))

    (mkRemovedOptionModule [ "services" "gitea" "ssh" "enable" ] "services.gitea.ssh.enable has been migrated into freeform setting services.gitea.settings.server.DISABLE_SSH. Keep in mind that the setting is inverted")
  ];

  options = {
    services.gitea = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc "Enable Gitea Service.";
      };

      package = mkPackageOption pkgs "gitea" { };

      useWizard = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc "Do not generate a configuration and use gitea' installation wizard instead. The first registered user will be administrator.";
      };

      stateDir = mkOption {
        default = "/var/lib/gitea";
        type = types.str;
        description = lib.mdDoc "Gitea data directory.";
      };

      customDir = mkOption {
        default = "${cfg.stateDir}/custom";
        defaultText = literalExpression ''"''${config.${opt.stateDir}}/custom"'';
        type = types.str;
        description = lib.mdDoc "Gitea custom directory. Used for config, custom templates and other options.";
      };

      user = mkOption {
        type = types.str;
        default = "gitea";
        description = lib.mdDoc "User account under which gitea runs.";
      };

      group = mkOption {
        type = types.str;
        default = "gitea";
        description = lib.mdDoc "Group under which gitea runs.";
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
          default = if usePostgresql then pg.settings.port else 3306;
          defaultText = literalExpression ''
            if config.${opt.database.type} != "postgresql"
            then 3306
            else 5432
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
          type = types.enum [ "zip" "rar" "tar" "sz" "tar.gz" "tar.xz" "tar.bz2" "tar.br" "tar.lz4" "tar.zst" ];
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

      camoHmacKeyFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "/var/lib/secrets/gitea/camoHmacKey";
        description = lib.mdDoc "Path to a file containing the camo HMAC key.";
      };

      mailerPasswordFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "/var/lib/secrets/gitea/mailpw";
        description = lib.mdDoc "Path to a file containing the SMTP password.";
      };

      metricsTokenFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "/var/lib/secrets/gitea/metrics_token";
        description = lib.mdDoc "Path to a file containing the metrics authentication token.";
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
        type = types.submodule {
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
              PROTOCOL = mkOption {
                type = types.enum [ "http" "https" "fcgi" "http+unix" "fcgi+unix" ];
                default = "http";
                description = lib.mdDoc ''Listen protocol. `+unix` means "over unix", not "in addition to."'';
              };

              HTTP_ADDR = mkOption {
                type = types.either types.str types.path;
                default = if lib.hasSuffix "+unix" cfg.settings.server.PROTOCOL then "/run/gitea/gitea.sock" else "0.0.0.0";
                defaultText = literalExpression ''if lib.hasSuffix "+unix" cfg.settings.server.PROTOCOL then "/run/gitea/gitea.sock" else "0.0.0.0"'';
                description = lib.mdDoc "Listen address. Must be a path when using a unix socket.";
              };

              HTTP_PORT = mkOption {
                type = types.port;
                default = 3000;
                description = lib.mdDoc "Listen port. Ignored when using a unix socket.";
              };

              DOMAIN = mkOption {
                type = types.str;
                default = "localhost";
                description = lib.mdDoc "Domain name of your server.";
              };

              ROOT_URL = mkOption {
                type = types.str;
                default = "http://${cfg.settings.server.DOMAIN}:${toString cfg.settings.server.HTTP_PORT}/";
                defaultText = literalExpression ''"http://''${config.services.gitea.settings.server.DOMAIN}:''${toString config.services.gitea.settings.server.HTTP_PORT}/"'';
                description = lib.mdDoc "Full public URL of gitea server.";
              };

              STATIC_ROOT_PATH = mkOption {
                type = types.either types.str types.path;
                default = cfg.package.data;
                defaultText = literalExpression "config.${opt.package}.data";
                example = "/var/lib/gitea/data";
                description = lib.mdDoc "Upper level of template and static files path.";
              };

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

      server = mkIf cfg.lfs.enable {
        LFS_START_SERVER = true;
        LFS_JWT_SECRET = "#lfsjwtsecret#";
      };

      camo = mkIf (cfg.camoHmacKeyFile != null) {
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

      mailer = mkIf (cfg.mailerPasswordFile != null) {
        PASSWD = "#mailerpass#";
      };

      metrics = mkIf (cfg.metricsTokenFile != null) {
        TOKEN = "#metricstoken#";
      };

      oauth2 = {
        JWT_SECRET = "#oauth2jwtsecret#";
      };

      lfs = mkIf cfg.lfs.enable {
        PATH = cfg.lfs.contentDir;
      };

      packages.CHUNKED_UPLOAD_PATH = "${cfg.stateDir}/tmp/package-upload";
    };

    services.postgresql = optionalAttrs (usePostgresql && cfg.database.createDatabase) {
      enable = mkDefault true;

      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        { name = cfg.database.user;
          ensureDBOwnership = true;
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
      after = [ "network.target" ] ++ optional usePostgresql "postgresql.service" ++ optional useMysql "mysql.service";
      requires = optional (cfg.database.createDatabase && usePostgresql) "postgresql.service" ++ optional (cfg.database.createDatabase && useMysql) "mysql.service";
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
        ${optionalString (!cfg.useWizard) ''
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

    users.users = mkIf (cfg.user == "gitea") {
      gitea = {
        description = "Gitea Service";
        home = cfg.stateDir;
        useDefaultShell = true;
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.group == "gitea") {
      gitea = {};
    };

    warnings =
      optional (cfg.database.password != "") "config.services.gitea.database.password will be stored as plaintext in the Nix store. Use database.passwordFile instead." ++
      optional (cfg.extraConfig != null) ''
        services.gitea.`extraConfig` is deprecated, please use services.gitea.`settings`.
      '' ++
      optional (lib.getName cfg.package == "forgejo") ''
        Running forgejo via services.gitea.package is no longer supported.
        Please use services.forgejo instead.
        See https://nixos.org/manual/nixos/unstable/#module-forgejo for migration instructions.
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
         ExecStart = "${exe} dump --type ${cfg.dump.type}" + optionalString (cfg.dump.file != null) " --file ${cfg.dump.file}";
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
  meta.maintainers = with lib.maintainers; [ srhb ma27 thehedgeh0g ];
}
