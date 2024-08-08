{ config, lib, options, pkgs, ... }:

with lib;

let
  cfg = config.services.vault;
  opt = options.services.vault;

  format = pkgs.formats.json {};
  configFile = format.generate "vault.hcl.json" (filterAttrsRecursive (_: v: v != null) cfg.settings);

  allConfigPaths = [configFile] ++ cfg.extraSettingsPaths;
  configOptions = escapeShellArgs
    (lib.optional cfg.dev "-dev" ++
     lib.optional (cfg.dev && cfg.devRootTokenID != null) "-dev-root-token-id=${cfg.devRootTokenID}"
      ++ (concatMap (p: ["-config" p]) allConfigPaths));

  storagePath = if cfg.storageBackend == "file" || cfg.storageBackend == "raft" then cfg.settings.storage.${cfg.storageBackend}.path else null;
in

{
  imports = [
    (mkRenamedOptionModule [ "services" "vault" "address" ] [ "services" "vault" "settings" "listener" "tcp" "address" ])
    (mkRenamedOptionModule [ "services" "vault" "tlsCertFile" ] [ "services" "vault" "settings" "listener" "tcp" "tls_cert_file" ])
    (mkRenamedOptionModule [ "services" "vault" "tlsKeyFile" ] [ "services" "vault" "settings" "listener" "tcp" "tls_key_file" ])
    (mkRenamedOptionModule [ "services" "vault" "storagePath" ] [ "services" "vault" "settings" "storage" cfg.storageBackend "path" ])

    (mkRemovedOptionModule [ "services" "vault" "listenerExtraConfig" ] "Use services.vault.settings.listener.tcp instead")
    (mkRemovedOptionModule [ "services" "vault" "storageConfig" ] "Use services.vault.settings.storage.${cfg.storageBackend} instead")
    (mkRemovedOptionModule [ "services" "vault" "telemetryConfig" ] "Use services.vault.settings.telemetry instead")
    (mkRemovedOptionModule [ "services" "vault" "extraConfig" ] "Use services.vault.settings instead")
  ];

  options = {
    services.vault = {
      enable = mkEnableOption "Vault daemon";

      package = mkPackageOption pkgs "vault" { };

      dev = mkOption {
        type = types.bool;
        default = false;
        description = ''
          In this mode, Vault runs in-memory and starts unsealed. This option is not meant production but for development and testing i.e. for nixos tests.
        '';
      };

      devRootTokenID = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Initial root token. This only applies when {option}`services.vault.dev` is true
        '';
      };

      storageBackend = mkOption {
        type = types.enum [ "inmem" "file" "consul" "zookeeper" "s3" "azure" "dynamodb" "etcd" "mssql" "mysql" "postgresql" "swift" "gcs" "raft" ];
        default = "inmem";
        description = "The name of the type of storage backend";
      };

      settings = mkOption {
        type = types.submodule {
          freeformType = format.type;

          options = {
            listener = mkOption {
              type = types.nullOr (types.submodule {
                freeformType = format.type;

                options = {
                  tcp = mkOption {
                    type = types.nullOr (types.submodule ({ config, ... }: {
                      freeformType = format.type;

                      options = {
                        address = mkOption {
                          type = types.str;
                          default = "127.0.0.1:8200";
                          description = ''
                            Specifies the address to bind to for listening. This can be dynamically defined
                            with a [go-sockaddr](https://pkg.go.dev/github.com/hashicorp/go-sockaddr/template)
                            template that is resolved at runtime.
                          '';
                        };

                        tls_cert_file = mkOption {
                          type = types.nullOr types.str;
                          default = null;
                          example = "/path/to/your/cert.pem";
                          description = "TLS certificate file. TLS will be disabled unless this option is set";
                        };

                        tls_key_file = mkOption {
                          type = types.nullOr types.str;
                          default = null;
                          example = "/path/to/your/key.pem";
                          description = "TLS private key file. TLS will be disabled unless this option is set";
                        };

                        tls_disable = mkOption {
                          type = types.bool;
                          default = config.tls_cert_file == null || config.tls_key_file == null;
                          description = ''
                            Specifies if TLS will be disabled.
                          '';
                        };
                      };
                    }));
                    default = { };
                    description = ''
                      The TCP listener configures Vault to listen on a TCP address/port.

                      See <https://developer.hashicorp.com/vault/docs/configuration/listener/tcp#tcp-listener-parameters>
                      for details.
                    '';
                  };
                };
              });
              default = { };
              description = ''
                The `listener` stanza configures the addresses and ports on which Vault will respond to requests.

                See <https://developer.hashicorp.com/vault/docs/configuration/listener> for details.
              '';
            };

            storage = mkOption {
              type = types.nullOr (types.submodule {
                freeformType = format.type;

                options = {
                  file = mkOption {
                    type = types.nullOr (types.submodule {
                      freeformType = format.type;

                      options = {
                        path = mkOption {
                          type = types.path;
                          default = "/var/lib/vault";
                          description = "The absolute path on disk to the directory where the data will be stored.";
                        };
                      };
                    });
                    default = null;
                    description = ''
                      The Filesystem storage backend stores Vault's data on the filesystem using a standard directory
                      structure. It can be used for durable single server situations, or to develop locally where
                      durability is not critical.

                      See <https://developer.hashicorp.com/vault/docs/configuration/storage/filesystem#file-parameters>
                      for details.
                    '';
                  };

                  raft = mkOption {
                    type = types.nullOr (types.submodule {
                      freeformType = format.type;

                      options = {
                        path = mkOption {
                          type = types.path;
                          default = "/var/lib/vault";
                          description = "The file system path where all the Vault data gets stored.";
                        };
                      };
                    });
                    default = null;
                    description = ''
                      The Integrated Storage backend is used to persist Vault's data. Unlike other storage
                      backends, Integrated Storage does not operate from a single source of data. Instead all the nodes
                      in a Vault cluster will have a replicated copy of Vault's data. Data gets replicated across all
                      the nodes via the [Raft Consensus Algorithm](https://raft.github.io/).

                      See <https://developer.hashicorp.com/vault/docs/configuration/storage/raft#raft-parameters>
                      for details.
                    '';
                  };
                };
              });
              default = { };
              description = ''
                The `storage` stanza configures the storage backend, which represents the location for the durable
                storage of Vault's information. Each backend has pros, cons, advantages, and trade-offs. For example,
                some backends support high availability while others provide a more robust backup and restoration
                process.

                See <https://developer.hashicorp.com/vault/docs/configuration/storage> for details.
              '';
            };
          };
        };
        default = { };
        description = ''
          Configuration of Vault. See https://developer.hashicorp.com/vault/docs/configuration for a description of options.
        '';
      };

      extraSettingsPaths = mkOption {
        type = types.listOf types.path;
        default = [];
        description = ''
          Configuration files to load besides the immutable one defined by the NixOS module.
          This can be used to avoid putting credentials in the Nix store, which can be read by any user.

          Each path can point to a JSON- or HCL-formatted file, or a directory
          to be scanned for files with `.hcl` or
          `.json` extensions.

          To upload the confidential file with NixOps, use for example:

          ```
          # https://releases.nixos.org/nixops/latest/manual/manual.html#opt-deployment.keys
          deployment.keys."vault.hcl" = let db = import ./db-credentials.nix; in {
            text = ${"''"}
              storage "postgresql" {
                connection_url = "postgres://''${db.username}:''${db.password}@host.example.com/exampledb?sslmode=verify-ca"
              }
            ${"''"};
            user = "vault";
          };
          services.vault.extraSettingsPaths = ["/run/keys/vault.hcl"];
          services.vault.storageBackend = "postgresql";
          users.users.vault.extraGroups = ["keys"];
          ```
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.vault.settings = mkMerge [
      {
        storage.${cfg.storageBackend} = { };
      }

      # vault in dev mode will refuse to start if its configuration sets listener
      (mkIf cfg.dev {
        listener = mkForce null;
      })
    ];

    users.users.vault = {
      name = "vault";
      group = "vault";
      uid = config.ids.uids.vault;
      description = "Vault daemon user";
    };
    users.groups.vault.gid = config.ids.gids.vault;

    systemd.tmpfiles.rules = optional (storagePath != null)
      "d '${storagePath}' 0700 vault vault - -";

    systemd.services.vault = {
      description = "Vault server daemon";

      wantedBy = ["multi-user.target"];
      after = [ "network.target" ]
           ++ optional (config.services.consul.enable && cfg.storageBackend == "consul") "consul.service";

      restartIfChanged = false; # do not restart on "nixos-rebuild switch". It would seal the storage and disrupt the clients.

      startLimitIntervalSec = 60;
      startLimitBurst = 3;
      serviceConfig = {
        User = "vault";
        Group = "vault";
        ExecStart = "${cfg.package}/bin/vault server ${configOptions}";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGHUP $MAINPID";
        StateDirectory = "vault";
        # In `dev` mode vault will put its token here
        Environment = lib.optional (cfg.dev) "HOME=/var/lib/vault";
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectSystem = "full";
        ProtectHome = "read-only";
        AmbientCapabilities = "cap_ipc_lock";
        NoNewPrivileges = true;
        LimitCORE = 0;
        KillSignal = "SIGINT";
        TimeoutStopSec = "30s";
        Restart = "on-failure";
      };

      unitConfig.RequiresMountsFor = optional (storagePath != null) storagePath;
    };
  };

}
