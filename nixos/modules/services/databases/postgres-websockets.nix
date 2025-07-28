{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.postgres-websockets;

  # Turns an attrset of libpq connection params:
  #   {
  #     dbname = "postgres";
  #     user = "authenticator";
  #   }
  # into a libpq connection string:
  #   dbname=postgres user=authenticator
  PGWS_DB_URI = lib.pipe cfg.environment.PGWS_DB_URI [
    (lib.filterAttrs (_: v: v != null))
    (lib.mapAttrsToList (k: v: "${k}='${lib.escape [ "'" "\\" ] v}'"))
    (lib.concatStringsSep " ")
  ];
in

{
  meta = {
    maintainers = with lib.maintainers; [ wolfgangwalther ];
  };

  options.services.postgres-websockets = {
    enable = lib.mkEnableOption "postgres-websockets";

    pgpassFile = lib.mkOption {
      type =
        with lib.types;
        nullOr (pathWith {
          inStore = false;
          absolute = true;
        });
      default = null;
      example = "/run/keys/db_password";
      description = ''
        The password to authenticate to PostgreSQL with.
        Not needed for peer or trust based authentication.

        The file must be a valid `.pgpass` file as described in:
        <https://www.postgresql.org/docs/current/libpq-pgpass.html>

        In most cases, the following will be enough:
        ```
        *:*:*:*:<password>
        ```
      '';
    };

    jwtSecretFile = lib.mkOption {
      type =
        with lib.types;
        nullOr (pathWith {
          inStore = false;
          absolute = true;
        });
      example = "/run/keys/jwt_secret";
      description = ''
        Secret used to sign JWT tokens used to open communications channels.
      '';
    };

    environment = lib.mkOption {
      type = lib.types.submodule {
        freeformType = with lib.types; attrsOf str;

        options = {
          PGWS_DB_URI = lib.mkOption {
            type = lib.types.submodule {
              freeformType = with lib.types; attrsOf str;

              # This should not be used; use pgpassFile instead.
              options.password = lib.mkOption {
                default = null;
                readOnly = true;
                internal = true;
              };
              # This should not be used; use pgpassFile instead.
              options.passfile = lib.mkOption {
                default = null;
                readOnly = true;
                internal = true;
              };
            };
            default = { };
            description = ''
              libpq connection parameters as documented in:

              <https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-PARAMKEYWORDS>

              ::: {.note}
              The `environment.PGWS_DB_URI.password` and `environment.PGWS_DB_URI.passfile` options are blocked.
              Use [`pgpassFile`](#opt-services.postgres-websockets.pgpassFile) instead.
              :::
            '';
            example = lib.literalExpression ''
              {
                host = "localhost";
                dbname = "postgres";
              }
            '';
          };

          # This should not be used; use jwtSecretFile instead.
          PGWS_JWT_SECRET = lib.mkOption {
            default = null;
            readOnly = true;
            internal = true;
          };

          PGWS_HOST = lib.mkOption {
            type = with lib.types; nullOr str;
            default = "127.0.0.1";
            description = ''
              Address the server will listen for websocket connections.
            '';
          };
        };
      };
      default = { };
      description = ''
        postgres-websockets configuration as defined in:
        <https://github.com/diogob/postgres-websockets/blob/master/src/PostgresWebsockets/Config.hs#L71-L87>

        `PGWS_DB_URI` is represented as an attribute set, see [`environment.PGWS_DB_URI`](#opt-services.postgres-websockets.environment.PGWS_DB_URI)

        ::: {.note}
        The `environment.PGWS_JWT_SECRET` option is blocked.
        Use [`jwtSecretFile`](#opt-services.postgres-websockets.jwtSecretFile) instead.
        :::
      '';
      example = lib.literalExpression ''
        {
          PGWS_LISTEN_CHANNEL = "my_channel";
          PGWS_DB_URI.dbname = "postgres";
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.postgres-websockets.environment.PGWS_DB_URI.application_name =
      with pkgs.postgres-websockets;
      "${pname} ${version}";

    systemd.services.postgres-websockets = {
      description = "postgres-websockets";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [
        "network-online.target"
        "postgresql.target"
      ];

      environment =
        cfg.environment
        // {
          inherit PGWS_DB_URI;
          PGWS_JWT_SECRET = "@%d/jwt_secret";
        }
        // lib.optionalAttrs (cfg.pgpassFile != null) {
          PGPASSFILE = "%C/postgres-websockets/pgpass";
        };

      serviceConfig = {
        CacheDirectory = "postgres-websockets";
        CacheDirectoryMode = "0700";
        LoadCredential = [
          "jwt_secret:${cfg.jwtSecretFile}"
        ]
        ++ lib.optional (cfg.pgpassFile != null) "pgpass:${cfg.pgpassFile}";
        Restart = "always";
        User = "postgres-websockets";

        # Hardening
        CapabilityBoundingSet = [ "" ];
        DevicePolicy = "closed";
        DynamicUser = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateIPC = true;
        PrivateMounts = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "" ];
        UMask = "0077";
      };

      # Copy the pgpass file to different location, to have it report mode 0400.
      # Fixes: https://github.com/systemd/systemd/issues/29435
      script = ''
        if [ -f "$CREDENTIALS_DIRECTORY/pgpass" ]; then
            cp -f "$CREDENTIALS_DIRECTORY/pgpass" "$CACHE_DIRECTORY/pgpass"
        fi
        exec ${lib.getExe pkgs.postgres-websockets}
      '';
    };
  };
}
