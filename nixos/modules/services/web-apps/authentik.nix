{
  config,
  lib,
  pkgs,
  ...
}:

let
  service = "authentik";

  cfg = config.services.authentik;

  environment =
    { }
    # General settings
    // lib.optionalAttrs (cfg.secretKey != null) {
      AUTHENTIK_SECRET_KEY = cfg.secretKey;
    }
    # Postgresql settings:
    // (
      if cfg.postgresql.createLocally && cfg.postgresql.port == 0 then
        {
          AUTHENTIK_POSTGRESQL__HOST = "/run/postgresql";
          AUTHENTIK_POSTGRESQL__NAME = cfg.postgresql.name;
          AUTHENTIK_POSTGRESQL__USER = cfg.postgresql.username;
        }
      else
        { }
        // lib.optionalAttrs (cfg.postgresql.host != null) {
          AUTHENTIK_POSTGRESQL__HOST = cfg.postgresql.host;
        }
        // lib.optionalAttrs (cfg.postgresql.port != null) {
          AUTHENTIK_POSTGRESQL__PORT = toString cfg.postgresql.port;
        }
        // lib.optionalAttrs (cfg.postgresql.name != null) {
          AUTHENTIK_POSTGRESQL__NAME = cfg.postgresql.name;
        }
        // lib.optionalAttrs (cfg.postgresql.username != null) {
          AUTHENTIK_POSTGRESQL__USER = cfg.postgresql.username;
        }
        // lib.optionalAttrs (cfg.postgresql.password != null) {
          AUTHENTIK_POSTGRESQL__PASSWORD = cfg.postgresql.password;
        }
    )
    # Redis settings:
    // (
      if cfg.redis.createLocally && cfg.redis.port == 0 then
        {
          AUTHENTIK_CACHE__URL = "unix://${config.services.redis.servers."${cfg.redis.name}".unixSocket}";
          AUTHENTIK_CHANNEL__URL = "unix://${config.services.redis.servers."${cfg.redis.name}".unixSocket}";
          AUTHENTIK_BROKER__URL = "redis+socket://${
            config.services.redis.servers."${cfg.redis.name}".unixSocket
          }";
          AUTHENTIK_RESULT_BACKEND__URL = "redis+socket://${
            config.services.redis.servers."${cfg.redis.name}".unixSocket
          }";
        }
      else
        { }
        // lib.optionalAttrs (cfg.redis.host != null) {
          AUTHENTIK_REDIS__HOST = cfg.redis.host;
        }
        // lib.optionalAttrs (cfg.redis.port != null) {
          AUTHENTIK_REDIS__PORT = toString cfg.redis.port;
        }
        // lib.optionalAttrs (cfg.redis.name != null) {
          AUTHENTIK_REDIS__DB = cfg.redis.name;
        }
        // lib.optionalAttrs (cfg.redis.username != null) {
          AUTHENTIK_REDIS__USERNAME = cfg.redis.username;
        }
        // lib.optionalAttrs (cfg.redis.password != null) {
          AUTHENTIK_REDIS__PASSWORD = cfg.redis.password;
        }
    )
    # Listen settings
    // lib.optionalAttrs (cfg.listen.http.address != null && cfg.listen.http.port != null) {
      AUTHENTIK_LISTEN__HTTP = "${cfg.listen.http.address}:${toString cfg.listen.http.port}";
    }
    // lib.optionalAttrs (cfg.listen.https.address != null && cfg.listen.https.port != null) {
      AUTHENTIK_LISTEN__HTTPS = "${cfg.listen.https.address}:${toString cfg.listen.https.port}";
    }
    // lib.optionalAttrs (cfg.listen.trustedProxyCidrs != null) {
      AUTHENTIK_LISTEN__TRUSTED_PROXY_CIDRS = lib.concatStringsSep "," cfg.listen.trustedProxyCidrs;
    }
    # Email settings:
    // lib.optionalAttrs (cfg.email.host != null) {
      AUTHENTIK_EMAIL__HOST = cfg.email.host;
    }
    // lib.optionalAttrs (cfg.email.port != null) {
      AUTHENTIK_EMAIL__PORT = toString cfg.email.port;
    }
    // lib.optionalAttrs (cfg.email.username != null) {
      AUTHENTIK_EMAIL__USERNAME = cfg.email.username;
    }
    // lib.optionalAttrs (cfg.email.password != null) {
      AUTHENTIK_EMAIL__PASSWORD = cfg.email.password;
    }
    // lib.optionalAttrs (cfg.email.useTls != null) {
      AUTHENTIK_EMAIL__USE_TLS = lib.boolToString cfg.email.useTls;
    }
    // lib.optionalAttrs (cfg.email.useSsl != null) {
      AUTHENTIK_EMAIL__USE_SSL = lib.boolToString cfg.email.useSsl;
    }
    // lib.optionalAttrs (cfg.email.timeout != null) {
      AUTHENTIK_EMAIL__TIMEOUT = toString cfg.email.timeout;
    }
    // lib.optionalAttrs (cfg.email.from != null) {
      AUTHENTIK_EMAIL__FROM = cfg.email.from;
    }
    # Boostrap settings:
    // lib.optionalAttrs (cfg.bootstrap.password != null) {
      AUTHENTIK_BOOTSTRAP_PASSWORD = cfg.bootstrap.password;
    }
    // lib.optionalAttrs (cfg.bootstrap.token != null) {
      AUTHENTIK_BOOTSTRAP_TOKEN = cfg.bootstrap.token;
    }
    // lib.optionalAttrs (cfg.bootstrap.email != null) {
      AUTHENTIK_BOOTSTRAP_EMAIL = cfg.bootstrap.email;
    }
    # Extra environment variables:
    // cfg.extraEnv;

  defaultServiceConfig = {
    User = cfg.user;
    Group = cfg.group;
    Restart = "on-failure";

    # Hardening
    NoNewPrivileges = true;
    PrivateTmp = true;
    PrivateDevices = true;
    ProtectSystem = true;
    ProtectHome = true;
    ProtectControlGroups = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectProc = "invisible";
    RestrictAddressFamilies = [
      "AF_UNIX"
      "AF_INET"
      "AF_INET6"
      "AF_NETLINK"
    ];
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    MemoryDenyWriteExecute = true;
    LockPersonality = true;
  };

  defaultDescriptionForSecrets = ''
    Like for almost all other authentik settings, you can also use a
    URI-like format to read values from other sources. Especially for
    secrets it is recommended to read the values from a secrets file.

    env://<name> Loads the value from the environment variable <name>.
    Fallback can be optionally set like env://<name>?<default>

    file://<name> Loads the value from the file <name>.
    Fallback can be optionally set like file://<name>?<default>
  '';
