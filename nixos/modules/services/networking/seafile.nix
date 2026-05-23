{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkOption
    mkEnableOption
    mkPackageOption
    types
    ;

  cfg = config.services.seafile;
  iniFormat = pkgs.formats.ini { };

  seafRoot = "/var/lib/seafile";
  ccnetDir = "${seafRoot}/ccnet";
  seahubDir = "${seafRoot}/seahub";
  confDir = "${seafRoot}/conf";
  defaultUser = "seafile";

  # seafile.conf: in 13.0 only [fileserver] belongs here.
  seafileConf = iniFormat.generate "seafile.conf" (
    lib.recursiveUpdate {
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

  # Static (non-secret) environment variables defined as a native Nix attrset.
  staticEnvAttrs = {
    SEAFILE_SERVER_PROTOCOL = cfg.serverProtocol;
    SEAFILE_SERVER_HOSTNAME = cfg.serverHostname;
    SEAFILE_MYSQL_DB_HOST = cfg.database.host;
    SEAFILE_MYSQL_DB_PORT = toString cfg.database.port;
    SEAFILE_MYSQL_DB_USER = cfg.database.user;
    SEAFILE_MYSQL_DB_CCNET_DB_NAME = cfg.database.ccnetDbName;
    SEAFILE_MYSQL_DB_SEAFILE_DB_NAME = cfg.database.seafileDbName;
    SEAFILE_MYSQL_DB_SEAHUB_DB_NAME = cfg.database.seahubDbName;
    CACHE_PROVIDER = cfg.cache.provider;
    TIME_ZONE = cfg.timeZone;
    SITE_ROOT = cfg.siteRoot;
    ENABLE_GO_FILESERVER = lib.boolToString cfg.enableGoFileserver;
  }
  // lib.optionalAttrs (cfg.cache.provider == "redis") {
    REDIS_HOST = cfg.cache.host;
    REDIS_PORT = toString cfg.cache.port;
  }
  // lib.optionalAttrs (cfg.cache.provider == "memcached") {
    MEMCACHED_HOST = cfg.cache.host;
    MEMCACHED_PORT = toString cfg.cache.port;
  };

  # Automatically format the attrset into KEY=value format.
  staticEnvFile = pkgs.writeText "seafile-static.env" (lib.generators.toKeyValue { } staticEnvAttrs);

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

  readSecret =
    varName: filePath:
    if filePath != null then
      "printf '${varName}=%s\\n' \"$(< ${lib.escapeShellArg filePath})\""
    else
      "echo '${varName}='";

  # Pre-computed bash snippets for injecting secrets at runtime.
  dbSecretSnippet = readSecret "SEAFILE_MYSQL_DB_PASSWORD" cfg.database.passwordFile;

  redisSecretSnippet = lib.optionalString (cfg.cache.provider == "redis") (
    readSecret "REDIS_PASSWORD" cfg.cache.passwordFile
  );

  jwtSecretSnippet =
    if cfg.jwtPrivateKeyFile != null then
      readSecret "JWT_PRIVATE_KEY" cfg.jwtPrivateKeyFile
    else
      ''
        if [[ ! -f "${seafRoot}/.jwtKey" ]]; then
          (umask 077; ${lib.getExe' pkgs.openssl "openssl"} rand -hex 32 > "${seafRoot}/.jwtKey")
        fi
        printf 'JWT_PRIVATE_KEY=%s\n' "$(< "${seafRoot}/.jwtKey")"
      '';

  generateEnvScript = ''
    install -d -m 0750 "${confDir}"

    (
      umask 027
      cat ${staticEnvFile}
      ${dbSecretSnippet}
      ${redisSecretSnippet}
      ${jwtSecretSnippet}
    ) > "${confDir}/.env"

    cp -f ${seafileConf} "${confDir}/seafile.conf"
    cp -f ${seahubSettings} "${confDir}/seahub_settings.py"
    chmod 640 "${confDir}/seafile.conf" "${confDir}/seahub_settings.py"
  '';

  # MySQL client string correctly escaped as a list of arguments.
  mysqlClient = lib.escapeShellArgs (
    [ (lib.getExe' pkgs.mariadb.client "mysql") ]
    ++ (
      if cfg.database.createLocally then
        [
          "--socket=/run/mysqld/mysqld.sock"
          "--user=${cfg.database.user}"
        ]
      else
        [
          "--host=${cfg.database.host}"
          "--port=${toString cfg.database.port}"
          "--user=${cfg.database.user}"
        ]
    )
  );

  # Module-managed local cache unit(s), for service ordering.
  localCacheUnits = lib.optionals cfg.cache.createLocally (
    {
      redis = [ "redis-seafile.service" ];
      memcached = [ "memcached.service" ];
    }
    .${cfg.cache.provider}
  );

in
{
  options.services.seafile = {
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
        default = if cfg.cache.provider == "memcached" then 11211 else 6379;
        defaultText = lib.literalExpression ''if cfg.cache.provider == "memcached" then 11211 else 6379'';
        description = ''
          Cache server TCP port. Defaults to the standard port for the selected
          {option}`services.seafile.cache.provider` (6379 for redis, 11211 for
          memcached).
        '';
      };

      passwordFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/run/secrets/seafile-redis-password";
        description = ''
          Path to a file containing the cache server password
          (`REDIS_PASSWORD`). Only used with the `redis` provider; leave null
          for a passwordless cache such as the default local instance.
        '';
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

    timeZone = mkOption {
      type = types.singleLineStr;
      default = "UTC";
      example = "Europe/Berlin";
      description = ''
        Time zone used by the server (`TIME_ZONE`). Affects timestamps shown in
        Seahub and the timing of scheduled server-side jobs.
      '';
    };

    siteRoot = mkOption {
      type = types.singleLineStr;
      default = "/";
      example = "/seafile/";
      description = ''
        URL path Seafile is served under (`SITE_ROOT`). Set this when hosting
        Seafile on a sub-path behind a reverse proxy rather than at the domain
        root. Must start and end with a slash.
      '';
    };

    enableGoFileserver = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Use the Go implementation of the file server (`ENABLE_GO_FILESERVER`).
        It is the recommended, more performant fileserver in Seafile 13.0.
      '';
    };

    seafileSettings = mkOption {
      type = types.submodule {
        freeformType = iniFormat.type;

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
      {
        assertion = !(cfg.seafileSettings ? database || cfg.seafileSettings ? memcached);
        message = "services.seafile.seafileSettings must not set the obsolete [database] or [memcached] sections; use services.seafile.database.* and services.seafile.cache.* instead";
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

    services.memcached = lib.mkIf (cfg.cache.provider == "memcached" && cfg.cache.createLocally) {
      enable = true;
      listen = cfg.cache.host;
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

      # Generates the runtime .env, seafile.conf and seahub_settings.py before
      # any daemon starts. This must be a separate unit because systemd reads a
      # service's EnvironmentFile= at activation time
      seaf-init = {
        description = "Seafile runtime configuration";
        partOf = [ "seafile.target" ];
        wantedBy = [ "seafile.target" ];
        restartTriggers = [
          seafileConf
          seahubSettings
          staticEnvFile
        ];
        serviceConfig = serviceHardening // {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = generateEnvScript;
      };

      seaf-server = {
        description = "Seafile file server daemon";
        partOf = [ "seafile.target" ];
        wantedBy = [ "seafile.target" ];
        unitConfig.RequiresMountsFor = lib.optional (cfg.dataDir != "${seafRoot}/data") cfg.dataDir;
        requires = [ "seaf-init.service" ] ++ lib.optional cfg.database.createLocally "mysql.service";
        after = [
          "network.target"
          "seaf-init.service"
        ]
        ++ lib.optional cfg.database.createLocally "mysql.service"
        ++ localCacheUnits;

        restartTriggers = [
          seafileConf
          seahubSettings
        ];

        serviceConfig = serviceHardening // {
          EnvironmentFile = "${confDir}/.env";
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
          CCNET_DIRECTORY="${ccnetDir}"
          DATA_DIRECTORY="${cfg.dataDir}"
          ROOT_DIRECTORY="${seafRoot}"
          TARGET_PACKAGE_VERSION="${cfg.seahubPackage.seafile-server.version}"
          SQL_SHARE_DIRECTORY="${cfg.seahubPackage.seafile-server}/share/seafile/sql/mysql"
          MYSQL_EXECUTABLE="${mysqlClient}"
          CCNET_DATABASE_NAME="${cfg.database.ccnetDbName}"
          SEAFILE_DATABASE_NAME="${cfg.database.seafileDbName}"

          # Resolve the optional Nix logic into a clean string for Bash to evaluate later
          DATABASE_PASSWORD_FILE="${
            lib.optionalString (
              !cfg.database.createLocally && cfg.database.passwordFile != null
            ) cfg.database.passwordFile
          }"

          SETUP_STATE_FILE="$ROOT_DIRECTORY/server-setup"

          initialize_core_directories() {
            install -d -m 0750 "$CCNET_DIRECTORY"
            install -d -m 0750 "$DATA_DIRECTORY/library-template"
          }

          authenticate_database() {
            # If the Nix module provided a password file path, export it for MySQL
            if [[ -n "$DATABASE_PASSWORD_FILE" ]]; then
              export MYSQL_PWD=$(cat "$DATABASE_PASSWORD_FILE")
            fi
          }

          initialize_database_schemas() {
            # Bail early if the server has already been initialized
            [[ -f "$SETUP_STATE_FILE" ]] && return 0

            local ccnet_sql_path="$SQL_SHARE_DIRECTORY/ccnet.sql"
            local seafile_sql_path="$SQL_SHARE_DIRECTORY/seafile.sql"

            # ccnet.sql is optional (the ccnet database was folded into seafile-server in 11.0)
            if [[ -f "$ccnet_sql_path" ]]; then
              "$MYSQL_EXECUTABLE" "$CCNET_DATABASE_NAME" < "$ccnet_sql_path"
            fi

            "$MYSQL_EXECUTABLE" "$SEAFILE_DATABASE_NAME" < "$seafile_sql_path"

            # Record the version state
            echo "$TARGET_PACKAGE_VERSION" > "$SETUP_STATE_FILE"
          }

          enforce_version_match() {
            local installed_version
            installed_version=$(cat "$SETUP_STATE_FILE")

            if [[ "$installed_version" != "$TARGET_PACKAGE_VERSION" ]]; then
              echo "Seafile data was initialized with version $installed_version, but the current package is $TARGET_PACKAGE_VERSION." >&2
              echo "Manual upgrade scripts must be run before starting the server." >&2
              exit 1
            fi
          }

          initialize_core_directories
          authenticate_database
          initialize_database_schemas
          enforce_version_match
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
        requires = [
          "seaf-init.service"
          "seaf-server.service"
        ]
        ++ lib.optional cfg.database.createLocally "mysql.service";
        after = [
          "network.target"
          "seaf-init.service"
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
          EnvironmentFile = "${confDir}/.env";
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
          PACKAGE_DIRECTORY="${cfg.seahubPackage}"
          MEDIA_DIRECTORY="${seahubDir}/media"
          ROOT_DIRECTORY="${seafRoot}"
          CURRENT_VERSION="${cfg.seahubPackage.version}"

          initialize_media_directory() {
            install -d -m 0750 "$MEDIA_DIRECTORY"
          }

          symlink_static_media() {
            # Symlink package-provided static media, excluding writable directories.
            for media_path in "$PACKAGE_DIRECTORY/media/"*; do
              local base_name
              base_name=$(basename "$media_path")

              if [[ "$base_name" != "avatars" && "$base_name" != "assets" ]]; then
                ln -sfT "$media_path" "$MEDIA_DIRECTORY/$base_name"
              fi
            done
          }

          sync_assets_and_collect_static() {
            local version_file="$ROOT_DIRECTORY/seahub-static"
            local deployed_version=""

            [[ -e "$version_file" ]] && deployed_version=$(cat "$version_file")

            if [[ ! -e "$MEDIA_DIRECTORY/assets" ]] || [[ "$deployed_version" != "$CURRENT_VERSION" ]]; then
              rm -rf "$MEDIA_DIRECTORY/assets"
              cp -r --no-preserve=mode,ownership "$PACKAGE_DIRECTORY/media/assets" "$MEDIA_DIRECTORY/assets"

              "$PACKAGE_DIRECTORY/manage.py" collectstatic --noinput
              echo "$CURRENT_VERSION" > "$version_file"
            fi
          }

          ensure_django_secret_key() {
            local secret_file="$ROOT_DIRECTORY/.seahubSecret"

            if [[ ! -e "$secret_file" ]]; then
              (
                umask 077
                ${lib.getExe cfg.seahubPackage.python3} "$PACKAGE_DIRECTORY/tools/secret_key_generator.py" > "$secret_file"
              )
            fi
          }

          setup_initial_avatars() {
            install -D -t "$MEDIA_DIRECTORY/avatars/" "$PACKAGE_DIRECTORY/media/avatars/default.png"
            install -D -t "$MEDIA_DIRECTORY/avatars/groups" "$PACKAGE_DIRECTORY/media/avatars/groups/default.png"
          }

          create_superuser() {
            local admin_password
            admin_password=$(cat ${lib.escapeShellArg cfg.initialAdminPasswordFile})

            ${lib.getExe pkgs.expect} -c "
              spawn $PACKAGE_DIRECTORY/manage.py createsuperuser --email=${lib.escapeShellArg cfg.adminEmail}
              expect \"Password: \"
              send \"\$admin_password\r\"
              expect \"Password (again): \"
              send \"\$admin_password\r\"
              expect \"Superuser created successfully.\"
            "
          }

          process_database_migrations() {
            local setup_state_file="$ROOT_DIRECTORY/seahub-setup"
            local previous_version=""

            [[ -f "$setup_state_file" ]] && previous_version=$(cat "$setup_state_file")

            # Bail early if the database is already fully up-to-date
            [[ "$previous_version" == "$CURRENT_VERSION" ]] && return 0

            if [[ -z "$previous_version" ]]; then
              # First-time initial setup
              setup_initial_avatars
              "$PACKAGE_DIRECTORY/manage.py" migrate
              create_superuser
            else
              # Standard upgrade path
              "$PACKAGE_DIRECTORY/manage.py" migrate
            fi

            # Record the version state once for both paths
            echo "$CURRENT_VERSION" > "$setup_state_file"
          }

          initialize_media_directory
          symlink_static_media
          sync_assets_and_collect_static
          ensure_django_secret_key
          process_database_migrations
        '';
      };

      seaf-gc = {
        description = "Seafile garbage collection";
        # GC must run while the main services are stopped to avoid data races.
        conflicts = [
          "seaf-server.service"
          "seahub.service"
        ];
        requires = [ "seaf-init.service" ];
        after = [
          "seaf-init.service"
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
          EnvironmentFile = "${confDir}/.env";
          Type = "oneshot";
        };

        script = ''
          ROOT_DIRECTORY="${seafRoot}"
          CONFIGURATION_DIRECTORY="${confDir}"
          CCNET_DIRECTORY="${ccnetDir}"
          DATA_DIRECTORY="${cfg.dataDir}"
          TARGET_PACKAGE_VERSION="${cfg.seahubPackage.seafile-server.version}"
          GARBAGE_COLLECTION_EXECUTABLE="${cfg.seahubPackage.seafile-server}/bin/seafserv-gc"

          SETUP_STATE_FILE="$ROOT_DIRECTORY/server-setup"

          abort_if_uninitialized() {
            if [[ ! -f "$SETUP_STATE_FILE" ]]; then
              echo "Server not initialized yet. Skipping garbage collection." >&2
              exit 0
            fi
          }

          abort_if_upgrade_pending() {
            local installed_version
            installed_version=$(cat "$SETUP_STATE_FILE")

            if [[ "$installed_version" != "$TARGET_PACKAGE_VERSION" ]]; then
              echo "Pending upgrade detected ($installed_version -> $TARGET_PACKAGE_VERSION). Skipping garbage collection." >&2
              exit 0
            fi
          }

          execute_garbage_collection() {
            "$GARBAGE_COLLECTION_EXECUTABLE" \
              -F "$CONFIGURATION_DIRECTORY" \
              -c "$CCNET_DIRECTORY" \
              -d "$DATA_DIRECTORY" \
              --rm-fs
          }

          abort_if_uninitialized
          abort_if_upgrade_pending
          execute_garbage_collection
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
