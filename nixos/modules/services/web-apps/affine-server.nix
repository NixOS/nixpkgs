{
  lib,
  pkgs,
  utils,
  config,
  ...
}:
let
  cfg = config.services.affine-server;

  redisServerName = "affine";

  stateDir = "/var/lib/affine";
in
{
  options.services.affine-server =
    let
      secret = lib.types.submodule {
        options = {
          _secret = lib.mkOption {
            type = lib.types.externalPath;
            description = "Path to the secret file";
          };
        };
      };

      jsonFormat = pkgs.formats.json { };

    in
    {
      enable = lib.mkEnableOption "AFFiNE self-hosted server";

      package = lib.mkOption {
        type = lib.types.package;
        description = "The affine-server package to run.";
        default = pkgs.affine-server;
        defaultText = lib.literalExpression "pkgs.affine-server";
      };

      nginx = {

        enable = lib.mkEnableOption "an nginx virtual host for affine-server";

        enableACME = lib.mkOption {
          type = lib.types.bool;
          default = cfg.nginx.enable;
          defaultText = lib.literalExpression "config.services.affine-server.nginx.enable";
          description = "Whether to request an ACME certificate for the virtual host.";
        };
      };

      redis = {
        createLocally = lib.mkEnableOption "a local Redis instance via NixOS' redis module";
        host = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1";
          description = "Redis host affine-server connects to.";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 6379;
          description = "Redis port.";
        };
      };

      database = {
        createLocally = lib.mkEnableOption "a local PostgreSQL instance via NixOS' postgresql module";

        name = lib.mkOption {
          type = lib.types.str;
          default = "affine";
          description = "Database name.";
        };

        user = lib.mkOption {
          type = lib.types.str;
          default = cfg.database.name;
          defaultText = lib.literalExpression "config.services.affine-server.database.name";
          description = "Database user.";
        };

        passwordFile = lib.mkOption {
          type = lib.types.nullOr lib.types.externalPath;
          default = null;
          example = "/run/keys/affine-dbpassword";
          description = ''
            A file containing the database password.
            This file is loaded using systemd LoadCredentials.
          '';
        };

        host = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1";
          description = "Database host.";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 5432;
          description = "Database port.";
        };
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "affine";
        description = "User account under which affine-server runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "affine";
        description = "Group under which affine-server runs.";
      };

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.externalPath;
        default = null;
        description = "Path to the environment file (refer to https://docs.affine.pro/self-host-affine/references/environment-variables)";
      };

      settings = lib.mkOption {
        description = ''
          AFFiNE server settings, written to {file}`config.json`.
          See <https://github.com/toeverything/affine/releases/latest/download/config.schema.json> for the available options.
          Specify secret values via `{ _secret = "/path/to/file"; }` instead of setting it directly.
        '';

        type = lib.types.submodule {
          freeformType = jsonFormat.type;

          options = {
            metrics = {
              enabled = lib.mkEnableOption "metrics and tracing collection";
            };

            crypto = lib.mkOption {
              description = "Cryptography settings";
              type = lib.types.submodule {
                freeformType = jsonFormat.type;
                options = {
                  privateKey = lib.mkOption {
                    type = lib.types.nullOr secret;
                    default = null;
                    description = ''
                      Private key used to sign tokens and encrypt data.
                      If `null`, a key is generated on first start and stored in
                      {file}`/var/lib/affine/.affine/config/private.key`.
                    '';
                    example = {
                      _secret = "/var/lib/affine/private.key";
                    };
                  };
                };
              };
            };

            storages = lib.mkOption {
              description = "Configuration for storages module";
              type = lib.types.submodule {
                freeformType = jsonFormat.type;
                options = {
                  avatar = lib.mkOption {
                    description = "Configuration for user avatars storage";
                    type = lib.types.submodule {
                      freeformType = jsonFormat.type;
                      options = {
                        storage = lib.mkOption {
                          description = "Avatar storage settings";
                          type = lib.types.submodule {
                            freeformType = jsonFormat.type;
                            options = {
                              provider = lib.mkOption {
                                type = lib.types.str;
                                description = "Storage provider";
                                default = "fs";
                              };

                              bucket = lib.mkOption {
                                type = lib.types.str;
                                description = "Storage bucket";
                                default = "avatars";
                              };

                              config = lib.mkOption {
                                description = "Avatar storage configuration";
                                type = lib.types.submodule {
                                  freeformType = jsonFormat.type;
                                  options = {
                                    path = lib.mkOption {
                                      type = lib.types.nullOr lib.types.str;
                                      description = "Path to the storage";
                                      default =
                                        if (cfg.settings.storages.avatar.storage.provider == "fs") then "${stateDir}/storage" else null;
                                      defaultText = lib.literalExpression ''
                                        if config.services.affine-server.settings.storages.avatar.storage.provider == "fs" then
                                          "/var/lib/affine/storage"
                                        else
                                          null
                                      '';
                                    };
                                  };
                                };
                              };
                            };
                          };
                        };
                      };
                    };
                  };

                  blob = lib.mkOption {
                    description = "Configuration for blob storage";
                    type = lib.types.submodule {
                      freeformType = jsonFormat.type;
                      options = {
                        storage = lib.mkOption {
                          description = "Blob storage settings";
                          type = lib.types.submodule {
                            freeformType = jsonFormat.type;
                            options = {
                              provider = lib.mkOption {
                                type = lib.types.str;
                                description = "Blobs storage provider";
                                default = "fs";
                              };
                              bucket = lib.mkOption {
                                type = lib.types.str;
                                description = "Blobs storage bucket";
                                default = "blobs";
                              };
                              config = lib.mkOption {
                                description = "Blobs storage configuration";
                                type = lib.types.submodule {
                                  freeformType = jsonFormat.type;
                                  options = {
                                    path = lib.mkOption {
                                      type = lib.types.nullOr lib.types.str;
                                      description = "Path to the storage";
                                      default =
                                        if (cfg.settings.storages.blob.storage.provider == "fs") then "${stateDir}/storage" else null;
                                      defaultText = lib.literalExpression ''
                                        if config.services.affine-server.settings.storages.blob.storage.provider == "fs" then
                                          "/var/lib/affine/storage"
                                        else
                                          null
                                      '';
                                    };
                                  };
                                };
                              };
                            };
                          };
                        };
                      };
                    };
                  };
                };
              };
            };
            server = lib.mkOption {
              description = "Configuration for server module";
              type = lib.types.submodule {
                freeformType = jsonFormat.type;
                options = {
                  https = lib.mkOption {
                    type = lib.types.bool;
                    description = "Whether the server is served over HTTPS";
                    default = cfg.nginx.enable && cfg.nginx.enableACME;
                    defaultText = lib.literalExpression "config.services.affine-server.nginx.enable && config.services.affine-server.nginx.enableACME";
                  };
                  host = lib.mkOption {
                    type = lib.types.str;
                    description = "Host of the server";
                    example = "affine.example.com";
                  };
                  port = lib.mkOption {
                    type = lib.types.port;
                    description = "Port of the server";
                    default = 3210;
                  };
                  listenAddr = lib.mkOption {
                    type = lib.types.str;
                    description = "Listen address of the server";
                    default = "127.0.0.1";
                  };
                };
              };
            };
          };
        };
      };
    };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.settings.server.host != "";
        message = "AFFiNE server host must be set to a FQDN.";
      }
      {
        assertion =
          cfg.database.createLocally
          -> (cfg.user == cfg.database.user && cfg.database.user == cfg.database.name);
        message = "When database.createLocally is enabled, services.affine-server.user, database.user and database.name must be equal (PostgreSQL peer authentication).";
      }
      {
        assertion = cfg.database.createLocally -> cfg.database.passwordFile == null;
        message = "When database.createLocally is enabled, services.affine-server.database.passwordFile must be null.";
      }
    ];

    users = {
      users.${cfg.user} = {
        isSystemUser = true;
        inherit (cfg) group;
        home = stateDir;
      };

      groups.${cfg.group} = { };
    };

    services = {
      postgresql = lib.mkIf cfg.database.createLocally {
        enable = true;
        ensureDatabases = [ cfg.database.name ];
        ensureUsers = [
          {
            name = cfg.database.user;
            ensureDBOwnership = true;
          }
        ];
      };

      nginx = lib.mkIf cfg.nginx.enable {
        enable = true;
        virtualHosts.${cfg.settings.server.host} = {
          enableACME = cfg.nginx.enableACME;
          forceSSL = cfg.nginx.enableACME;

          locations."/" = {
            proxyPass = "http://${cfg.settings.server.listenAddr}:${toString cfg.settings.server.port}";
            proxyWebsockets = true;
          };
        };
      };

      redis.servers.${redisServerName} = lib.mkIf cfg.redis.createLocally {
        enable = true;
        port = cfg.redis.port;
        bind = cfg.redis.host;
      };
    };

    systemd = {
      services.affine-server =
        let
          systemdCfg = config.systemd.services;

          dbHost = if cfg.database.createLocally then "localhost" else cfg.database.host;
          dbPass = lib.optionalString (cfg.database.passwordFile != null) ''
            :$(${lib.getExe pkgs.jq} -sRr 'rtrimstr("\n") | @uri' "$CREDENTIALS_DIRECTORY/dbpasswordfile")
          '';
          dbPort =
            if cfg.database.createLocally then
              (toString config.services.postgresql.settings.port)
            else
              (toString cfg.database.port);

          databaseEnvironment = ''
            export DATABASE_URL="postgresql://${cfg.database.user}${
              lib.optionalString (dbPass != null) ":${dbPass}"
            }@${dbHost}:${dbPort}/${cfg.database.name}?${lib.optionalString cfg.database.createLocally "host=/run/postgresql&"}connection_limit=5&pool_timeout=10"
          '';
        in
        {
          description = "AFFiNE self-hosted server";
          wantedBy = [ "multi-user.target" ];
          after = [
            "network.target"
          ]
          ++ lib.optional cfg.database.createLocally "postgresql.service"
          ++ lib.optional cfg.redis.createLocally systemdCfg."redis-${redisServerName}".name;

          requires =
            lib.optional cfg.database.createLocally "postgresql.service"
            ++ lib.optional cfg.redis.createLocally systemdCfg."redis-${redisServerName}".name;

          environment = {
            REDIS_SERVER_HOST = cfg.redis.host;
            REDIS_SERVER_PORT = toString cfg.redis.port;
          };

          preStart = ''
            # https://github.com/toeverything/AFFiNE/blob/d897bb3d84099e54a6b3c0bd5f4265f8aa87d190/packages/backend/server/src/base/config/register.ts#L284
            ${utils.genJqSecretsReplacementSnippet cfg.settings "${stateDir}/.affine/config/config.json"}
            ${databaseEnvironment}

            ${cfg.package}/bin/affine-server-predeploy
          '';

          script = ''
            ${databaseEnvironment}
            exec ${lib.getExe cfg.package};
          '';

          serviceConfig = {
            LoadCredential = lib.optional (
              cfg.database.passwordFile != null
            ) "dbpasswordfile:${cfg.database.passwordFile}";

            EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
            User = cfg.user;
            Group = cfg.group;
            WorkingDirectory = stateDir;
            Restart = "on-failure";
            RestartSec = "5s";
            StateDirectory = [
              "affine"
              "affine/.affine"
              "affine/.affine/config"
              "affine/storage"
            ];

            ProtectSystem = "strict";
            ProtectHome = true;
            PrivateTmp = true;
            NoNewPrivileges = true;
          };
        };
    };
  };

  meta = {
    inherit (pkgs.affine-server.meta) maintainers;
  };
}
