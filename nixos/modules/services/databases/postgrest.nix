{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.postgrest;

  # Turns an attrset of libpq connection params:
  #   {
  #     dbname = "postgres";
  #     user = "authenticator";
  #   }
  # into a libpq connection string:
  #   dbname=postgres user=authenticator
  db-uri = lib.pipe (cfg.settings.db-uri or { }) [
    (lib.filterAttrs (_: v: v != null))
    (lib.mapAttrsToList (k: v: "${k}=${v}"))
    (lib.concatStringsSep " ")
  ];

  # Writes a postgrest config file according to:
  #   https://hackage.haskell.org/package/configurator-0.3.0.0/docs/Data-Configurator.html
  # Only a subset of the functionality is used by PostgREST.
  configFile = lib.pipe (cfg.settings // { inherit db-uri; }) [
    (lib.filterAttrs (_: v: v != null))

    (lib.mapAttrs (
      _: v:
      if true == v then
        "true"
      else if false == v then
        "false"
      else if lib.isInt v then
        toString v
      else
        "\"${lib.escape [ "\"" ] v}\""
    ))

    (lib.mapAttrsToList (k: v: "${k} = ${v}"))
    (lib.concatStringsSep "\n")
    (pkgs.writeText "postgrest.conf")
  ];
in

{
  meta = {
    maintainers = with lib.maintainers; [ wolfgangwalther ];
  };

  options.services.postgrest = {
    enable = lib.mkEnableOption "PostgREST";

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
      default = null;
      example = "/run/keys/jwt_secret";
      description = ''
        The secret or JSON Web Key (JWK) (or set) used to decode JWT tokens clients provide for authentication.
        For security the key must be at least 32 characters long.
        If this parameter is not specified then PostgREST refuses authentication requests.

        <https://docs.postgrest.org/en/stable/references/configuration.html#jwt-secret>
      '';
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType =
          with lib.types;
          attrsOf (oneOf [
            bool
            ints.unsigned
            str
          ]);

        options = {
          admin-server-port = lib.mkOption {
            type = with lib.types; nullOr port;
            default = null;
            description = ''
              Specifies the port for the admin server, which can be used for healthchecks.

              <https://docs.postgrest.org/en/stable/references/admin_server.html#admin-server>
            '';
          };

          db-config = lib.mkOption {
            type = lib.types.bool;
            default = false;
            example = true;
            description = ''
              Enables the in-database configuration.

              <https://docs.postgrest.org/en/stable/references/configuration.html#in-database-configuration>

              ::: {.note}
              This is enabled by default upstream, but disabled by default in this module.
              :::
            '';
          };

          db-uri = lib.mkOption {
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
              The `settings.db-uri.password` and `settings.db-uri.passfile` options are blocked.
              Use [`pgpassFile`](#opt-services.postgrest.pgpassFile) instead.
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
          jwt-secret = lib.mkOption {
            default = null;
            readOnly = true;
            internal = true;
          };

          server-host = lib.mkOption {
            type = with lib.types; nullOr str;
            default = "127.0.0.1";
            description = ''
              Where to bind the PostgREST web server.

              ::: {.note}
              The admin server will also bind here, but potentially exposes sensitive information.
              Make sure you turn off the admin server, when opening this to the public.

              <https://github.com/PostgREST/postgrest/issues/3956>
              :::
            '';
          };

          server-port = lib.mkOption {
            type = with lib.types; nullOr port;
            default = null;
            example = 3000;
            description = ''
              The TCP port to bind the web server.
            '';
          };

          server-unix-socket = lib.mkOption {
            type = with lib.types; nullOr path;
            default = "/run/postgrest/postgrest.sock";
            description = ''
              Unix domain socket where to bind the PostgREST web server.
            '';
          };
        };
      };
      default = { };
      description = ''
        PostgREST configuration as documented in:
        <https://docs.postgrest.org/en/stable/references/configuration.html#list-of-parameters>

        `db-uri` is represented as an attribute set, see [`settings.db-uri`](#opt-services.postgrest.settings.db-uri)

        ::: {.note}
        The `settings.jwt-secret` option is blocked.
        Use [`jwtSecretFile`](#opt-services.postgrest.jwtSecretFile) instead.
        :::
      '';
      example = lib.literalExpression ''
        {
          db-anon-role = "anon";
          db-uri.dbname = "postgres";
          "app.settings.custom" = "value";
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = (cfg.settings.server-port == null) != (cfg.settings.server-unix-socket == null);
        message = ''
          PostgREST can listen either on a TCP port or on a unix socket, but not both.
          Please set one of `settings.server-port`](#opt-services.postgrest.jwtSecretFile) or `settings.server-unix-socket` to `null`.

          <https://docs.postgrest.org/en/stable/references/configuration.html#server-unix-socket>
        '';
      }
    ];

    warnings =
      lib.optional (cfg.settings.admin-server-port != null && cfg.settings.server-host != "127.0.0.1")
        "The PostgREST admin server is potentially listening on a public host. This may expose sensitive information via the `/config` endpoint.";

    # Since we're using DynamicUser, we can't add the e.g. nginx user to
    # a postgrest group, so the unix socket must be world-readable to make it useful.
    services.postgrest.settings.server-unix-socket-mode = "666";

    systemd.services.postgrest = {
      description = "PostgREST";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [
        "network-online.target"
        "postgresql.target"
      ];

      serviceConfig = {
        CacheDirectory = "postgrest";
        CacheDirectoryMode = "0700";
        Environment =
          lib.optional (cfg.pgpassFile != null) "PGPASSFILE=%C/postgrest/pgpass"
          ++ lib.optional (cfg.jwtSecretFile != null) "PGRST_JWT_SECRET=@%d/jwt_secret";
        LoadCredential =
          lib.optional (cfg.pgpassFile != null) "pgpass:${cfg.pgpassFile}"
          ++ lib.optional (cfg.jwtSecretFile != null) "jwt_secret:${cfg.jwtSecretFile}";
        Restart = "always";
        RuntimeDirectory = "postgrest";
        User = "postgrest";

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
        exec ${lib.getExe pkgs.postgrest} ${configFile}
      '';
    };
  };
}
