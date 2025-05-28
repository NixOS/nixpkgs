{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.meowlnir;
  format = pkgs.formats.yaml { };

  settingsFile = "${cfg.dataDir}/config.yaml";
  settingsFileUnsubstituted = format.generate "meowlnir-config-unsubstituted.yaml" cfg.settings;

  registrationFile = "${cfg.dataDir}/registration.yaml";
  registrationFileUnsubstituted = format.generate "meowlnir-registration-unsubstituted.yaml" cfg.registration;
in
{
  options.services.meowlnir = {
    enable = lib.mkEnableOption "meowlnir service";

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = format.type;
        options = {
          meowlnir = {
            id = lib.mkOption {
              type = lib.types.str;
              default = "meowlnir";
              description = "The ID of the appservice.";
            };
            address = lib.mkOption {
              type = lib.types.str;
              default = "http://${cfg.settings.meowlnir.hostname}:${toString cfg.settings.meowlnir.port}";
              defaultText = lib.literalExpression "http://\${config.services.meowlnir.settings.meowlnir.hostname}:\${toString config.services.meowlnir.settings.meowlnir.port}";
              description = "The address for the appservice to listen on.";
            };
            hostname = lib.mkOption {
              type = lib.types.str;
              default = "localhost";
              description = "The hostname for the appservice to listen on.";
            };
            port = lib.mkOption {
              type = lib.types.int;
              default = 29339;
              description = "The port for the appservice to listen on.";
            };
          };
          encryption = {
            enable =
              lib.mkEnableOption "end-to-end encryption support. This requires MSC3202, MSC4190 and MSC4203 to be implemented on the server"
              // {
                default = true;
              };
            pickle_key = lib.mkOption {
              type = lib.types.str;
              default = "fi.mau.meowlnir.e2ee";
              description = "The pickle key for the encryption module.";
            };
          };
          database = {
            type = lib.mkOption {
              type = lib.types.enum [
                "sqlite3-fk-wal"
                "postgres"
              ];
              default = "sqlite3-fk-wal";
              description = ''
                The type of database to use. Supported values are
                `sqlite3-fk-wal` and `postgres`.
              '';
            };
            uri = lib.mkOption {
              type = lib.types.str;
              default = "file:${cfg.dataDir}/meowlnir.db?_txlock=immediate";
              defaultText = lib.literalExpression "file:\${config.services.meowlnir.dataDir}/meowlnir.db?_txlock=immediate";
              description = "The database URI.";
            };
          };
          logging = {
            min_level = lib.mkOption {
              type = lib.types.str;
              default = "debug";
              description = "The minimum logging level.";
            };
            writers = lib.mkOption {
              type = lib.types.listOf lib.types.attrs;
              default = [
                {
                  type = "stdout";
                  format = "json";
                }
              ];
            };
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

    registration = lib.mkOption rec {
      apply = lib.recursiveUpdate default;
      inherit (format) type;
      example = {
        as_token = "$MEOWLNIR_AS_TOKEN";
        hs_token = "$MEOWLNIR_HS_TOKEN";
        sender_localpart = "mohMex1ro0zaeraimeem";
        namespaces = {
          users = [
            {
              regex = "@abuse:example.com";
              exclusive = true;
            }
          ];
        };
      };
      default = {
        inherit (cfg.settings.meowlnir) id;
        url = cfg.settings.meowlnir.address;
        sender_localpart = "meowlnirfakesenderlocalpart";
        rate_limited = false;
        "org.matrix.msc3202" = true;
        "io.element.msc4190" = true;
        "de.sorunome.msc2409.push_ephemeral" = true;
        receive_ephemeral = true;
      };
      description = ''
        {file}`registration.yaml` configuration as a Nix attribute set. See
        [Appservice registration in the README](https://github.com/maunium/meowlnir/?tab=readme-ov-file#appservice-registration)

        Secret tokens should be specified using {option}`environmentFile`
        instead
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

    serviceDependencies = lib.mkOption {
      type = with lib.types; listOf str;
      default = lib.optional config.services.matrix-synapse.enable config.services.matrix-synapse.serviceUnit;
      defaultText = lib.literalExpression ''
        optional config.services.matrix-synapse.enable config.services.matrix-synapse.serviceUnits
      '';
      description = ''
        List of Systemd services to require and wait for when starting the application service.
      '';
    };

    registerToSynapse = lib.mkOption {
      type = lib.types.bool;
      default = config.services.matrix-synapse.enable;
      defaultText = lib.literalExpression "config.services.matrix-synapse.enable";
      description = ''
        Whether to add the bridge's app service registration file to
        `services.matrix-synapse.settings.app_service_config_files` and enable
        the required experimental features.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users = {
      users.meowlnir = {
        home = cfg.dataDir;
        description = "Meowlnir bridge user";
        group = "meowlnir";
        isSystemUser = true;
      };
      groups.meowlnir = { };
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
    systemd.services.matrix-synapse = lib.mkIf cfg.registerToSynapse {
      serviceConfig.SupplementaryGroups = [ "meowlnir" ];
    };

    services.meowlnir.settings = {
      # Note: this is defined here to avoid the docs depending on `config`
      homeserver.domain = lib.mkDefault config.services.matrix-synapse.settings.server_name;
    };

    systemd.services.meowlnir = {
      description = "meowlnir - opinionated Matrix moderation bot";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ] ++ cfg.serviceDependencies;
      after = [ "network-online.target" ] ++ cfg.serviceDependencies;

      restartTriggers = [ settingsFileUnsubstituted ];
      preStart = ''
        # ensure that the data directory is set up correctly
        mkdir -p ${cfg.dataDir}
        chmod 755 ${cfg.dataDir}

        # substitute the settings file by environment variables
        # in this case read from EnvironmentFile
        test -f '${settingsFile}' && rm -f '${settingsFile}'
        old_umask=$(umask)
        umask 0177
        ${pkgs.envsubst}/bin/envsubst \
          -o '${settingsFile}' \
          -i '${settingsFileUnsubstituted}'
        umask $old_umask

        ${pkgs.envsubst}/bin/envsubst \
          -o '${registrationFile}' \
          -i '${registrationFileUnsubstituted}'
        chmod 644 ${registrationFile}
      '';

      serviceConfig = {
        User = "meowlnir";
        Group = "meowlnir";
        EnvironmentFile = cfg.environmentFile;
        StateDirectory = baseNameOf cfg.dataDir;
        StateDirectoryMode = "0750";
        WorkingDirectory = cfg.dataDir;
        ExecStart = "${pkgs.meowlnir}/bin/meowlnir --config=${settingsFile}";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
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
        Type = "simple";
        UMask = "0027";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ sumnerevans ];
}
