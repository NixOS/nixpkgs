{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.seafile;
  settingsFormat = pkgs.formats.ini { };

  seafRoot = "/var/lib/seafile";
  ccnetDir = "${seafRoot}/ccnet";
  seahubDir = "${seafRoot}/seahub";
  confDir = "${seafRoot}/conf";
  defaultUser = "seafile";

  # seafile.conf: in 13.0 only [fileserver] belongs here.
  # Database, cache, and storage backend settings moved to .env.
  seafileConf = settingsFormat.generate "seafile.conf" (
    lib.attrsets.recursiveUpdate {
      fileserver = {
        host = "127.0.0.1";
        port = 8082;
      };
    } cfg.seafileSettings
  );

  seahubSettings = pkgs.writeText "seahub_settings.py" ''
    FILE_SERVER_ROOT = '${cfg.serverProtocol}://${cfg.serverHostname}/seafhttp'
    SERVICE_URL = '${cfg.serverProtocol}://${cfg.serverHostname}'
    CSRF_TRUSTED_ORIGINS = ['${cfg.serverProtocol}://${cfg.serverHostname}']
    MEDIA_ROOT = '${seahubDir}/media/'
    THUMBNAIL_ROOT = '${seahubDir}/thumbnail/'

    with open('${seafRoot}/.seahubSecret') as f:
        SECRET_KEY = f.readline().rstrip()

    ${cfg.seahubExtraConf}
  '';

  # Static (non-secret) portion of the .env file.  Secrets (DB password,
  # JWT key) are appended at runtime in preStart so they never enter the
  # Nix store.
  staticEnvFile = pkgs.writeText "seafile-static.env" (
    ''
      SEAFILE_SERVER_PROTOCOL=${cfg.serverProtocol}
      SEAFILE_SERVER_HOSTNAME=${cfg.serverHostname}
      SEAFILE_MYSQL_DB_HOST=${cfg.database.host}
      SEAFILE_MYSQL_DB_PORT=${toString cfg.database.port}
      SEAFILE_MYSQL_DB_USER=${cfg.database.user}
      SEAFILE_MYSQL_DB_CCNET_DB_NAME=${cfg.database.ccnetDbName}
      SEAFILE_MYSQL_DB_SEAFILE_DB_NAME=${cfg.database.seafileDbName}
      SEAFILE_MYSQL_DB_SEAHUB_DB_NAME=${cfg.database.seahubDbName}
      CACHE_PROVIDER=${cfg.cache.provider}
    ''
    + lib.optionalString (cfg.cache.provider == "redis") ''
      REDIS_HOST=${cfg.cache.host}
      REDIS_PORT=${toString cfg.cache.port}
      REDIS_PASSWORD=
    ''
    + lib.optionalString (cfg.cache.provider == "memcached") ''
      MEMCACHED_HOST=${cfg.cache.host}
      MEMCACHED_PORT=${toString cfg.cache.port}
    ''
  );

  # Shared systemd hardening options applied to all Seafile services.
  serviceHardening = {
    ProtectHome = true;
    PrivateUsers = true;
    PrivateDevices = true;
    PrivateTmp = true;
    ProtectSystem = "strict";
    ProtectClock = true;
    ProtectHostname = true;
    ProtectProc = "invisible";
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true;
    RestrictNamespaces = true;
    RemoveIPC = true;
    LockPersonality = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    NoNewPrivileges = true;
    MemoryDenyWriteExecute = true;
    SystemCallArchitectures = "native";
    RestrictAddressFamilies = [
      "AF_UNIX"
      "AF_INET"
      "AF_INET6"
    ];
    User = cfg.user;
    Group = cfg.group;
    StateDirectory = "seafile";
    RuntimeDirectory = "seafile";
    LogsDirectory = "seafile";
    ReadWritePaths = lib.optional (cfg.dataDir != "${seafRoot}/data") cfg.dataDir;
  };

  # Shell fragment that assembles the runtime .env file from static config
  # plus secrets read from files (never stored in the Nix store).
  generateEnvScript = ''
    install -d -m 0750 ${confDir}

    # Build .env inside a subshell so umask is set before the redirect opens the file.
    (umask 027; {
       cat ${staticEnvFile}
       ${lib.optionalString (cfg.database.passwordFile != null) ''
         printf 'SEAFILE_MYSQL_DB_PASSWORD=%s\n' \
           "$(cat ${lib.escapeShellArg cfg.database.passwordFile})"
       ''}
       ${lib.optionalString (cfg.database.passwordFile == null) ''
         echo 'SEAFILE_MYSQL_DB_PASSWORD='
       ''}
       ${lib.optionalString (cfg.jwtPrivateKeyFile != null) ''
         printf 'JWT_PRIVATE_KEY=%s\n' \
           "$(cat ${lib.escapeShellArg cfg.jwtPrivateKeyFile})"
       ''}
       ${lib.optionalString (cfg.jwtPrivateKeyFile == null) ''
         if [ ! -f "${seafRoot}/.jwtKey" ]; then
           (umask 077; ${lib.getExe' pkgs.openssl "openssl"} rand -hex 32 \
             > "${seafRoot}/.jwtKey")
         fi
         printf 'JWT_PRIVATE_KEY=%s\n' "$(cat "${seafRoot}/.jwtKey")"
       ''}
     } > ${confDir}/.env
    )

    cp -f ${seafileConf} ${confDir}/seafile.conf
    cp -f ${seahubSettings} ${confDir}/seahub_settings.py
    chmod 640 ${confDir}/seafile.conf ${confDir}/seahub_settings.py
  '';

  # Base mysql client command without password; preStart exports MYSQL_PWD for external DBs.
  mysqlClient =
    if cfg.database.createLocally then
      "${pkgs.mariadb.client}/bin/mysql --socket=/run/mysqld/mysqld.sock --user=${cfg.database.user}"
    else
      "${pkgs.mariadb.client}/bin/mysql --host=${cfg.database.host} --port=${toString cfg.database.port} --user=${cfg.database.user}";

in
{
  options.services.seafile = with lib; {
    enable = mkEnableOption "Seafile server";

    serverHostname = mkOption {
      type = types.singleLineStr;
      example = "seafile.example.com";
      description = ''
        Public hostname of the Seafile server. Used to build SERVICE_URL and
        FILE_SERVER_ROOT throughout the configuration.
      '';
    };

    serverProtocol = mkOption {
      type = types.enum [
        "http"
        "https"
      ];
      default = "https";
      description = "Protocol used to access the Seafile web interface.";
    };

    database = {
      createLocally = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to create and manage a local MariaDB instance for Seafile.
          When true, the service connects via Unix socket and no password is needed.
          When false, set {option}`services.seafile.database.host`,
          {option}`services.seafile.database.port`, and
          {option}`services.seafile.database.passwordFile`.
        '';
      };

      host = mkOption {
        type = types.singleLineStr;
        default = "localhost";
        description = "Database server hostname or IP address.";
      };

      port = mkOption {
        type = types.port;
        default = 3306;
        description = "Database server TCP port.";
      };

      user = mkOption {
        type = types.singleLineStr;
        default = defaultUser;
        description = "Database user Seafile connects as.";
      };

      passwordFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/run/secrets/seafile-db-password";
        description = ''
          Path to a file containing the database password.
          Not required when {option}`services.seafile.database.createLocally`
          is true (Unix socket peer authentication is used in that case).
        '';
      };

      ccnetDbName = mkOption {
        type = types.singleLineStr;
        default = "ccnet_db";
        description = "Name of the ccnet database.";
      };

      seafileDbName = mkOption {
        type = types.singleLineStr;
        default = "seafile_db";
        description = "Name of the seafile database.";
      };

      seahubDbName = mkOption {
        type = types.singleLineStr;
        default = "seahub_db";
        description = "Name of the seahub database.";
      };
    };

    cache = {
      provider = mkOption {
        type = types.enum [
          "redis"
          "memcached"
        ];
        default = "redis";
        description = ''
          Cache backend to use. Redis is the default and recommended choice in
          Seafile 13.0. When set to `redis` and
          {option}`services.seafile.cache.createLocally` is true a dedicated
          Redis instance is started automatically.
        '';
      };

      createLocally = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to start a local Redis instance for Seafile.
          Only applies when {option}`services.seafile.cache.provider` is
          `redis`.
        '';
      };

      host = mkOption {
        type = types.singleLineStr;
        default = "127.0.0.1";
        description = "Cache server host.";
      };

      port = mkOption {
        type = types.port;
        default = 6379;
        description = "Cache server TCP port.";
      };
    };

    jwtPrivateKeyFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/seafile-jwt-key";
      description = ''
        Path to a file containing the JWT private key used for internal
        service authentication. If null, a 256-bit key is generated
        automatically on first start and persisted at
        {file}`/var/lib/seafile/.jwtKey`.
      '';
    };

    seafileSettings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;

        options = {
          fileserver = {
            port = mkOption {
              type = types.port;
              default = 8082;
              description = "TCP port the seafile file server listens on.";
            };

            host = mkOption {
              type = types.singleLineStr;
              default = "127.0.0.1";
              description = ''
                Address the file server binds to. Keep `127.0.0.1` when
                behind a reverse proxy (recommended).
              '';
            };
          };
        };
      };
      default = { };
      description = ''
        Configuration for seafile-server written to {file}`seafile.conf`.
        In Seafile 13.0 only the `[fileserver]` section belongs here;
        database, cache, and storage backend settings now live in the
        generated {file}`.env` file.
        See <https://manual.seafile.com/latest/config/seafile-conf/> for all
        available options.
      '';
    };

    seahubAddress = mkOption {
      type = types.singleLineStr;
      default = "unix:/run/seahub/gunicorn.sock";
      example = "127.0.0.1:8000";
      description = ''
        Address gunicorn binds for Seahub. Accepts HOST, HOST:PORT, or
        unix:PATH.
      '';
    };

    workers = mkOption {
      type = types.int;
      default = 4;
      example = 8;
      description = "Number of gunicorn worker processes for Seahub.";
    };

    adminEmail = mkOption {
      type = types.singleLineStr;
      example = "admin@example.com";
      description = "Email address for the initial Seafile admin account.";
    };

    initialAdminPasswordFile = mkOption {
      type = types.path;
      example = "/run/secrets/seafile-admin-password";
      description = ''
        Path to a file containing the initial admin account password.
        Used only during first-time setup; change it afterward through the
        Seahub web interface.
      '';
    };

    seahubPackage = mkPackageOption pkgs "seahub" { };

    user = mkOption {
      type = types.singleLineStr;
      default = defaultUser;
      description = "System user that Seafile services run as.";
    };

    group = mkOption {
      type = types.singleLineStr;
      default = defaultUser;
      description = "System group that Seafile services run as.";
    };

    dataDir = mkOption {
      type = types.path;
      default = "${seafRoot}/data";
      description = "Directory where Seafile stores library data blocks.";
    };

    gc = {
      enable = mkEnableOption "scheduled garbage collection of unreferenced data blocks";

      dates = mkOption {
        type = types.listOf types.singleLineStr;
        default = [ "Sun 03:00:00" ];
        description = ''
          When to run garbage collection. Accepts systemd calendar expressions;
          see {manpage}`systemd.time(7)`.
        '';
      };

      randomizedDelaySec = mkOption {
        type = types.singleLineStr;
        default = "0";
        example = "30min";
        description = ''
          Add a random delay before each garbage collection run.
          See {manpage}`systemd.time(7)` for the time format.
        '';
      };

      persistent = mkOption {
        type = types.bool;
        default = true;
        description = ''
          If true, the timer catches up on missed GC runs after the system
          resumes from sleep or downtime.
        '';
      };
    };

    seahubExtraConf = mkOption {
      type = types.lines;
      default = "";
      example = ''
        ENABLE_SIGNUP = False
        TIME_ZONE = 'Europe/Berlin'
      '';
      description = ''
        Additional Python configuration appended verbatim to
        {file}`seahub_settings.py`. See
        <https://manual.seafile.com/latest/config/seahub_settings_py/> for all
        available options.
      '';
    };
  };

  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion = cfg.database.createLocally -> cfg.database.host == "localhost";
        message = "services.seafile.database.host must be 'localhost' when createLocally is true";
      }
      {
        assertion = !cfg.database.createLocally -> cfg.database.passwordFile != null;
        message = "services.seafile.database.passwordFile must be set when createLocally is false";
      }
    ];

    services.mysql = lib.mkIf cfg.database.createLocally {
      enable = true;
      package = lib.mkDefault pkgs.mariadb;
      ensureDatabases = [
        cfg.database.ccnetDbName
        cfg.database.seafileDbName
        cfg.database.seahubDbName
      ];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensurePermissions = {
            "${cfg.database.ccnetDbName}.*" = "ALL PRIVILEGES";
            "${cfg.database.seafileDbName}.*" = "ALL PRIVILEGES";
            "${cfg.database.seahubDbName}.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    services.redis.servers.seafile =
      lib.mkIf (cfg.cache.provider == "redis" && cfg.cache.createLocally)
        {
          enable = true;
          bind = cfg.cache.host;
          port = cfg.cache.port;
        };

    users.users = lib.optionalAttrs (cfg.user == defaultUser) {
      "${defaultUser}" = {
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = lib.optionalAttrs (cfg.group == defaultUser) {
      "${defaultUser}" = { };
    };

    systemd.targets.seafile = {
      wantedBy = [ "multi-user.target" ];
      description = "Seafile server components";
    };

    systemd.services = {

      seaf-server = {
        description = "Seafile file server daemon";
        partOf = [ "seafile.target" ];
        wantedBy = [ "seafile.target" ];
        unitConfig.RequiresMountsFor = lib.optional (cfg.dataDir != "${seafRoot}/data") cfg.dataDir;
        requires = lib.optional cfg.database.createLocally "mysql.service";
        after = [
          "network.target"
        ]
        ++ lib.optional cfg.database.createLocally "mysql.service"
        ++ lib.optional (cfg.cache.provider == "redis" && cfg.cache.createLocally) "redis-seafile.service";

        restartTriggers = [
          seafileConf
          seahubSettings
        ];

        serviceConfig = serviceHardening // {
          ExecStart = ''
            ${lib.getExe cfg.seahubPackage.seafile-server} \
              --foreground \
              -F ${confDir} \
              -c ${ccnetDir} \
              -d ${cfg.dataDir} \
              -l /var/log/seafile/server.log \
              -P /run/seafile/server.pid \
              -p /run/seafile
          '';
        };

        preStart = ''
          ${generateEnvScript}

          install -d -m 0750 ${ccnetDir}
          install -d -m 0750 ${cfg.dataDir}/library-template

          ${lib.optionalString (!cfg.database.createLocally && cfg.database.passwordFile != null) ''
            export MYSQL_PWD=$(cat ${lib.escapeShellArg cfg.database.passwordFile})
          ''}

          if [ ! -f "${seafRoot}/server-setup" ]; then
            # Load SQL schemas on first install.
            # ccnet.sql is optional (ccnet DB was folded into seafile-server in 11.0).
            ccnet_sql="${cfg.seahubPackage.seafile-server}/share/seafile/sql/mysql/ccnet.sql"
            if [ -f "$ccnet_sql" ]; then
              ${mysqlClient} ${cfg.database.ccnetDbName} < "$ccnet_sql"
            fi
            ${mysqlClient} ${cfg.database.seafileDbName} \
              < ${cfg.seahubPackage.seafile-server}/share/seafile/sql/mysql/seafile.sql
            echo "${cfg.seahubPackage.seafile-server.version}" > "${seafRoot}/server-setup"
          fi

          installedVer=$(cat "${seafRoot}/server-setup")
          pkgVer="${cfg.seahubPackage.seafile-server.version}"
          if [ "$installedVer" != "$pkgVer" ]; then
            echo "Seafile data was initialised with $installedVer; current package is $pkgVer." >&2
            echo "Run the appropriate upgrade scripts before starting." >&2
            exit 1
          fi
        '';

        # Fix Unix socket permissions if the file server was configured to use one.
        postStart =
          let
            fsHost = cfg.seafileSettings.fileserver.host or "";
          in
          lib.optionalString (lib.hasPrefix "unix:" fsHost) ''
            sock="${lib.removePrefix "unix:" fsHost}"
            while [ ! -S "$sock" ]; do sleep 1; done
            chmod 666 "$sock"
          '';
      };

      seahub = {
        description = "Seahub – Seafile web frontend";
        partOf = [ "seafile.target" ];
        wantedBy = [ "seafile.target" ];
        unitConfig.RequiresMountsFor = lib.optional (cfg.dataDir != "${seafRoot}/data") cfg.dataDir;
        requires = [ "seaf-server.service" ] ++ lib.optional cfg.database.createLocally "mysql.service";
        after = [
          "network.target"
          "seaf-server.service"
        ]
        ++ lib.optional cfg.database.createLocally "mysql.service";

        restartTriggers = [ seahubSettings ];

        environment = {
          PYTHONPATH = "${cfg.seahubPackage.pythonPath}:${cfg.seahubPackage}/thirdpart:${cfg.seahubPackage}";
          DJANGO_SETTINGS_MODULE = "seahub.settings";
          SEAFILE_CONF_DIR = cfg.dataDir;
          SEAFILE_CENTRAL_CONF_DIR = confDir;
          SEAFILE_RPC_PIPE_PATH = "/run/seafile";
          SEAHUB_LOG_DIR = "/var/log/seafile";
        };

        serviceConfig = serviceHardening // {
          RuntimeDirectory = "seahub";
          ExecStart = ''
            ${lib.getExe cfg.seahubPackage.python3.pkgs.gunicorn} \
              seahub.wsgi:application \
              --name seahub \
              --workers ${toString cfg.workers} \
              --log-level=info \
              --preload \
              --timeout=1200 \
              --limit-request-line=8190 \
              --bind ${cfg.seahubAddress}
          '';
        };

        preStart = ''
          install -d -m 0750 ${seahubDir}/media

          # Symlink package-provided static media, except the writable avatars dir.
          for m in $(find ${cfg.seahubPackage}/media/ -maxdepth 1 -mindepth 1 \
              ! -name "avatars"); do
            ln -sfT "$m" ${seahubDir}/media/"$(basename "$m")"
          done

          # Django secret key — generated once and persisted.
          if [ ! -e "${seafRoot}/.seahubSecret" ]; then
            (umask 077; ${lib.getExe cfg.seahubPackage.python3} \
              ${cfg.seahubPackage}/tools/secret_key_generator.py \
              > "${seafRoot}/.seahubSecret")
          fi

          if [ ! -f "${seafRoot}/seahub-setup" ]; then
            install -D -t ${seahubDir}/media/avatars/ \
              ${cfg.seahubPackage}/media/avatars/default.png
            install -D -t ${seahubDir}/media/avatars/groups \
              ${cfg.seahubPackage}/media/avatars/groups/default.png

            ${cfg.seahubPackage}/manage.py migrate

            ADMIN_PASS=$(cat ${lib.escapeShellArg cfg.initialAdminPasswordFile})
            ${lib.getExe pkgs.expect} -c "
              spawn ${cfg.seahubPackage}/manage.py \
                createsuperuser --email=${lib.escapeShellArg cfg.adminEmail}
              expect \"Password: \"
              send \"\$ADMIN_PASS\r\"
              expect \"Password (again): \"
              send \"\$ADMIN_PASS\r\"
              expect \"Superuser created successfully.\"
            "
            echo "${cfg.seahubPackage.version}" > "${seafRoot}/seahub-setup"
          fi

          if [ "$(cat "${seafRoot}/seahub-setup")" != "${cfg.seahubPackage.version}" ]; then
            ${cfg.seahubPackage}/manage.py migrate
            echo "${cfg.seahubPackage.version}" > "${seafRoot}/seahub-setup"
          fi
        '';
      };

      seaf-gc = {
        description = "Seafile garbage collection";
        # GC must run while the main services are stopped to avoid data races.
        conflicts = [
          "seaf-server.service"
          "seahub.service"
        ];
        after = [
          "seaf-server.service"
          "seahub.service"
        ];
        unitConfig.RequiresMountsFor = lib.optional (cfg.dataDir != "${seafRoot}/data") cfg.dataDir;
        onSuccess = [
          "seaf-server.service"
          "seahub.service"
        ];
        onFailure = [
          "seaf-server.service"
          "seahub.service"
        ];
        startAt = lib.optionals cfg.gc.enable cfg.gc.dates;

        serviceConfig = serviceHardening // {
          Type = "oneshot";
        };

        script = ''
          if [ ! -f "${seafRoot}/server-setup" ]; then
            echo "Server not initialised yet, skipping GC." >&2
            exit 0
          fi

          installedVer=$(cat "${seafRoot}/server-setup")
          pkgVer="${cfg.seahubPackage.seafile-server.version}"
          if [ "$installedVer" != "$pkgVer" ]; then
            echo "Pending upgrade ($installedVer -> $pkgVer), skipping GC." >&2
            exit 0
          fi

          ${cfg.seahubPackage.seafile-server}/bin/seafserv-gc \
            -F ${confDir} \
            -c ${ccnetDir} \
            -d ${cfg.dataDir} \
            --rm-fs
        '';
      };
    };

    systemd.timers.seaf-gc = lib.mkIf cfg.gc.enable {
      timerConfig = {
        RandomizedDelaySec = cfg.gc.randomizedDelaySec;
        Persistent = cfg.gc.persistent;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ philocalyst ];
}
