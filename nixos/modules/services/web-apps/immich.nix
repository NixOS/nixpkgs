{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.immich;
  format = pkgs.formats.json { };
  isPostgresUnixSocket = lib.hasPrefix "/" cfg.database.host;
  isRedisUnixSocket = lib.hasPrefix "/" cfg.redis.host;
  secretsReplacement = utils.genJqSecretsReplacement {
    loadCredential = true;
  } cfg.settings "/run/immich/config.json";

  commonServiceConfig = {
    Type = "simple";
    Restart = "on-failure";
    RestartSec = 3;

    # Hardening
    CapabilityBoundingSet = "";
    NoNewPrivileges = true;
    PrivateUsers = true;
    PrivateTmp = true;
    PrivateDevices = cfg.accelerationDevices == [ ];
    DeviceAllow = mkIf (cfg.accelerationDevices != null) cfg.accelerationDevices;
    PrivateMounts = true;
    ProtectClock = true;
    ProtectControlGroups = true;
    ProtectHome = true;
    ProtectHostname = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    RestrictAddressFamilies = [
      "AF_INET"
      "AF_INET6"
      "AF_UNIX"
    ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    UMask = "0077";
  };
  inherit (lib)
    types
    mkIf
    mkOption
    mkEnableOption
    ;

  postgresqlPackage =
    if cfg.database.enable then config.services.postgresql.package else pkgs.postgresql;
in
{
  imports = [
    (lib.mkRemovedOptionModule
      [
        "services"
        "immich"
        "secretSettings"
      ]
      ''
        `secretSettings` has been deprecated as secrets can now be specified
        directly in `settings`. To do so, set `_secret` of the desired
        attribute to a file path, for example:
          `services.immich.settings.oauth.clientSecret._secret = "/path/to/secret/file";`
      ''
    )
  ];

  options.services.immich = {
    enable = mkEnableOption "Immich";
    package = lib.mkPackageOption pkgs "immich" { };

    mediaLocation = mkOption {
      type = types.path;
      default = "/var/lib/immich";
      description = "Directory used to store media files. If it is not the default, the directory has to be created manually such that the immich user is able to read and write to it.";
    };
    environment = mkOption {
      type = types.submodule { freeformType = types.attrsOf types.str; };
      default = { };
      example = {
        IMMICH_LOG_LEVEL = "verbose";
      };
      description = ''
        Extra configuration environment variables. Refer to the [documentation](https://immich.app/docs/install/environment-variables) for options tagged with 'server', 'api' or 'microservices'.
      '';
    };
    secretsFile = mkOption {
      type = types.nullOr (
        types.str
        // {
          # We don't want users to be able to pass a path literal here but
          # it should look like a path.
          check = it: lib.isString it && lib.types.path.check it;
        }
      );
      default = null;
      example = "/run/secrets/immich";
      description = ''
        Path of a file with extra environment variables to be loaded from disk. This file is not added to the nix store, so it can be used to pass secrets to immich. Refer to the [documentation](https://immich.app/docs/install/environment-variables) for options.

        To set a database password set this to a file containing:
        ```
        DB_PASSWORD=<pass>
        ```
      '';
    };
    host = mkOption {
      type = types.str;
      default = "localhost";
      description = "The host that immich will listen on.";
    };
    port = mkOption {
      type = types.port;
      default = 2283;
      description = "The port that immich will listen on.";
    };
    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open the immich port in the firewall";
    };
    user = mkOption {
      type = types.str;
      default = "immich";
      description = "The user immich should run as.";
    };
    group = mkOption {
      type = types.str;
      default = "immich";
      description = "The group immich should run as.";
    };

    settings = mkOption {
      default = null;
      description = ''
        Configuration for Immich.
        See <https://immich.app/docs/install/config-file/> or navigate to
        <https://my.immich.app/admin/system-settings> for
        options and defaults.
        Setting it to `null` allows configuring Immich in the web interface.
        You can load secret values from a file in this configuration by setting `somevalue._secret = "/path/to/file"` instead of setting `somevalue` directly.
      '';
      type = types.nullOr (
        types.submodule {
          freeformType = format.type;
          options = {
            newVersionCheck.enabled = mkOption {
              type = types.bool;
              default = false;
              description = ''
                Check for new versions.
                This feature relies on periodic communication with github.com.
              '';
            };
            server.externalDomain = mkOption {
              type = types.str;
              default = "";
              description = "Domain for publicly shared links, including `http(s)://`.";
            };
          };
        }
      );
    };

    machine-learning = {
      enable =
        mkEnableOption "immich's machine-learning functionality to detect faces and search for objects"
        // {
          default = true;
        };
      environment = mkOption {
        type = types.submodule { freeformType = types.attrsOf types.str; };
        default = { };
        example = {
          MACHINE_LEARNING_MODEL_TTL = "600";
        };
        description = ''
          Extra configuration environment variables. Refer to the [documentation](https://immich.app/docs/install/environment-variables) for options tagged with 'machine-learning'.
        '';
      };
    };

    accelerationDevices = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = [ ];
      example = [ "/dev/dri/renderD128" ];
      description = ''
        A list of device paths to hardware acceleration devices that immich should
        have access to. This is useful when transcoding media files.
        The special value `[ ]` will disallow all devices using `PrivateDevices`. `null` will give access to all devices.
      '';
    };

    database = {
      enable =
        mkEnableOption "the postgresql database for use with immich. See {option}`services.postgresql`"
        // {
          default = true;
        };
      enableVectorChord =
        mkEnableOption "the new VectorChord extension for full-text search in Postgres"
        // {
          default = true;
        };
      enableVectors =
        mkEnableOption "pgvecto.rs in the database. You may disable this, if you have migrated to VectorChord and deleted the `vectors` schema."
        // {
          default = lib.versionOlder config.system.stateVersion "25.11";
          defaultText = lib.literalExpression "lib.versionOlder config.system.stateVersion \"25.11\"";
        };
      createDB = mkEnableOption "the automatic creation of the database for immich." // {
        default = true;
      };
      name = mkOption {
        type = types.str;
        default = "immich";
        description = "The name of the immich database.";
      };
      host = mkOption {
        type = types.str;
        default = "/run/postgresql";
        example = "127.0.0.1";
        description = "Hostname or address of the postgresql server. If an absolute path is given here, it will be interpreted as a unix socket path.";
      };
      port = mkOption {
        type = types.port;
        default = 5432;
        description = "Port of the postgresql server.";
      };
      user = mkOption {
        type = types.str;
        default = "immich";
        description = "The database user for immich.";
      };
    };
    redis = {
      enable = mkEnableOption "a redis cache for use with immich" // {
        default = true;
      };
      host = mkOption {
        type = types.str;
        default = config.services.redis.servers.immich.unixSocket;
        defaultText = lib.literalExpression "config.services.redis.servers.immich.unixSocket";
        description = "The host that redis will listen on.";
      };
      port = mkOption {
        type = types.port;
        default = 0;
        description = "The port that redis will listen on. Set to zero to disable TCP.";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !isPostgresUnixSocket -> cfg.secretsFile != null;
        message = "A secrets file containing at least the database password must be provided when unix sockets are not used.";
      }
      {
        # When removing this assertion, please adjust the nixosTests accordingly.
        assertion =
          (cfg.database.enable && cfg.database.enableVectors)
          -> lib.versionOlder config.services.postgresql.package.version "17";
        message = "Immich doesn't support PostgreSQL 17+ when using pgvecto.rs. Consider disabling it using services.immich.database.enableVectors if it is not needed anymore.";
      }
      {
        assertion = cfg.database.enable -> (cfg.database.enableVectorChord || cfg.database.enableVectors);
        message = "At least one of services.immich.database.enableVectorChord and services.immich.database.enableVectors has to be enabled.";
      }
    ];

    services.postgresql = mkIf cfg.database.enable {
      enable = true;
      ensureDatabases = mkIf cfg.database.createDB [ cfg.database.name ];
      ensureUsers = mkIf cfg.database.createDB [
        {
          name = cfg.database.user;
          ensureDBOwnership = true;
          ensureClauses.login = true;
        }
      ];
      extensions =
        ps:
        lib.optionals cfg.database.enableVectors [ ps.pgvecto-rs ]
        ++ lib.optionals cfg.database.enableVectorChord [
          ps.pgvector
          ps.vectorchord
        ];
      settings = {
        shared_preload_libraries =
          lib.optionals cfg.database.enableVectors [
            "vectors.so"
          ]
          ++ lib.optionals cfg.database.enableVectorChord [ "vchord.so" ];
        search_path = "\"$user\", public, vectors";
      };
    };
    systemd.services.postgresql-setup.serviceConfig.ExecStartPost =
      let
        extensions = [
          "unaccent"
          "uuid-ossp"
          "cube"
          "earthdistance"
          "pg_trgm"
        ]
        ++ lib.optionals cfg.database.enableVectors [
          "vectors"
        ]
        ++ lib.optionals cfg.database.enableVectorChord [
          "vector"
          "vchord"
        ];
        sqlFile = pkgs.writeText "immich-pgvectors-setup.sql" (
          # save previous version of vectorchord to trigger reindex on update
          lib.optionalString cfg.database.enableVectorChord ''
            SELECT COALESCE(installed_version, ''') AS vchord_version_before FROM pg_available_extensions WHERE name = 'vchord' \gset
          ''
          + ''
            ${lib.concatMapStringsSep "\n" (ext: "CREATE EXTENSION IF NOT EXISTS \"${ext}\";") extensions}
            ${lib.concatMapStringsSep "\n" (ext: "ALTER EXTENSION \"${ext}\" UPDATE;") extensions}
            ALTER SCHEMA public OWNER TO ${cfg.database.user};
          ''
          + lib.optionalString cfg.database.enableVectors ''
            ALTER SCHEMA vectors OWNER TO ${cfg.database.user};
            GRANT SELECT ON TABLE pg_vector_index_stat TO ${cfg.database.user};
          ''
          # trigger reindex if vectorchord updates
          # https://docs.immich.app/administration/postgres-standalone/#updating-vectorchord
          + lib.optionalString cfg.database.enableVectorChord ''
            SELECT COALESCE(installed_version, ''') AS vchord_version_after FROM pg_available_extensions WHERE name = 'vchord' \gset

            SELECT (:'vchord_version_before' != ''' AND :'vchord_version_before' != :'vchord_version_after') AS has_vchord_updated \gset
            \if :has_vchord_updated
              REINDEX INDEX face_index;
              REINDEX INDEX clip_index;
            \endif
          ''
        );
      in
      [
        ''
          ${lib.getExe' postgresqlPackage "psql"} -d "${cfg.database.name}" -f "${sqlFile}"
        ''
      ];

    services.redis.servers = mkIf cfg.redis.enable {
      immich = {
        enable = true;
        port = cfg.redis.port;
        bind = mkIf (!isRedisUnixSocket) cfg.redis.host;
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];

    services.immich.environment =
      let
        postgresEnv =
          if isPostgresUnixSocket then
            { DB_URL = "postgresql:///${cfg.database.name}?host=${cfg.database.host}"; }
          else
            {
              DB_HOSTNAME = cfg.database.host;
              DB_PORT = toString cfg.database.port;
              DB_DATABASE_NAME = cfg.database.name;
              DB_USERNAME = cfg.database.user;
            };
        redisEnv =
          if isRedisUnixSocket then
            { REDIS_SOCKET = cfg.redis.host; }
          else
            {
              REDIS_PORT = toString cfg.redis.port;
              REDIS_HOSTNAME = cfg.redis.host;
            };
      in
      postgresEnv
      // redisEnv
      // {
        IMMICH_HOST = cfg.host;
        IMMICH_PORT = toString cfg.port;
        IMMICH_MEDIA_LOCATION = cfg.mediaLocation;
        IMMICH_MACHINE_LEARNING_URL = "http://localhost:3003";
      }
      // lib.optionalAttrs (cfg.settings != null) {
        IMMICH_CONFIG_FILE = "/run/immich/config.json";
      };

    services.immich.machine-learning.environment = {
      MACHINE_LEARNING_WORKERS = "1";
      MACHINE_LEARNING_WORKER_TIMEOUT = "120";
      MACHINE_LEARNING_CACHE_FOLDER = "/var/cache/immich";
      XDG_CACHE_HOME = "/var/cache/immich";
      IMMICH_HOST = "localhost";
      IMMICH_PORT = "3003";
    };

    systemd.slices.system-immich = {
      description = "Immich (self-hosted photo and video backup solution) slice";
      documentation = [ "https://immich.app/docs" ];
    };

    systemd.services.immich-server = {
      description = "Immich backend server (Self-hosted photo and video backup solution)";
      requires = lib.mkIf cfg.database.enable [ "postgresql.target" ];
      after = [ "network.target" ] ++ lib.optionals cfg.database.enable [ "postgresql.target" ];
      wantedBy = [ "multi-user.target" ];
      inherit (cfg) environment;
      path = [
        # gzip and pg_dumpall are used by the backup service
        pkgs.gzip
        postgresqlPackage
      ];

      preStart = mkIf (cfg.settings != null) secretsReplacement.script;

      serviceConfig = commonServiceConfig // {
        LoadCredential = secretsReplacement.credentials;
        ExecStart = lib.getExe cfg.package;
        EnvironmentFile = mkIf (cfg.secretsFile != null) cfg.secretsFile;
        Slice = "system-immich.slice";
        StateDirectory = "immich";
        SyslogIdentifier = "immich";
        RuntimeDirectory = "immich";
        User = cfg.user;
        Group = cfg.group;
        # ensure that immich-server has permission to connect to the redis socket.
        SupplementaryGroups = mkIf (cfg.redis.enable && isRedisUnixSocket) [
          config.services.redis.servers.immich.group
        ];
      };
    };

    systemd.services.immich-machine-learning = mkIf cfg.machine-learning.enable {
      description = "immich machine learning";
      requires = lib.mkIf cfg.database.enable [ "postgresql.target" ];
      after = [ "network.target" ] ++ lib.optionals cfg.database.enable [ "postgresql.target" ];
      wantedBy = [ "multi-user.target" ];
      inherit (cfg.machine-learning) environment;
      serviceConfig = commonServiceConfig // {
        ExecStart = lib.getExe cfg.package.machine-learning;
        Slice = "system-immich.slice";
        CacheDirectory = "immich";
        User = cfg.user;
        Group = cfg.group;
      };
    };

    systemd.tmpfiles.settings = {
      immich = {
        # Redundant to the `UMask` service config setting on new installs, but installs made in
        # early 24.11 created world-readable media storage by default, which is a privacy risk. This
        # fixes those installs.
        "${cfg.mediaLocation}" = {
          e = {
            user = cfg.user;
            group = cfg.group;
            mode = "0700";
          };
        };
      };
    };

    users.users = mkIf (cfg.user == "immich") {
      immich = {
        name = "immich";
        group = cfg.group;
        isSystemUser = true;
      };
    };
    users.groups = mkIf (cfg.group == "immich") { immich = { }; };
  };
  meta = {
    maintainers = with lib.maintainers; [ jvanbruegge ];
    doc = ./immich.md;
  };
}
