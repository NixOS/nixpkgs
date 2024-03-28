{ config, pkgs, lib, ... }:

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
      enable = lib.mkEnableOption "Matrix to Discord hybrid puppeting/relaybot bridge";

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.mautrix-discord;
        defaultText = lib.literalExpression "pkgs.mautrix-discord";
        description = "The mautrix-discord package to use.";
      };

      settings = lib.mkOption rec {
        apply = lib.recursiveUpdate default;
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
        description = ''
          Bridge configuration as a Nix attribute set.

          Configuration options should match those described in
          [example-config.yaml](https://github.com/mautrix/discord/blob/main/example-config.yaml).
        '';
      };

      serviceDependencies = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = lib.optional config.services.matrix-synapse.enable "matrix-synapse.service";
        defaultText = lib.literalExpression ''
          optional config.services.matrix-synapse.enable "matrix-synapse.service"
        '';
        description = "List of Systemd services to require and wait for when starting the application service.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.mautrix-discord = lib.mkIf cfg.enable {
      description = "Matrix to Discord hybrid puppeting/relaybot bridge";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ] ++ cfg.serviceDependencies;
      after = [ "network-online.target" ] ++ cfg.serviceDependencies;

      preStart = ''
        # Generate the appservice's registration file if absent
        if [ ! -f '${registrationFile}' ]; then
          ${lib.getExe cfg.package} \
            --config '${settingsFile}' \
            --registration '${registrationFile}' \
            --generate-registration
        fi

        old_umask=$(umask)
        umask 0177
        # Extract the AS and HS tokens from the registration and add them to the settings file
        ${lib.getExe pkgs.yq} -y ".appservice.as_token = $(${lib.getExe pkgs.yq} .as_token ${registrationFile}) | .appservice.hs_token = $(${lib.getExe pkgs.yq} .hs_token ${registrationFile})" ${settingsFile} > ${runtimeSettingsFile}
        umask $old_umask
      '';

      serviceConfig =
        let
          needsPrivileges = cfg.settings.appservice.port < 1024;
          capabilities = [ (if needsPrivileges then "CAP_NET_BIND_SERVICE" else "") ];
        in {
          Type = "simple";
          Restart = "always";

          DynamicUser = true;
          WorkingDirectory = cfg.package;
          StateDirectory = baseNameOf dataDir;
          UMask = "0007";

          ExecStart = ''
            ${lib.getExe cfg.package} \
              --config ${runtimeSettingsFile} \
              --no-update
          '';

          TemporaryFileSystem = [ "/" ];
          BindPaths = [ dataDir ];
          BindReadOnlyPaths = [ builtins.storeDir ];
          AmbientCapabilities = capabilities;
          CapabilityBoundingSet = capabilities;
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateTmp = true;
          PrivateUsers = !needsPrivileges;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectSystem = "strict";
          ProtectProc = "invisible";
          ProcSubset = "pid";
          RemoveIPC = true;
          RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [ "@system-service" ];
        };
      };
  };

  meta.maintainers = with lib.maintainers; [ robin ];
}