in

{
  options = {
    services.authentik = {
      enable = lib.mkEnableOption "authentik";

      package = lib.mkPackageOption pkgs "authentik" { };

      user = lib.mkOption {
        type = lib.types.str;
        default = service;
        description = ''
          User account under which authentik runs.
        '';
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = service;
        description = ''
          User account under which authentik runs.
        '';
      };

      secretKey = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Secret key used for cookie signing. Changing this will invalidate active sessions.

          ${defaultDescriptionForSecrets}
        '';
      };

      postgresql = {
        createLocally = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Whether to create the Postgresql database locally.
          '';
        };

        name = lib.mkOption {
          type = lib.types.str;
          default = service;
          description = ''
            Name of the PostgreSQL database.
          '';
        };

        host = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1";
          description = ''
            Host of the PostgreSQL database server.
          '';
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 0;
          description = ''
            Port of the PostgreSQL database server.
          '';
        };

        username = lib.mkOption {
          type = lib.types.str;
          default = service;
          description = ''
            Username of the PostgreSQL database.
          '';
        };

        password = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            Password of the PostgreSQL database.

            ${defaultDescriptionForSecrets}
          '';
        };
      };

      redis = {
        createLocally = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Whether to create the Redis database locally.
          '';
        };

        name = lib.mkOption {
          type = lib.types.str;
          default = service;
          description = ''
            Name of the Redis database.
          '';
        };

        host = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1";
          description = ''
            Host of the Redis database server.
          '';
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 0;
          description = ''
            Port of the Redis database server. Can be set to 0 to use a Unix socket instead.
          '';
        };

        username = lib.mkOption {
          type = lib.types.str;
          default = service;
          description = ''
            Username of the Redis database.
          '';
        };

        password = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            Password of the Redis database.

            ${defaultDescriptionForSecrets}
          '';
        };
      };

      listen = {
        http = {
          address = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1";
            description = ''
              IP address on which authentik will listen for HTTP connections.

              Set to the empty string to listen on all interfaces.
            '';
          };

          port = lib.mkOption {
            type = lib.types.port;
            default = 9000;
            description = ''
              Port on which authentik will listen for HTTP connections.
            '';
          };

          openFirewall = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = ''
              Open port needed for HTTP connections.
            '';
          };
        };

        https = {
          address = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1";
            description = ''
              IP address on which authentik will listen for HTTPS connections.

              Set to the empty string to listen on all interfaces.
            '';
          };

          port = lib.mkOption {
            type = lib.types.port;
            default = 9443;
            description = ''
              Port on which authentik will listen for HTTPS connections.
            '';
          };

          openFirewall = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = ''
              Open port needed for HTTPS connections.
            '';
          };
        };

        trustedProxyCidrs = lib.mkOption {
          type = lib.types.nullOr (lib.types.listOf lib.types.str);
          default = null;
          description = ''
            List of CIDR's that proxy headers should be accepted from.

            If unset, all CIDR's of private IP's are considered as trusted by authentik.
          '';
        };
      };

      email = {
        host = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            Host of the email (SMTP) server.
          '';
        };

        port = lib.mkOption {
          type = lib.types.nullOr lib.types.port;
          default = null;
          description = ''
            Port of the email (SMTP) server.
          '';
        };

        username = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            Username of the email (SMTP) server.
          '';
        };

        password = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            Password of the email (SMTP) server.

            ${defaultDescriptionForSecrets}
          '';
        };

        useTls = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Whether to use TLS when communicating with the email (SMTP) server.
          '';
        };

        useSsl = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Whether to use SSL when communicating with the email (SMTP) server.
          '';
        };

        timeout = lib.mkOption {
          type = lib.types.int;
          default = 10;
          description = ''
            Timeout in seconds when communicating with the email (SMTP) server.
          '';
        };

        from = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            From email address to use when sending emails.
          '';
        };
      };

      bootstrap = {
        email = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            Email address for the default akadmin user.
          '';
        };

        password = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "changeme";
          description = ''
            Password for the default akadmin user.

            Only read on the first startup. Can be used for any flow executor.

            Careful: This option does not support reading values from other sources,
            such as other environment variables or files. So it is recommended to
            change this value directly after the first startup.
          '';
        };

        token = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            Token for the default akadmin user.

            Only read on the first startup. The string you specify for this variable
            is the token key you can use to authenticate yourself to the API.

            Careful: This option does not support reading values from other sources,
            such as other environment variables or files. So it is recommended to
            change this value directly after the first startup.
          '';
        };
      };

      extraEnv = lib.mkOption {
        type = with lib.types; attrsOf str;
        default = { };
        example = lib.literalExpression ''
          {
            AUTHENTIK_LOG_LEVEL = "info";
          }
        '';
        description = ''
          Extra environment variables for authentik.

          The available configuration options can be found in
          [the configuration documentation](https://docs.goauthentik.io/docs/install-config/configuration/).
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.secretKey != "" && cfg.secretKey != null;
        message = "service.authentik.secretKey must be set";
      }
      {
        assertion = cfg.listen.http.address != null && cfg.listen.http.port != null;
        message = "listen.http.address and listen.http.port must be set together";
      }
      {
        assertion = cfg.listen.https.address != null && cfg.listen.https.port != null;
        message = "listen.https.address and listen.https.port must be set together";
      }
    ];

    services.postgresql = lib.mkIf cfg.postgresql.createLocally {
      enable = true;
      ensureDatabases = [ cfg.postgresql.name ];
      ensureUsers = [
        {
          name = cfg.user;
          ensureDBOwnership = true;
        }
      ];
    };

    services.redis.servers."${cfg.redis.name}" = lib.mkIf cfg.redis.createLocally {
      enable = true;
      port = cfg.redis.port;
      user = cfg.user;
    };

    users.groups.authentik = {
      name = cfg.group;
    };

    users.users.authentik = {
      name = cfg.user;
      description = "Authentik user";
      group = cfg.group;
      isSystemUser = true;
    };

    systemd.services.authentik = {
      after =
        [ "network.target" ]
        ++ lib.optionals cfg.postgresql.createLocally [ "postgresql.service" ]
        ++ lib.optionals cfg.redis.createLocally [ "redis-${cfg.redis.name}.service" ];

      requires =
        lib.optionals cfg.postgresql.createLocally [ "postgresql.service" ]
        ++ lib.optionals cfg.redis.createLocally [ "redis-${cfg.redis.name}.service" ];

      inherit environment;

      serviceConfig = defaultServiceConfig // {
        ExecStart = "${cfg.package}/bin/ak server";
      };

      wantedBy = [ "multi-user.target" ];
    };

    systemd.services.authentik-worker = {
      after =
        [ "network.target" ]
        ++ lib.optionals cfg.postgresql.createLocally [ "postgresql.service" ]
        ++ lib.optionals cfg.redis.createLocally [ "redis-${cfg.redis.name}.service" ];

      requires =
        lib.optionals cfg.postgresql.createLocally [ "postgresql.service" ]
        ++ lib.optionals cfg.redis.createLocally [ "redis-${cfg.redis.name}.service" ];

      inherit environment;

      serviceConfig = defaultServiceConfig // {
        ExecStart = "${cfg.package}/bin/ak worker";
      };

      wantedBy = [ "multi-user.target" ];
    };

    networking.firewall = lib.mkMerge [
      (lib.mkIf cfg.listen.http.openFirewall {
        allowedTCPPorts = [ cfg.listen.http.port ];
      })
      (lib.mkIf cfg.listen.https.openFirewall {
        allowedTCPPorts = [ cfg.listen.https.port ];
      })
    ];
  };
}
