{
  lib,
  utils,
  config,
  ...
}:
let
  cfg = config.services.affine-server;

  redisServerName = "affine";
in
{
  # Schema available here : https://github.com/toeverything/affine/releases/latest/download/config.schema.json
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

      cfg = config.services.affine-server;
    in
    {
      enable = lib.mkEnableOption "AFFiNE self-hosted server";

      package = lib.mkOption {
        type = lib.types.package;
        description = "The affine-server package to run.";
      };

      nginx = {

        enable = lib.mkEnableOption "an nginx virtual host for affine-server";

        enableACME = lib.mkOption {
          type = lib.types.bool;
          default = cfg.nginx.enable;
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
          description = "Database user.";
        };

        password = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = "affine";
          description = "Database password.";
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

      dataDir = lib.mkOption {
        type = lib.types.externalPath;
        default = "/var/lib/affine";
        description = "Directory holding affine-server's persistent config and storage.";
      };

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.externalPath;
        default = null;
        description = "Path to the environment file (refer to https://docs.affine.pro/self-host-affine/references/environment-variables)";
      };

      settings = lib.mkOption {
        description = ''
          AFFiNE server settings.
              You can specify secret values in this configuration by setting somevalue._secret = "/path/to/file" instead of setting somevalue directly.
              Refer to https://github.com/toeverything/affine/releases/latest/download/config.schema.json
        '';

        type = lib.types.submodule {
          freeformType = jsonFormat.type;

          options = {
            metrics = {
              enabled = lib.mkEnableOption "Enable metric and tracing collection";
            };

            crypto = lib.mkOption {
              type = lib.types.submodule {
                freeformType = jsonFormat.type;
                options = {
                  privateKey = lib.mkOption {
                    type = lib.types.either secret (lib.types.nullOr lib.types.str);
                    description = "The private key for used by the crypto module to create signed tokens or encrypt data.\n@default \"\"\n@environment `AFFINE_PRIVATE_KEY`";
                    example = {
                      _secret = "/var/lib/affine/private.key";
                    };
                  };
                };
              };
            };

            auth = lib.mkOption {
              description = "Configuration for auth module";
              type = lib.types.submodule {
                freeformType = jsonFormat.type;
                options = {
                  allowSignup = lib.mkOption {
                    type = lib.types.bool;
                    description = "Allow users to sign up";
                    default = false;
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
                                type = lib.types.submodule {
                                  freeformType = jsonFormat.type;
                                  options = {
                                    path = lib.mkOption {
                                      type = lib.types.nullOr lib.types.str;
                                      description = "Path to the storage";
                                      default =
                                        if (cfg.settings.storages.avatar.storage.provider == "fs") then "${cfg.dataDir}/storage" else null;
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
                                default = "blobs";
                              };
                              config = lib.mkOption {
                                type = lib.types.submodule {
                                  freeformType = jsonFormat.type;
                                  options = {
                                    path = lib.mkOption {
                                      type = lib.types.nullOr lib.types.str;
                                      description = "Path to the storage";
                                      default =
                                        if (cfg.settings.storages.blob.storage.provider == "fs") then "${cfg.dataDir}/storage" else null;
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
                  name = lib.mkOption {
                    type = lib.types.str;
                    description = "Name of the server";
                    default = "Nix Affine Server";
                  };
                  externalUrl = lib.mkOption {
                    type = lib.types.str;
                    description = "External URL of the server";
                    default = "${if cfg.settings.server.https then "https" else "http"}://${
                      if cfg.nginx.enable then cfg.settings.server.host else "127.0.0.1"
                    }${if !cfg.nginx.enable then ":${toString cfg.settings.server.port}" else ""}";
                    example = "https://affine.example.com";
                  };
                  https = lib.mkOption {
                    type = lib.types.bool;
                    description = "Whether the server is served over HTTPS";
                    default = true;
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

            flags = lib.mkOption {
              description = "Configuration for flags module";
              type = lib.types.submodule {
                freeformType = jsonFormat.type;
                options = {
                  allowGuestDemoWorkspace = lib.mkOption {
                    type = lib.types.bool;
                    description = "Allow guest demo workspace";
                    default = false;
                  };
                };
              };
            };

            client = lib.mkOption {
              description = "Configuration for client module";
              type = lib.types.submodule {
                freeformType = jsonFormat.type;
                options = {
                  versionControl = lib.mkOption {
                    description = "Configuration for version control module";
                    type = lib.types.submodule {
                      freeformType = jsonFormat.type;
                      options = {
                        enabled = lib.mkEnableOption "Enable version control";
                      };
                    };
                  };
                };
              };
            };

            payment = lib.mkOption {
              description = "Configuration for payment module";
              type = lib.types.submodule {
                freeformType = jsonFormat.type;
                options = {
                  showLifetimePrice = lib.mkOption {
                    type = lib.types.bool;
                    description = "Show lifetime price";
                    default = false;
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
        assertion = cfg.database.createLocally -> cfg.user == cfg.database.name;
        message = "services.affine-server.user must equal services.affine-server.database.name when database.createLocally is enabled (PostgreSQL peer authentication over the Unix socket).";
      }
    ];

    users = {
      users.${cfg.user} = {
        isSystemUser = true;
        inherit (cfg) group;
        home = cfg.dataDir;
      };

      groups.${cfg.group} = { };
    };

    services = {
      postgresql = lib.mkIf cfg.database.createLocally {
        enable = true;
        ensureDatabases = [ cfg.database.name ];
        ensureUsers = [
          {
            name = cfg.database.name;
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
      tmpfiles.rules = [
        "d ${cfg.dataDir} 0750 ${cfg.user} ${cfg.group} - -"
        "d ${cfg.dataDir}/.affine 0750 ${cfg.user} ${cfg.group} - -"
        "d ${cfg.dataDir}/.affine/config 0750 ${cfg.user} ${cfg.group} - -"
        "d ${cfg.dataDir}/storage 0750 ${cfg.user} ${cfg.group} - -"
      ]
      ++ lib.optional (
        cfg.settings.storages.blob.storage.provider == "fs"
        || cfg.settings.storages.avatar.storage.provider == "fs"
      ) "d ${cfg.dataDir}/storage 0750 ${cfg.user} ${cfg.group} - -";

      services.affine-server =
        let
          systemdCfg = config.systemd.services;
        in
        {
          description = "AFFiNE self-hosted server";
          wantedBy = [ "multi-user.target" ];
          after = [
            "network.target"
          ]
          ++ lib.optional cfg.database.createLocally systemdCfg.postgresql.name
          ++ lib.optional cfg.redis.createLocally systemdCfg."redis-${redisServerName}".name;

          wants =
            lib.optional cfg.database.createLocally systemdCfg.postgresql.name
            ++ lib.optional cfg.redis.createLocally systemdCfg."redis-${redisServerName}".name;

          environment = {
            REDIS_SERVER_HOST = cfg.redis.host;
            REDIS_SERVER_PORT = toString cfg.redis.port;

            DATABASE_URL =
              if cfg.database.createLocally then
                "postgresql://${cfg.database.name}@localhost:${toString config.services.postgresql.settings.port}/${cfg.database.name}?host=/run/postgresql&connection_limit=5&pool_timeout=10"
              else
                "postgresql://${cfg.database.user}${
                  lib.optionalString (cfg.database.password != null) ":${cfg.database.password}"
                }@${cfg.database.host}:${toString cfg.database.port}/${cfg.database.name}";
          };

          preStart = ''
            # https://github.com/toeverything/AFFiNE/blob/d897bb3d84099e54a6b3c0bd5f4265f8aa87d190/packages/backend/server/src/base/config/register.ts#L284
            ${utils.genJqSecretsReplacementSnippet cfg.settings "${cfg.dataDir}/.affine/config/config.json"}

            ${cfg.package}/bin/affine-server-predeploy
          '';

          serviceConfig = {
            EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
            User = cfg.user;
            Group = cfg.group;
            WorkingDirectory = cfg.dataDir;
            ExecStart = "${cfg.package}/bin/affine-server";
            Restart = "on-failure";
            RestartSec = "5s";
            StateDirectory = cfg.dataDir;

            RuntimeDirectoryMode = "0700";
          };
        };
    };
  };
}
