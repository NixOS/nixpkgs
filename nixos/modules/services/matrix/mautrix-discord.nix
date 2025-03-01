{
  config,
  pkgs,
  lib,
  ...
}:
# This module is an adaptation of the module for mautrix-meta in the same directory
let
  settingsFormat = pkgs.formats.yaml { };

  cfg = config.services.mautrix-discord;

  fullDataDir = cfg: "/var/lib/${cfg.dataDir}";

  settingsFile = cfg: "${fullDataDir cfg}/config.yaml";
  settingsFileUnsubstituted = cfg: settingsFormat.generate "mautrix-discord-config.yaml" cfg.settings;
in
{
  options = {
    services.mautrix-discord = {

      package = lib.mkPackageOption pkgs "mautrix-discord" { };

      enable = lib.mkEnableOption "Mautrix-Discord, a Matrix <-> Discord hybrid puppeting/relaybot bridge";

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "mautrix-discord";
        description = ''
          Path to the directory with database, registration, and other data for the bridge service.
          This path is relative to `/var/lib`, it cannot start with `../` (it cannot be outside of `/var/lib`).
        '';
      };

      registrationFile = lib.mkOption {
        type = lib.types.path;
        readOnly = true;
        description = ''
          Path to the yaml registration file of the appservice.
        '';
      };

      registerToSynapse = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to add registration file to `services.matrix-synapse.settings.app_service_config_files` and
          make Synapse wait for registration service.
        '';
      };

      settings = lib.mkOption rec {
        apply = lib.recursiveUpdate default;
        inherit (settingsFormat) type;
        default = {
          homeserver = {
            software = "standard";

            domain = "";
            address = "";
          };

          appservice = {
            id = "";

            database = {
              type = "sqlite3-fk-wal";
              uri = "file:${fullDataDir cfg}/mautrix-discord.db?_txlock=immediate";
            };

            bot = {
              username = "";
            };

            hostname = "localhost";
            port = 29334;
            address = "http://${cfg.settings.appservice.hostname}:${toString cfg.settings.appservice.port}";
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

            permissions = { };
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
              address = "https://''${cfg.settings.homeserver.domain}";
            };

            appservice = {
              database = {
                type = "sqlite3-fk-wal";
                uri = "file:''${fullDataDir cfg}/mautrix-discord.db?_txlock=immediate";
              };

              hostname = "localhost";
              port = 29334;
              address = "http://''${cfg.settings.appservice.hostname}:''${toString cfg.settings.appservice.port}";
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
        description = ''
          {file}`config.yaml` configuration as a Nix attribute set.
          Configuration options should match those described in
          [example-config.yaml](https://github.com/mautrix/discord/blob/main/example-config.yaml).

          Secret tokens should be specified using {option}`environmentFile`
          instead
        '';
      };

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          File containing environment variables to substitute when copying the configuration
          out of Nix store to the `services.mautrix-discord.dataDir`.

          Can be used for storing the secrets without making them available in the Nix store.

          For example, you can set `services.mautrix-discord.settings.appservice.as_token = "$MAUTRIX_DISCORD_APPSERVICE_AS_TOKEN"`
          and then specify `MAUTRIX_DISCORD_APPSERVICE_AS_TOKEN="{token}"` in the environment file.
          This value will get substituted into the configuration file as as token.
        '';
      };

      serviceDependencies = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default =
          [ cfg.registrationServiceUnit ]
          ++ (lib.lists.optional config.services.matrix-synapse.enable config.services.matrix-synapse.serviceUnit)
          ++ (lib.lists.optional config.services.matrix-conduit.enable "matrix-conduit.service")
          ++ (lib.lists.optional config.services.dendrite.enable "dendrite.service");

        defaultText = ''
          [ cfg.registrationServiceUnit ] ++
          (lib.lists.optional config.services.matrix-synapse.enable config.services.matrix-synapse.serviceUnit) ++
          (lib.lists.optional config.services.matrix-conduit.enable "matrix-conduit.service") ++
          (lib.lists.optional config.services.dendrite.enable "dendrite.service");
        '';
        description = ''
          List of Systemd services to require and wait for when starting the application service.
        '';
      };

      serviceUnit = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        description = ''
          The systemd unit (a service or a target) for other services to depend on if they
          need to be started after matrix-synapse.

          This option is useful as the actual parent unit for all matrix-synapse processes
          changes when configuring workers.
        '';
      };

      registrationServiceUnit = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        description = ''
          The registration service that generates the registration file.

          Systemd unit (a service or a target) for other services to depend on if they
          need to be started after mautrix-discord registration service.

          This option is useful as the actual parent unit for all matrix-synapse processes
          changes when configuring workers.
        '';
      };
    };
  };

  config = (
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.settings.homeserver.domain != "" && cfg.settings.homeserver.address != "";
          message = ''
            The options with information about the homeserver:
            `services.mautrix-discord.settings.homeserver.domain` and
            `services.mautrix-discord.settings.homeserver.address` have to be set.
          '';
        }
        {
          assertion = cfg.settings.bridge.permissions != { };
          message = ''
            The option `services.mautrix-discord.settings.bridge.permissions` has to be set.
          '';
        }
        {
          assertion = cfg.settings.appservice.id != "";
          message = ''
            The option `services.mautrix-discord.settings.appservice.id` has to be set.
          '';
        }
        {
          assertion = cfg.settings.appservice.bot.username != "";
          message = ''
            The option `services.mautrix-discord.settings.appservice.bot.username` has to be set.
          '';
        }
      ];

      users.users.mautrix-discord = {
        isSystemUser = true;
        group = "mautrix-discord";
        extraGroups = [ "mautrix-discord-registration" ];
        description = "Mautrix-Discord bridge user";
      };

      users.groups.mautrix-discord = { };
      users.groups.mautrix-discord-registration = {
        members = lib.lists.optional config.services.matrix-synapse.enable "matrix-synapse";
      };

      services.matrix-synapse.settings.app_service_config_files = lib.mkIf (
        config.services.matrix-synapse.enable && cfg.registerToSynapse
      ) [ cfg.registrationFile ];

      systemd.services = {
        matrix-synapse = lib.mkIf (config.services.matrix-synapse.enable && cfg.registerToSynapse) {
          wants = [ cfg.registrationServiceUnit ];
          after = [ cfg.registrationServiceUnit ];
        };

        mautrix-discord-registration = {
          description = "Mautrix-Discord registration generation service";

          path = [
            pkgs.yq
            pkgs.envsubst
            cfg.package
          ];

          script = ''
            # substitute the settings file by environment variables
            # in this case read from EnvironmentFile
            rm -f '${settingsFile cfg}'
            old_umask=$(umask)
            umask 0177
            envsubst \
              -o '${settingsFile cfg}' \
              -i '${settingsFileUnsubstituted cfg}'

            config_has_tokens=$(yq '.appservice | has("as_token") and has("hs_token")' '${settingsFile cfg}')
            registration_already_exists=$([[ -f '${cfg.registrationFile}' ]] && echo "true" || echo "false")

            echo "There are tokens in the config: $config_has_tokens"
            echo "Registration already existed: $registration_already_exists"

            # tokens not configured from config/environment file, and registration file
            # is already generated, override tokens in config to make sure they are not lost
            if [[ $config_has_tokens == "false" && $registration_already_exists == "true" ]]; then
              echo "Copying as_token, hs_token from registration into configuration"
              yq -sY '.[0].appservice.as_token = .[1].as_token
                | .[0].appservice.hs_token = .[1].hs_token
                | .[0]' '${settingsFile cfg}' '${cfg.registrationFile}' \
                > '${settingsFile cfg}.tmp'
              mv '${settingsFile cfg}.tmp' '${settingsFile cfg}'
            fi

            # make sure --generate-registration does not affect config.yaml
            cp '${settingsFile cfg}' '${settingsFile cfg}.tmp'

            echo "Generating registration file"
            mautrix-discord \
              --generate-registration \
              --config='${settingsFile cfg}.tmp' \
              --registration='${cfg.registrationFile}'

            rm '${settingsFile cfg}.tmp'

            # no tokens configured, and new were just generated by generate registration for first time
            if [[ $config_has_tokens == "false" && $registration_already_exists == "false" ]]; then
              echo "Copying newly generated as_token, hs_token from registration into configuration"
              yq -sY '.[0].appservice.as_token = .[1].as_token
                | .[0].appservice.hs_token = .[1].hs_token
                | .[0]' '${settingsFile cfg}' '${cfg.registrationFile}' \
                > '${settingsFile cfg}.tmp'
              mv '${settingsFile cfg}.tmp' '${settingsFile cfg}'
            fi

            # Make sure correct tokens are in the registration file
            if [[ $config_has_tokens == "true" || $registration_already_exists == "true" ]]; then
              echo "Copying as_token, hs_token from configuration to the registration file"
              yq -sY '.[1].as_token = .[0].appservice.as_token
                | .[1].hs_token = .[0].appservice.hs_token
                | .[1]' '${settingsFile cfg}' '${cfg.registrationFile}' \
                > '${cfg.registrationFile}.tmp'
              mv '${cfg.registrationFile}.tmp' '${cfg.registrationFile}'
            fi

            umask $old_umask

            chown :mautrix-discord-registration '${cfg.registrationFile}'
            chmod 640 '${cfg.registrationFile}'
          '';

          serviceConfig = {
            Type = "oneshot";
            UMask = 27;

            User = "mautrix-discord";
            Group = "mautrix-discord";

            SystemCallFilter = [ "@system-service" ];

            ProtectSystem = "strict";
            ProtectHome = true;

            ReadWritePaths = fullDataDir cfg;
            StateDirectory = cfg.dataDir;
            EnvironmentFile = cfg.environmentFile;
          };

          restartTriggers = [ (settingsFileUnsubstituted cfg) ];
        };

        mautrix-discord = {
          description = "Mautrix-Discord bridge";
          wantedBy = [ "multi-user.target" ];
          wants = [ "network-online.target" ] ++ cfg.serviceDependencies;
          after = [ "network-online.target" ] ++ cfg.serviceDependencies;

          serviceConfig = {
            Type = "simple";

            User = "mautrix-discord";
            Group = "mautrix-discord";
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
            SystemCallFilter = [ "@system-service" ];
            UMask = 27;

            WorkingDirectory = fullDataDir cfg;
            ReadWritePaths = fullDataDir cfg;
            StateDirectory = cfg.dataDir;
            EnvironmentFile = cfg.environmentFile;

            ExecStart = lib.escapeShellArgs [
              (lib.getExe cfg.package)
              "--config=${settingsFile cfg}"
            ];
          };
          restartTriggers = [ (settingsFileUnsubstituted cfg) ];
        };
      };
      services.mautrix-discord = {
        serviceUnit = "mautrix-discord.service";
        registrationServiceUnit = "mautrix-discord-registration.service";
        registrationFile = (fullDataDir cfg) + "/discord-registration.yaml";
        settings =
          let
            inherit (lib.modules) mkDefault;
          in
          {
            bridge = {
              username_template = mkDefault "discord_{{.}}";
            };

            appservice = {
              id = mkDefault "discord";
              port = mkDefault 29334;
              bot = {
                username = mkDefault "discordbot";
                displayname = mkDefault "Discord bridge bot";
                avatar = mkDefault "mxc://maunium.net/nIdEykemnwdisvHbpxflpDlC";
              };
            };
          };
      };
    }
  );

  meta.maintainers = with lib.maintainers; [ willbou1 ];
}
