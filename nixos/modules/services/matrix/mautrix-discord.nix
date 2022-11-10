{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.mautrix-discord;
  dataDir = "/var/lib/mautrix-discord";
  registrationFile = "${dataDir}/discord-registration.yaml";
  settingsFormat = pkgs.formats.yaml { };
  settingsFile = settingsFormat.generate "mautrix-discord-config.yaml" cfg.settings;
  runtimeSettingsFile = "${dataDir}/config.yaml";
in {
  options = {
    services.mautrix-discord = {
      enable = mkEnableOption (mdDoc "Matrix to Discord hybrid puppeting/relaybot bridge");

      package = mkOption {
        type = types.package;
        default = pkgs.mautrix-discord;
        defaultText = literalExpression "pkgs.mautrix-discord";
        description = mdDoc ''
          The mautrix-discord package to use.
        '';
      };

      settings = mkOption rec {
        apply = recursiveUpdate default;
        inherit (settingsFormat) type;
        default = {
          homeserver = {
            software = "standard";
          };

          appservice = rec {
            database = {
              type = "sqlite3";
              uri = "file:${dataDir}/mautrix-discord.db";
            };
            port = 8080;
            address = "http://localhost:${toString port}";
          };

          bridge = {
            permissions."*" = "relay";
            double_puppet_server_map = {};
            login_shared_secret_map = {};
          };

          logging = {
            directory = "";
            file_name_format = ""; # Disable file logging
            file_date_format = "2006-01-02";
            file_mode = 384;
            timestamp_format = "Jan _2, 2006 15:04:05";
            print_level = "warn";
            print_json = false;
            file_json = false;
          };
        };
        description = mdDoc ''
          Bridge configuration as a Nix attribute set.

          Configuration options should match those described in
          [example-config.yaml](https://github.com/mautrix/discord/blob/main/example-config.yaml).
        '';
      };

      serviceDependencies = mkOption {
        type = with types; listOf str;
        default = optional config.services.matrix-synapse.enable "matrix-synapse.service";
        defaultText = literalExpression ''
          optional config.services.matrix-synapse.enable "matrix-synapse.service"
        '';
        description = mdDoc ''
          List of Systemd services to require and wait for when starting the application service.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.mautrix-discord = {
      description = "Matrix to Discord hybrid puppeting/relaybot bridge";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ] ++ cfg.serviceDependencies;
      after = [ "network-online.target" ] ++ cfg.serviceDependencies;

      preStart = ''
        # Generate the appservice's registration file if absent
        if [ ! -f '${registrationFile}' ]; then
          ${cfg.package}/bin/mautrix-discord \
            --config '${settingsFile}' \
            --registration '${registrationFile}' \
            --generate-registration
        fi

        old_umask=$(umask)
        umask 0177
        # Extract the AS and HS tokens from the registration and add them to the settings file
        ${pkgs.yq}/bin/yq -y ".appservice.as_token = $(${pkgs.yq}/bin/yq .as_token ${registrationFile}) | .appservice.hs_token = $(${pkgs.yq}/bin/yq .hs_token ${registrationFile})" ${settingsFile} > ${runtimeSettingsFile}
        umask $old_umask
      '';

      serviceConfig = {
        Type = "simple";
        Restart = "always";

        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;

        DynamicUser = true;
        PrivateTmp = true;
        WorkingDirectory = cfg.package;
        StateDirectory = baseNameOf dataDir;
        UMask = "0027";

        ExecStart = ''
          ${cfg.package}/bin/mautrix-discord \
            --config ${runtimeSettingsFile} \
            --no-update
        '';
      };
    };
  };

  meta.maintainers = with maintainers; [ robin ];
}
