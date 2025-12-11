{
  lib,
  config,
  pkgs,
  ...
}:
let
  defaultDataDir = "/var/lib/mautrix-discord";
  cfg = config.services.mautrix-discord;
  dataDir = cfg.dataDir;
  format = pkgs.formats.yaml { };
  serviceDependencies = [
    "mautrix-discord-registration.service"
  ]
  ++ (lib.lists.optional config.services.matrix-synapse.enable config.services.matrix-synapse.serviceUnit)
  ++ (lib.lists.optional config.services.matrix-conduit.enable "matrix-conduit.service")
  ++ (lib.lists.optional config.services.dendrite.enable "dendrite.service");

  registrationFile = "${dataDir}/discord-registration.yaml";

  settingsFile = "${dataDir}/config.yaml";
  settingsFileUnformatted = format.generate "discord-config-unsubstituted.yaml" cfg.settings;
  default_token = "This value is generated when generating the registration";
  settingsDefault = {
    homeserver = {
      address = "";
      domain = "";
    };

    appservice = {
      address = "http://localhost:29334";
      hostname = "0.0.0.0";
      port = 29334;
      database = {
        type = "sqlite3";
        uri = "file:${defaultDataDir}/mautrix-discord.db?_txlock=immediate";
      };
      id = "discord";
      bot = {
        username = "discordbot";
        displayname = "Discord bridge bot";
        avatar = "mxc://maunium.net/nIdEykemnwdisvHbpxflpDlC";
      };
      as_token = default_token;
      hs_token = default_token;
    };

    bridge.permissions."*" = "relay";

    logging = {
      min_level = "info";
      writers = [
        {
          type = "stdout";
          format = "pretty-colored";
          time_format = " ";
        }
      ];
    };
  };
in
{
  options = {
    services.mautrix-discord = {
      enable = lib.mkEnableOption "Mautrix-Discord, a Matrix-Discord puppeting/relay-bot bridge";

      package = lib.mkPackageOption pkgs "mautrix-discord" { };

      settings = lib.mkOption {
        apply = lib.recursiveUpdate settingsDefault;
        type = format.type;
        default = settingsDefault;
        example = lib.literalExpression ''
          {
            homeserver = {
              address = "http://localhost:8008";
              domain = "example.com";
            };

            bridge.permissions = {
              "example.com" = "user";
              "@admin:example.com" = "admin";
            };
          }
        '';
        description = ''
          {file}`config.yaml` configuration as a Nix attribute set.

          Configuration options should match those described in
          [example-config.yaml](https://github.com/mautrix/discord/blob/main/example-config.yaml).

          Secret tokens should be specified using {option}`environmentFile`
          instead of this world-readable attribute set.
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
        default = defaultDataDir;
        defaultText = defaultDataDir;
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

    };
  };
  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion =
          cfg.settings.homeserver.address or "" != "" && cfg.settings.homeserver.domain or "" != "";
        message = "services.mautrix-discord.settings.homeserver.{address,domain} must be set.";
      }
    ];

    users.users.mautrix-discord = {
      isSystemUser = true;
      group = "mautrix-discord";
      home = dataDir;
      description = "Mautrix-Discord bridge user";
    };

    users.groups.mautrix-discord = { };
    users.groups.mautrix-discord-registration = { };

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

          # Application services should not be rate limited by default.
          yq -Y '.rate_limited = false' '${registrationFile}' > '${registrationFile}.tmp'
          mv '${registrationFile}.tmp' '${registrationFile}'

          umask $old_umask
          chmod 640 '${registrationFile}'
        '';

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          UMask = 27;
          PermissionsStartOnly = true;

          User = "mautrix-discord";
          Group = "mautrix-discord";

          ExecStartPost = ''
            ${pkgs.coreutils}/bin/chown :mautrix-discord-registration '${registrationFile}'
          '';

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
        wants = [ "network-online.target" ] ++ serviceDependencies;
        after = [ "network-online.target" ] ++ serviceDependencies;
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

  };

  meta = {
    maintainers = with lib.maintainers; [
      mistyttm
    ];
    doc = ./mautrix-discord.md;
  };
}
