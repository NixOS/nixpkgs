{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.meowlnir;
  format = pkgs.formats.yaml { };

  registrationFile = "${cfg.dataDir}/registration.yaml";

  settingsFile = "${cfg.dataDir}/config.yaml";
  settingsFileUnsubstituted = format.generate "meowlnir-config-unsubstituted.yaml" cfg.settings;
in
{
  options.services.meowlnir = {
    enable = lib.mkEnableOption "meowlnir service";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.meowlnir;
      defaultText = lib.literalExpression "pkgs.meowlnir";
      description = "The meowlnir package to use.";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = format.type;

        config = {
          _module.args = { inherit cfg lib; };
        };

        options = {
          homeserver = lib.mkOption {
            type = lib.types.attrs;
            default = { };
            description = ''
              See [example-config.yaml](https://github.com/maunium/meowlnir/blob/main/config/example-config.yaml)
              for more information.
            '';
          };

          meowlnir = lib.mkOption {
            type = lib.types.attrs;
            default = rec {
              id = "meowlnir";
              default = "http://${hostname}:${port}";
              hostname = "localhost";
              port = 29339;
              as_token = "generate";
              hs_token = "generate";
            };
            defaultText = lib.literalExpression ''
              {
                id = "meowlnir";
                default = "http://''${hostname}:''${port}";
                hostname = "localhost";
                port = 29339;
                as_token = "generate";
                hs_token = "generate";
              }
            '';
            description = ''
              The configuration for the meowlnir appservice.
              See [example-config.yaml](https://github.com/maunium/meowlnir/blob/main/config/example-config.yaml)
              for more information.
            '';
          };

          encryption = lib.mkOption {
            type = lib.types.attrs;
            default = {
              enable = true;
              pickle_key = "generate";
            };
            defaultText = lib.literalExpression ''
              {
                enable = true;
                pickle_key = "generate";
              }
            '';
            description = ''
              The encryption configuration for meowlnir.
              See [example-config.yaml](https://github.com/maunium/meowlnir/blob/main/config/example-config.yaml)
              for more information.
            '';
          };

          database = lib.mkOption {
            type = lib.types.attrs;
            default = {
              type = "sqlite3";
              uri = "file:${cfg.dataDir}/meowlnir.db?_txlock=immediate";
            };
            defaultText = lib.literalExpression ''
              {
                type = "sqlite3";
                uri = "file:${cfg.dataDir}/meowlnir.db?_txlock=immediate";
              }
            '';
            description = ''
              The database configuration for meowlnir.
              See [example-config.yaml](https://github.com/maunium/meowlnir/blob/main/config/example-config.yaml)
              for more information.
            '';
          };

          synapse_db = lib.mkOption {
            type = lib.types.attrs;
            default = {
              type = "postgres";
            };
            defaultText = lib.literalExpression ''
              {
                type = "postgres";
              }
            '';
            description = ''
              The Synapse database configuration for meowlnir.
              See [example-config.yaml](https://github.com/maunium/meowlnir/blob/main/config/example-config.yaml)
              for more information.
            '';
          };

          logging = lib.mkOption {
            type = lib.types.attrs;
            default = {
              min_level = "debug";
              writers = [
                {
                  type = "stdout";
                  format = "json";
                }
              ];
            };
            defaultText = lib.literalExpression ''
              {
                min_level = "debug";
                writers = [
                  {
                    type = "stdout";
                    format = "json";
                  }
                ];
              }
            '';
            description = ''
              The logging configuration for meowlnir.
              See [example-config.yaml](https://github.com/maunium/meowlnir/blob/main/config/example-config.yaml)
              for more information.
            '';
          };
        };
      };
      example = {
        homeserver = {
          address = "http://localhost:8008";
          domain = "example.com";
        };

        meowlnir = {
          id = "meowlnir";
          as_token = "$MEOWLNIR_AS_TOKEN";
          hs_token = "$MEOWLNIR_HS_TOKEN";
          pickle_key = "$MEOWLNIR_PICKLE_KEY";
          management_secret = "$MEOWLNIR_MANAGEMENT_SECRET";
          report_room = "!reportroom:example.com";
        };

        antispam.secret = "$MEOWLNIR_ANTISPAM_SECRET";

        synapse_db = {
          type = "postgres";
          uri = "postgres://meowlnir:meowlnir@localhost/matrix-synapse?sslmode=disable";
        };
      };
      default = { };
      description = ''
        {file}`config.yaml` configuration as a Nix attribute set.
        Configuration options should match those described in
        [example-config.yaml](https://github.com/maunium/meowlnir/blob/main/config/example-config.yaml).

        Secret tokens should be specified using {option}`environmentFile`
        instead
      '';
    };

    registerToSynapse = lib.mkOption {
      type = lib.types.bool;
      default = config.services.matrix-synapse.enable;
      defaultText = lib.literalExpression "config.services.matrix-synapse.enable";
      description = ''
        Whether to add meowlnir's app service registration file to
        `services.matrix-synapse.settings.app_service_config_files`.
      '';
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      readOnly = true;
      default = "/var/lib/meowlnir";
      description = ''
        The directory the appservice will store various bits of information in.
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        File containing environment variables to substitute when copying the configuration
        out of Nix store to the `services.meowlnir.dataDir`.

        Can be used for storing the secrets without making them available in the Nix store.

        For example, you can set `services.meowlnir.settings.appservice.as_token = "$MEOWLNIR_APPSERVICE_AS_TOKEN"`
        and then specify `MEOWLNIR_APPSERVICE_AS_TOKEN="{token}"` in the environment file.
        This value will get substituted into the configuration file as as token.
      '';
    };

    serviceUnit = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      default = "meowlnir.service";
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
      default = "meowlnir-registration.service";
      description = ''
        The registration service that generates the registration file.
        Systemd unit (a service or a target) for other services to depend on if they
        need to be started after meowlnir registration service.
        This option is useful as the actual parent unit for all matrix-synapse processes
        changes when configuring workers.
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
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion =
          cfg.settings.homeserver.domain or "" != "" && cfg.settings.homeserver.address or "" != "";
        message = ''
          The options with information about the homeserver:
          `services.meowlnir.settings.homeserver.domain` and
          `services.meowlnir.settings.homeserver.address` have to be set.
        '';
      }
      {
        assertion = cfg.settings.meowlnir.id != "";
        message = ''
          The option `services.meowlnir.settings.appservice.id` has to be set.
        '';
      }
    ];

    users = {
      users.meowlnir = {
        home = cfg.dataDir;
        description = "Meowlnir bridge user";
        group = "meowlnir";
        isSystemUser = true;
        extraGroups = [ "meowlnir-registration" ];
      };

      groups = {
        meowlnir = { };
        meowlnir-registration = {
          members = lib.lists.optional config.services.matrix-synapse.enable "matrix-synapse";
        };
      };
    };

    services.matrix-synapse = lib.mkIf cfg.registerToSynapse {
      settings = {
        app_service_config_files = [ registrationFile ];
        experimental_features = {
          # Actually MSC4203, but it was previously a part of MSC2409
          msc2409_to_device_messages_enabled = true;
          # MSC3202 has two parts, both need to be enabled
          msc3202_device_masquerading = true;
          msc3202_transaction_extensions = true;
        };
      };
    };
    systemd.services = {
      matrix-synapse = lib.mkIf cfg.registerToSynapse {
        serviceConfig.SupplementaryGroups = [ "meowlnir-registration" ];
        # Make synapse depend on the registration service when auto-registering
        wants = [ "meowlnir-registration.service" ];
        after = [ "meowlnir-registration.service" ];
      };

      meowlnir-registration = {
        description = "Meowlnir registration generation service";

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
          envsubst \
            -o '${settingsFile}' \
            -i '${settingsFileUnsubstituted}'
          config_has_tokens=$(yq '.appservice | has("as_token") and has("hs_token")' '${settingsFile}')
          registration_already_exists=$([[ -f '${registrationFile}' ]] && echo "true" || echo "false")
          echo "There are tokens in the config: $config_has_tokens"
          echo "Registration already existed: $registration_already_exists"
          # tokens not configured from config/environment file, and registration file
          # is already generated, override tokens in config to make sure they are not lost
          if [[ $config_has_tokens == "false" && $registration_already_exists == "true" ]]; then
            echo "Copying as_token, hs_token from registration into configuration"
            yq -sY '.[0].appservice.as_token = .[1].as_token
              | .[0].appservice.hs_token = .[1].hs_token
              | .[0]' '${settingsFile}' '${registrationFile}' \
              > '${settingsFile}.tmp'
            mv '${settingsFile}.tmp' '${settingsFile}'
          fi
          # make sure --generate-registration does not affect config.yaml
          cp '${settingsFile}' '${settingsFile}.tmp'
          echo "Generating registration file"
          meowlnir \
            --generate-registration \
            --config='${settingsFile}.tmp' \
            --registration='${registrationFile}'
          rm '${settingsFile}.tmp'
          # no tokens configured, and new were just generated by generate registration for first time
          if [[ $config_has_tokens == "false" && $registration_already_exists == "false" ]]; then
            echo "Copying newly generated as_token, hs_token from registration into configuration"
            yq -sY '.[0].appservice.as_token = .[1].as_token
              | .[0].appservice.hs_token = .[1].hs_token
              | .[0]' '${settingsFile}' '${registrationFile}' \
              > '${settingsFile}.tmp'
            mv '${settingsFile}.tmp' '${settingsFile}'
          fi
          # make sure --generate-registration does not affect config.yaml
          cp '${settingsFile}' '${settingsFile}.tmp'
          echo "Generating registration file"
          meowlnir \
            --generate-registration \
            --config='${settingsFile}.tmp' \
            --registration='${registrationFile}'
          rm '${settingsFile}.tmp'
          # no tokens configured, and new were just generated by generate registration for first time
          if [[ $config_has_tokens == "false" && $registration_already_exists == "false" ]]; then
            echo "Copying newly generated as_token, hs_token from registration into configuration"
            yq -sY '.[0].appservice.as_token = .[1].as_token
              | .[0].appservice.hs_token = .[1].hs_token
              | .[0]' '${settingsFile}' '${registrationFile}' \
              > '${settingsFile}.tmp'
            mv '${settingsFile}.tmp' '${settingsFile}'
          fi
          # Make sure correct tokens are in the registration file
          if [[ $config_has_tokens == "true" || $registration_already_exists == "true" ]]; then
            echo "Copying as_token, hs_token from configuration to the registration file"
            yq -sY '.[1].as_token = .[0].appservice.as_token
              | .[1].hs_token = .[0].appservice.hs_token
              | .[1]' '${settingsFile}' '${registrationFile}' \
              > '${registrationFile}.tmp'
            mv '${registrationFile}.tmp' '${registrationFile}'
          fi
          umask $old_umask
          chown :meowlnir-registration '${registrationFile}'
          chmod 640 '${registrationFile}'
        '';

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          UMask = 27;

          User = "meowlnir";
          Group = "meowlnir";

          SystemCallFilter = [ "@system-service" ];

          ProtectSystem = "strict";
          ProtectHome = true;

          ReadWritePaths = [ cfg.dataDir ];
          StateDirectory = "meowlnir";
          EnvironmentFile = cfg.environmentFile;
        };

        restartTriggers = [ settingsFileUnsubstituted ];
      };

      meowlnir = {
        description = "meowlnir - opinionated Matrix moderation bot";

        wantedBy = [ "multi-user.target" ];
        wants = [ "network-online.target" ] ++ cfg.serviceDependencies;
        after = [ "network-online.target" ] ++ cfg.serviceDependencies;

        restartTriggers = [ settingsFileUnsubstituted ];

        serviceConfig = {
          Type = "simple";
          User = "meowlnir";
          Group = "meowlnir";
          PrivateUsers = true;
          Restart = "on-failure";
          RestartSec = 30;
          WorkingDirectory = cfg.dataDir;
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
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ sumnerevans ];
}
