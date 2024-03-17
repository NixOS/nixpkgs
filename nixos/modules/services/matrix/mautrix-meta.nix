{ config, pkgs, lib, ... }:

let
  settingsFormat = pkgs.formats.json {};

  upperConfig = config;
  cfg = config.services.mautrix-meta;
  upperCfg = cfg;

  fullDataDir = cfg: "/var/lib/${cfg.dataDir}";

  settingsFile = cfg: "${fullDataDir cfg}/config.json";
  settingsFileUnsubstituted = cfg: settingsFormat.generate "mautrix-meta-config.json" cfg.settings;

  metaName = name: "mautrix-meta-${name}";

  enabledInstances = lib.filterAttrs (name: config: config.enable) config.services.mautrix-meta.instances;
in {
  options = {
    services.mautrix-meta = {

      package = lib.mkPackageOption pkgs "mautrix-meta" { };

      instances = lib.mkOption rec {
        type = lib.types.attrsOf (lib.types.submodule ({ config, name, ... }: let
        in {

          options = {

            enable = lib.mkEnableOption (lib.mdDoc "Mautrix-Meta, a Matrix <-> Facebook and Matrix <-> Instagram hybrid puppeting/relaybot bridge");

            dataDir = lib.mkOption {
              type = lib.types.str;
              default = metaName name;
              description = lib.mdDoc ''
                Path to the directory with database, registration, and other data for the bridge service.
                This path is relative to `/var/lib`, it cannot start with `../` (it cannot be outside of `/var/lib`).
              '';
            };

            registrationFile = lib.mkOption {
              type = lib.types.path;
              readOnly = true;
              description = lib.mdDoc ''
                Path to the yaml registration file of the appservice.
              '';
            };

            settings = lib.mkOption rec {
              apply = lib.recursiveUpdate default;
              inherit (settingsFormat) type;
              default = {
                homeserver = {
                  software = "standard";

                  domain = "";
                  address = "https://${config.settings.homeserver.domain}";
                };

                appservice = {
                  database = {
                    type = "sqlite3-fk-wal";
                    uri = "file:${fullDataDir config}/mautrix-meta.db?_txlock=immediate";
                  };

                  hostname = "localhost";
                  port = 29319;
                  address = "http://${config.settings.appservice.hostname}:${toString config.settings.appservice.port}";
                };

                meta = {
                  mode = "";
                };

                bridge = {
                  # Enable encryption by default to make the bridge more secure
                  encryption = {
                    allow = true;
                    default = true;
                    require = true;

                    # Recommended options from mautrix documentation
                    # for additional security.
                    delete_keys = {
                      dont_store_outbound = true;
                      ratchet_on_decrypt = true;
                      delete_fully_used_on_decrypt = true;
                      delete_prev_on_new_session = true;
                      delete_on_device_delete = true;
                      periodically_delete_expired = true;
                      delete_outdated_inbound = true;
                    };

                    verification_levels = {
                      receive = "cross-signed-tofu";
                      send = "cross-signed-tofu";
                      share = "cross-signed-tofu";
                    };
                  };

                  permissions = {
                    "*" = "relaybot";
                  };
                };

                logging = {
                  min_level = "info";
                  writers = lib.singleton {
                    type = "stdout";
                    format = "pretty-colored";
                    time_format = " ";
                  };
                };
              };
              defaultText = ''
              {
                homeserver = {
                  software = "standard";
                  address = "https://''${config.settings.homeserver.domain}";
                };

                appservice = {
                  database = {
                    type = "sqlite3-fk-wal";
                    uri = "file:''${fullDataDir config}/mautrix-meta.db?_txlock=immediate";
                  };

                  hostname = "localhost";
                  port = 29319;
                  address = "http://''${config.settings.appservice.hostname}:''${toString config.settings.appservice.port}";
                };

                bridge = {
                  # Require encryption by default to make the bridge more secure
                  encryption = {
                    allow = true;
                    default = true;
                    require = true;

                    # Recommended options from mautrix documentation
                    # for optimal security.
                    delete_keys = {
                      dont_store_outbound = true;
                      ratchet_on_decrypt = true;
                      delete_fully_used_on_decrypt = true;
                      delete_prev_on_new_session = true;
                      delete_on_device_delete = true;
                      periodically_delete_expired = true;
                      delete_outdated_inbound = true;
                    };

                    verification_levels = {
                      receive = "cross-signed-tofu";
                      send = "cross-signed-tofu";
                      share = "cross-signed-tofu";
                    };
                  };

                  permissions = {
                    "*" = "relaybot";
                  };
                };

                logging = {
                  min_level = "info";
                  writers = lib.singleton {
                    type = "stdout";
                    format = "pretty-colored";
                    time_format = " ";
                  };
                };
              };
              '';
              description = lib.mdDoc ''
                {file}`config.json` configuration as a Nix attribute set.
                Configuration options should match those described in
                [example-config.yaml](https://github.com/mautrix/meta/blob/main/example-config.yaml).

                Secret tokens should be specified using {option}`environmentFile`
                instead
              '';
            };

            environmentFile = lib.mkOption {
              type = lib.types.nullOr lib.types.path;
              default = null;
              description = lib.mdDoc ''
                File containing environment variables to substitute when copying the configuration
                out of Nix store to the `services.mautrix-meta.dataDir`.

                Can be used for storing the secrets without making them available in the Nix store.

                For example, you can set `services.mautrix-meta.settings.appservice.as_token = "$MAUTRIX_META_APPSERVICE_AS_TOKEN"`
                and then specify `MAUTRIX_META_APPSERVICE_AS_TOKEN="{token}"` in the environment file.
                This value will get substituted into the configuration file as as token.
              '';
            };

            serviceDependencies = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default =
              [ config.registrationServiceUnit ] ++
              (lib.lists.optional upperConfig.services.matrix-synapse.enable upperConfig.services.matrix-synapse.serviceUnit) ++
              (lib.lists.optional upperConfig.services.matrix-conduit.enable "matrix-conduit.service") ++
              (lib.lists.optional upperConfig.services.dendrite.enable "dendrite.service");

              defaultText = ''
                [ config.registrationServiceUnit ] ++
                (lib.lists.optional upperConfig.services.matrix-synapse.enable upperConfig.services.matrix-synapse.serviceUnit) ++
                (lib.lists.optional upperConfig.services.matrix-conduit.enable "matrix-conduit.service") ++
                (lib.lists.optional upperConfig.services.dendrite.enable "dendrite.service");
              '';
              description = lib.mdDoc ''
                List of Systemd services to require and wait for when starting the application service.
              '';
            };

            serviceUnit = lib.mkOption {
              type = lib.types.str;
              readOnly = true;
              description = lib.mdDoc ''
                The systemd unit (a service or a target) for other services to depend on if they
                need to be started after matrix-synapse.

                This option is useful as the actual parent unit for all matrix-synapse processes
                changes when configuring workers.
              '';
            };

            registrationServiceUnit = lib.mkOption {
              type = lib.types.str;
              readOnly = true;
              description = lib.mdDoc ''
                The registration service that generates the registration file.

                Systemd unit (a service or a target) for other services to depend on if they
                need to be started after mautrix-meta registration service.

                This option is useful as the actual parent unit for all matrix-synapse processes
                changes when configuring workers.
              '';
            };
          };

          config = {
            serviceUnit = (metaName name) + ".service";
            registrationServiceUnit = (metaName name) + "-registration.service";
            registrationFile = (fullDataDir config) + "/meta-registration.yaml";
          };
        }));

        description = lib.mdDoc "Configuration of multiple `mautrix-meta` instances.";

        default = {
          instagram = {
            enable = false;

            settings = {
              meta.mode = "instagram";

              appservice = {
                id = "instagram";
                bot = {
                  username = "instagrambot";
                  displayname = "Instagram bridge bot";
                  avatar = "mxc://maunium.net/JxjlbZUlCPULEeHZSwleUXQv";
                };
              };
            };
          };
          facebook = {
            enable = false;

            settings = {
              meta.mode = "facebook";

              appservice = {
                id = "facebook";
                bot = {
                  username = "facebookbot";
                  displayname = "Facebook bridge bot";
                  avatar = "mxc://maunium.net/ygtkteZsXnGJLJHRchUwYWak";
                };
              };
            };
          };
        };
      };
    };
  };

  config = (lib.mkIf (enabledInstances != []) {
    assertions = (lib.attrValues (lib.mapAttrs (name: cfg: {
      assertion = cfg.settings.homeserver.domain != "" && cfg.settings.homeserver.address != "";
      message = ''
        The options with information about the homeserver:
        services.mautrix-meta.instances.${name}.settings.homeserver.domain and
        services.mautrix-meta.instances.${name}.settings.homeserver.address have to be set.
      '';
    }) enabledInstances)) ++ (lib.attrValues (lib.mapAttrs (name: cfg: {
      assertion = builtins.elem cfg.settings.meta.mode [ "facebook" "facebook-tor" "messenger" "instagram" ];
      message = ''
        The option services.mautrix-meta.instances.${name}.settings.meta.mode has to be set
        to one of: facebook, facebook-tor, messenger, instagram.
        This configures the mode of the bridge.
      '';
    }) enabledInstances));

    systemd.services = lib.attrsets.concatMapAttrs (name: cfg: {
      matrix-synapse = lib.mkIf (config.services.matrix-synapse.enable) {
        wants = [ cfg.registrationServiceUnit ];
        after = [ cfg.registrationServiceUnit ];
        serviceConfig = {
          # Allow synapse to read the registration file
          ReadWritePaths = [ (fullDataDir cfg) ];
        };
      };

      "${metaName name}-registration" = {
        description = "Mautrix-Meta registration generation service - ${metaName name}";

        script = ''
          # substitute the settings file by environment variables
          # in this case read from EnvironmentFile
          test -f '${settingsFile cfg}' && rm -f '${settingsFile cfg}'
          old_umask=$(umask)
          umask 0177
          ${lib.getExe pkgs.envsubst} \
            -o '${settingsFile cfg}' \
            -i '${settingsFileUnsubstituted cfg}'

          umask $old_umask

          if [[ (! -f '${cfg.registrationFile}') || "$(${lib.getExe pkgs.yq} '.[0].appservice | has("as_token") and has("hs_token")' '${cfg.registrationFile}')" == "true" ]]; then
            ${lib.getExe upperCfg.package} \
              --generate-registration \
              --config='${settingsFile cfg}' \
              --registration='${cfg.registrationFile}'
          fi

          umask 0177
          ${lib.getExe pkgs.yq} -s '.[0].appservice.as_token = .[1].as_token
            | .[0].appservice.hs_token = .[1].hs_token
            | .[0]' '${settingsFile cfg}' '${cfg.registrationFile}' \
            > '${settingsFile cfg}.tmp'
          mv '${settingsFile cfg}.tmp' '${settingsFile cfg}'
          umask $old_umask
        '' + lib.optionalString config.services.matrix-synapse.enable ''
          chown :matrix-synapse '${cfg.registrationFile}'
        '';

        serviceConfig = {
          UMask = 0027;

          User = "mautrix-meta";
          Group = "mautrix-meta";
          PrivateUsers = true;

          StateDirectory = cfg.dataDir;
          ReadWritePaths = fullDataDir cfg;
        };

        restartTriggers = [ (settingsFileUnsubstituted cfg) ];
      };

      "${metaName name}" = {
        description = "Mautrix-Meta bridge - ${metaName name}";
        wantedBy = [ "multi-user.target" ];
        wants = [ "network-online.target" ] ++ cfg.serviceDependencies;
        after = [ "network-online.target" ] ++ cfg.serviceDependencies;

        environment.HOME = fullDataDir cfg;

        serviceConfig = {
          Type = "simple";

          User = "mautrix-meta";
          Group = "mautrix-meta";
          PrivateUsers = true;

          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateTmp = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectSystem = "strict";
          Restart = "on-failure";
          RestartSec = "30s";
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallErrorNumber = "EPERM";
          SystemCallFilter = ["@system-service"];
          UMask = 0027;

          WorkingDirectory = fullDataDir cfg;
          ReadWritePaths = fullDataDir cfg;
          StateDirectory = cfg.dataDir;
          EnvironmentFile = cfg.environmentFile;

          ExecStart = "${lib.getExe upperCfg.package} --config='${settingsFile cfg}'";
        };
        restartTriggers = [ (settingsFileUnsubstituted cfg) ];
      };
    }) enabledInstances;
  });

  meta.maintainers = with lib.maintainers; [ rutherther ];
}
