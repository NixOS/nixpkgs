{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.mautrix-discord;
  dataDir = cfg.dataDir;
  format = pkgs.formats.yaml { };

  registrationFile = "${dataDir}/discord-registration.yaml";

  settingsFile = "${dataDir}/config.yaml";
  settingsFileUnformatted = format.generate "discord-config-unsubstituted.yaml" cfg.settings;
  default_token = "This value is generated when generating the registration";
in
{
  options = {
    services.mautrix-discord = {
      enable = lib.mkEnableOption "Mautrix-Discord, a Matrix-Discord puppeting/relay-bot bridge";

      package = lib.mkPackageOption pkgs "mautrix-discord" { };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = format.type;

          options = {
            homeserver = {
              address = lib.mkOption {
                type = lib.types.str;
                example = "http://localhost:8008";
                description = "The address of the homeserver.";
              };

              domain = lib.mkOption {
                type = lib.types.str;
                example = "example.com";
                description = "The domain of the homeserver.";
              };

              software = lib.mkOption {
                type = lib.types.str;
                default = "standard";
                description = "The software running the homeserver.";
              };
            };

            appservice = {
              address = lib.mkOption {
                type = lib.types.str;
                example = "http://localhost:29334";
                description = "The address that the appservice will listen on.";
              };

              hostname = lib.mkOption {
                type = lib.types.str;
                default = "0.0.0.0";
                description = "The hostname to bind to.";
              };

              port = lib.mkOption {
                type = lib.types.port;
                example = 29334;
                description = "The port that the appservice will listen on.";
              };

              database = lib.mkOption {
                type = lib.types.submodule {
                  freeformType = format.type;
                  options = {
                    type = lib.mkOption {
                      type = lib.types.str;
                      default = "sqlite3";
                      description = "Database type.";
                    };

                    uri = lib.mkOption {
                      type = lib.types.str;
                      description = "Database connection URI.";
                    };
                  };
                };
                description = "Database configuration.";
              };

              id = lib.mkOption {
                type = lib.types.str;
                default = "discord";
                description = "Appservice ID.";
              };

              bot = lib.mkOption {
                type = lib.types.submodule {
                  freeformType = format.type;
                  options = {
                    username = lib.mkOption {
                      type = lib.types.str;
                      default = "discordbot";
                      description = "Bot username.";
                    };

                    displayname = lib.mkOption {
                      type = lib.types.str;
                      default = "Discord bridge bot";
                      description = "Bot display name.";
                    };
                  };
                };
                default = { };
                description = "Bot configuration.";
              };

              as_token = lib.mkOption {
                type = lib.types.str;
                default = default_token;
                description = "Application service token.";
              };

              hs_token = lib.mkOption {
                type = lib.types.str;
                default = default_token;
                description = "Homeserver token.";
              };
            };

            bridge = {
              permissions = lib.mkOption {
                type = lib.types.attrsOf lib.types.str;
                example = {
                  "example.com" = "user";
                  "@admin:example.com" = "admin";
                };
                description = ''
                  Bridge permissions. Users in this list can use the bridge.
                  * - All Matrix users
                  domain - All users on a given homeserver
                  mxid - Specific user
                '';
              };
            };

            logging = lib.mkOption {
              type = lib.types.attrs;
              default = {
                min_level = "info";
                writers = [
                  {
                    type = "stdout";
                    format = "pretty-colored";
                    time_format = " ";
                  }
                ];
              };
              description = "Logging configuration.";
            };
          };
        };
        default = { };
        description = ''
          Configuration for mautrix-discord. See
          [example-config.yaml](https://github.com/mautrix/discord/blob/main/example-config.yaml)
          for available options.
        '';
      };

      registerToSynapse = lib.mkOption {
        type = lib.types.bool;
        default = config.services.matrix-synapse.enable;
        defaultText = lib.literalExpression "config.services.matrix-synapse.enable";
        description = ''
          Whether to add the bridge's app service registration file to
          `services.matrix-synapse.settings.app_service_config_files`.
        '';
      };

      dataDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/mautrix-discord";
        defaultText = "/var/lib/mautrix-discord";
        description = "Directory to store the bridge's data.";
      };

      # TODO: Get upstream to add an environment File option. Refer to https://github.com/NixOS/nixpkgs/pull/404871#issuecomment-2895663652 and https://github.com/mautrix/discord/issues/187
      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          File containing environment variables for secret substitution.
          Variables in the config like `$VARIABLE` will be replaced.
        '';
      };

      serviceUnit = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        default = "mautrix-discord.service";
        description = "The systemd service unit name.";
      };

      registrationServiceUnit = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        default = "mautrix-discord-registration.service";
        description = "The registration service unit name.";
      };

      serviceDependencies = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          cfg.registrationServiceUnit
        ]
        ++ (lib.lists.optional config.services.matrix-synapse.enable config.services.matrix-synapse.serviceUnit)
        ++ (lib.lists.optional config.services.matrix-conduit.enable "matrix-conduit.service")
        ++ (lib.lists.optional config.services.dendrite.enable "dendrite.service");

        defaultText = ''
          [ cfg.registrationServiceUnit ] ++
          (lib.lists.optional config.services.matrix-synapse.enable config.services.matrix-synapse.serviceUnit) ++
          (lib.lists.optional config.services.matrix-conduit.enable "matrix-conduit.service") ++
          (lib.lists.optional config.services.dendrite.enable "dendrite.service");
        '';
        description = "Additional systemd service dependencies.";
      };
    };
  };
  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion =
          cfg.settings.homeserver.address or "" != "" && cfg.settings.homeserver.domain or "" != "";
        message = "services.mautrix-discord.settings.homeserver.{address,domain} must be set.";
      }
      {
        assertion = cfg.settings.bridge.permissions or { } != { };
        message = "services.mautrix-discord.settings.bridge.permissions must be set.";
      }
      {
        assertion =
          cfg.settings.appservice.port or null != null && cfg.settings.appservice.address or "" != "";
        message = "services.mautrix-discord.settings.appservice.{port,address} must be set.";
      }
      {
        assertion = cfg.settings.appservice.database.uri or "" != "";
        message = "services.mautrix-discord.settings.appservice.database.uri must be set.";
      }
    ];

    users.users.mautrix-discord = {
      isSystemUser = true;
      group = "mautrix-discord";
      extraGroups = [ "mautrix-discord-registration" ];
      home = dataDir;
      description = "Mautrix-Discord bridge user";
    };

    users.groups.mautrix-discord = { };
    users.groups.mautrix-discord-registration = {
      members = lib.lists.optional config.services.matrix-synapse.enable "matrix-synapse";
    };

    services.matrix-synapse = lib.mkIf cfg.registerToSynapse {
      settings.app_service_config_files = [ registrationFile ];
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 770 mautrix-discord mautrix-discord -"
    ];

    systemd.services = {
      matrix-synapse = lib.mkIf cfg.registerToSynapse {
        serviceConfig.SupplementaryGroups = [ "mautrix-discord-registration" ];
        # Make synapse depend on the registration service when auto-registering
        wants = [ "mautrix-discord-registration.service" ];
        after = [ "mautrix-discord-registration.service" ];
      };

      mautrix-discord-registration = {
        description = "Mautrix-Discord registration generation service";

        wantedBy = lib.mkIf cfg.registerToSynapse [ "multi-user.target" ];
        before = lib.mkIf cfg.registerToSynapse [ "matrix-synapse.service" ];

        path = [
          pkgs.yq
          pkgs.envsubst
          cfg.package
        ];

        script = ''
          # substitute the settings file by environment variables
          # in this case read from EnvironmentFile
          rm -f '${settingsFile}'
          old_umask=$(umask)
          umask 0177

          envsubst -o '${settingsFile}' -i '${settingsFileUnformatted}'

          # Check if config has tokens or uses defaults
          as_token=$(yq -r '.appservice.as_token' '${settingsFile}')
          hs_token=$(yq -r '.appservice.hs_token' '${settingsFile}')
          config_has_tokens=$([[ "$as_token" != "${default_token}" && "$as_token" != "null" && "$hs_token" != "${default_token}" && "$hs_token" != "null" ]] && echo "true" || echo "false")

          if [[ -f '${registrationFile}' ]]; then
            registration_exists="true"
          else
            registration_exists="false"
          fi

          echo "Config has tokens: $config_has_tokens, Registration exists: $registration_exists"

          # If config has default tokens but registration exists, restore tokens from registration
          if [[ $config_has_tokens == "false" && $registration_exists == "true" ]]; then
            echo "Restoring tokens from existing registration"
            yq -sY '.[0].appservice.as_token = .[1].as_token | .[0].appservice.hs_token = .[1].hs_token | .[0]' \
              '${settingsFile}' '${registrationFile}' > '${settingsFile}.tmp'
            mv '${settingsFile}.tmp' '${settingsFile}'
          fi

          # If config has default tokens and no registration exists, generate new tokens
          if [[ $config_has_tokens == "false" && $registration_exists == "false" ]]; then
            echo "Generating new tokens for first-time setup"
            # Generate random tokens (64 character alphanumeric strings)
            new_as_token=$(LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 64)
            new_hs_token=$(LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 64)

            # Save generated tokens to config
            yq -Y ".appservice.as_token = \"$new_as_token\" | .appservice.hs_token = \"$new_hs_token\"" \
              '${settingsFile}' > '${settingsFile}.tmp'
            mv '${settingsFile}.tmp' '${settingsFile}'

            # Verify tokens were replaced
            if [[ $(yq -r '.appservice.as_token' '${settingsFile}') == "${default_token}" ]]; then
              echo "ERROR: Failed to replace default tokens"
              exit 1
            fi
            echo "Successfully generated and saved new tokens"
          fi

          # Generate registration file with tokens from config
          cp '${settingsFile}' '${settingsFile}.tmp'
          echo "Generating registration file"
          mautrix-discord --generate-registration --config='${settingsFile}.tmp' --registration='${registrationFile}'
          rm '${settingsFile}.tmp'

          # Ensure registration file has the same tokens as config (mautrix-discord may regenerate them)
          yq -sY '.[1].as_token = .[0].appservice.as_token | .[1].hs_token = .[0].appservice.hs_token | .[1]' \
            '${settingsFile}' '${registrationFile}' > '${registrationFile}.tmp'
          mv '${registrationFile}.tmp' '${registrationFile}'

          umask $old_umask
          chown :mautrix-discord-registration '${registrationFile}'
          chmod 640 '${registrationFile}'
        '';

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          UMask = 27;

          User = "mautrix-discord";
          Group = "mautrix-discord";

          SystemCallFilter = [ "@system-service" ];

          ProtectSystem = "strict";
          ProtectHome = true;

          ReadWritePaths = [ dataDir ];
          StateDirectory = "mautrix-discord";
          EnvironmentFile = cfg.environmentFile;
        };

        restartTriggers = [ settingsFileUnformatted ];
      };

      mautrix-discord = {
        description = "Mautrix-Discord, a Matrix-Discord puppeting/relaybot bridge";

        wantedBy = [ "multi-user.target" ];
        wants = [ "network-online.target" ] ++ cfg.serviceDependencies;
        after = [ "network-online.target" ] ++ cfg.serviceDependencies;
        path = [
          pkgs.lottieconverter
          pkgs.ffmpeg-headless
        ];

        serviceConfig = {
          Type = "simple";
          User = "mautrix-discord";
          Group = "mautrix-discord";
          PrivateUsers = true;
          Restart = "on-failure";
          RestartSec = 30;
          WorkingDirectory = dataDir;
          ExecStart = ''
            ${lib.getExe cfg.package} \
              --config='${settingsFile}'
          '';
          EnvironmentFile = cfg.environmentFile;

          ProtectSystem = "strict";
          ProtectHome = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectControlGroups = true;
          PrivateDevices = true;
          PrivateTmp = true;
          RestrictSUIDSGID = true;
          RestrictRealtime = true;
          LockPersonality = true;
          ProtectKernelLogs = true;
          ProtectHostname = true;
          ProtectClock = true;

          SystemCallArchitectures = "native";
          SystemCallErrorNumber = "EPERM";
          SystemCallFilter = "@system-service";
          ReadWritePaths = [ cfg.dataDir ];
        };

        restartTriggers = [ settingsFileUnformatted ];
      };
    };

    meta = {
      maintainers = with lib.maintainers; [
        mistyttm
      ];
      doc = ./mautrix-discord.md;
    };
  };
}
