{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.twenty;
  inherit (lib)
    types
    mkIf
    mkOption
    mkEnableOption
    ;
  localDbName = "twenty";
in
{
  options.services.twenty = {
    enable = mkEnableOption "Twenty";
    package = lib.mkPackageOption pkgs "twenty" { };

    port = mkOption {
      type = types.port;
      default = 3000;
      description = "The port that Twenty will listen on.";
    };

    serverUrl = mkOption {
      type = types.str;
      example = "http://localhost:3000";
      description = "Base URL for the server.";
    };

    openFirewall = lib.mkEnableOption "open the Twenty TCP port in the firewall";

    storage.local.enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to enable local storage.

        If you disable this, you will need to manually configure some other type of storage,
        such as [S3 Storage](https://docs.twenty.com/developers/self-host/capabilities/setup#s3-storage).
      '';
    };

    encryptionKeyFile = mkOption {
      type = lib.types.externalPath;
      description = ''
        Primary key used to encrypt secrets at rest.

        Generate by running `openssl rand -base64 32`.

        <https://docs.twenty.com/developers/self-host/capabilities/setup#encryption-keys>
      '';
    };

    environmentVariables = mkOption {
      type = types.attrsOf types.str;
      description = ''
        Additional environment variables to provide to Twenty. See [Twenty setup].

        If you are providing secrets please consider the options under {option}`services.twenty.secretsFile`.

        [Twenty setup]: https://docs.twenty.com/developers/self-host/capabilities/setup
      '';
      default = { };
    };

    secretsFile = mkOption {
      type = types.nullOr types.externalPath;
      default = null;
      example = "/run/secrets/twenty";
      description = ''
        Path of a file with extra environment variables to be loaded from disk.
        This file is not added to the nix store, so it can be used to pass secrets
        to Twenty. Refer to the [documentation][Twenty setup]
        for options.

        To set a database password set this to a file containing a [PostgreSQL connection uri]:
        ```
        PG_DATABASE_URL=postgres://...
        ```

        To configure redis, include a [Redis Connection URL].
        Note that it must be compatible with both `node-redis` and `ioredis`!
        See <https://github.com/twentyhq/twenty/issues/28660> for more detail.
        ```
        REDIS_URL=redis://...
        ```

        [Twenty setup]: https://docs.twenty.com/developers/self-host/capabilities/setup
        [PostgreSQL connection uri]: https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-CONNSTRING-URIS
        [Redis Connection URL]: https://redis.io/docs/latest/develop/clients/connection-urls/
      '';

    };

    database.createLocally = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to enable and set up PostgreSQL locally.

        If instead you want to connect to a remote database,
        set `PG_DATABASE_URL` in {option}`services.twenty.secretsFile`.
      '';
    };

    redis = {
      createLocally = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable and set up a Redis database locally.

          If instead you want to connect to a remote redis,
          set `REDIS_URL` in {option}`services.twenty.secretsFile`.
        '';
      };
      port = mkOption {
        type = types.port;
        default = 18243;
        description = ''
          Port for Redis to listen on.

          Ideally we would disable TCP entirely and connect to Redis over a Unix socket,
          but Twenty doesn't support connecting to Redis over a socket:
          <https://github.com/twentyhq/twenty/issues/28660>

          If Twenty gains support for connecting via a Unix socket,
          this option will be removed!
        '';
      };
    };
  };

  config = mkIf cfg.enable (
    let
      sharedEnv = {
        NODE_PORT = toString cfg.port;
        SERVER_URL = cfg.serverUrl;
        PG_DATABASE_URL = mkIf cfg.database.createLocally "postgresql:///${localDbName}?host=/run/postgresql&user=twenty";
        REDIS_URL = mkIf cfg.redis.createLocally "redis://127.0.0.1:${toString cfg.redis.port}?db=0";

        STORAGE_TYPE = mkIf cfg.storage.local.enable "local";
        STORAGE_LOCAL_PATH = mkIf cfg.storage.local.enable "%S/twenty/storage";
      }
      // cfg.environmentVariables;
    in
    {
      services.postgresql = lib.mkIf cfg.database.createLocally {
        enable = true;
        ensureDatabases = [ localDbName ];
        ensureUsers = [
          {
            name = "twenty";
            ensureDBOwnership = true;
          }
        ];

        # Allow both `twenty-server` and `twenty-worker` to log in as the `twenty` role/user.
        identMap = ''
          twenty-map twenty-server twenty
          twenty-map twenty-worker twenty
        '';
        authentication = ''
          local ${localDbName} twenty peer map=twenty-map
        '';
      };

      services.redis.servers.twenty = {
        enable = cfg.redis.createLocally;
        port = cfg.redis.port;
      };

      systemd.services.twenty-server = {
        requires = lib.mkIf cfg.database.createLocally [ "postgresql.target" ];
        after = [ "network.target" ] ++ lib.optionals cfg.database.createLocally [ "postgresql.target" ];
        wantedBy = [ "multi-user.target" ];
        environment = sharedEnv;

        script = ''
          export ENCRYPTION_KEY=$(<"$CREDENTIALS_DIRECTORY/encryption-key")

          exec ${lib.getExe' cfg.package "twenty-server"}
        '';

        serviceConfig = {
          LoadCredential = [ "encryption-key:${cfg.encryptionKeyFile}" ];
          EnvironmentFile = mkIf (cfg.secretsFile != null) cfg.secretsFile;
          DynamicUser = true;
          Type = "simple";
          Restart = "on-failure";
          RestartSec = 3;
          StateDirectory = "twenty";
        };
      };

      systemd.services.twenty-worker = {
        requires = lib.mkIf cfg.database.createLocally [ "postgresql.target" ];
        after = [
          "network.target"
          "twenty-server.service"
        ]
        ++ lib.optionals cfg.database.createLocally [ "postgresql.target" ];
        wantedBy = [ "multi-user.target" ];
        environment = sharedEnv // {
          # The server is responsible for these tasks.
          # https://github.com/twentyhq/twenty/blob/twenty/v2.45.0/packages/twenty-docker/docker-compose.yml#L75-L76
          DISABLE_DB_MIGRATIONS = "true";
          DISABLE_CRON_JOBS_REGISTRATION = "true";
        };

        script = ''
          export ENCRYPTION_KEY=$(<"$CREDENTIALS_DIRECTORY/encryption-key")

          exec ${lib.getExe' cfg.package "twenty-worker"}
        '';

        serviceConfig = {
          LoadCredential = [ "encryption-key:${cfg.encryptionKeyFile}" ];
          EnvironmentFile = mkIf (cfg.secretsFile != null) cfg.secretsFile;
          DynamicUser = true;
          Type = "simple";
          Restart = "on-failure";
          RestartSec = 3;
          StateDirectory = "twenty";
        };
      };
      networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
    }
  );

  meta.maintainers = with lib.maintainers; [ jfly ];
}
