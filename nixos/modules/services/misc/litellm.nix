{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) types;

  cfg = config.services.litellm;
  settingsFormat = pkgs.formats.yaml { };
in
{
  options = {
    services.litellm = {
      enable = lib.mkEnableOption "LiteLLM server";
      package = lib.mkPackageOption pkgs "litellm" { };

      stateDir = lib.mkOption {
        type = types.path;
        default = "/var/lib/litellm";
        example = "/home/foo";
        description = "State directory of LiteLLM.";
      };

      host = lib.mkOption {
        type = types.str;
        default = "127.0.0.1";
        example = "0.0.0.0";
        description = ''
          The host address which the LiteLLM server HTTP interface listens to.
        '';
      };

      port = lib.mkOption {
        type = types.port;
        default = 8080;
        example = 11111;
        description = ''
          Which port the LiteLLM server listens to.
        '';
      };

      settings = lib.mkOption {
        type = types.submodule {
          freeformType = settingsFormat.type;
          options = {
            model_list = lib.mkOption {
              type = settingsFormat.type;
              description = ''
                List of supported models on the server, with model-specific configs.
              '';
              default = [ ];
            };
            router_settings = lib.mkOption {
              type = settingsFormat.type;
              description = ''
                LiteLLM Router settings
              '';
              default = { };
            };

            litellm_settings = lib.mkOption {
              type = settingsFormat.type;
              description = ''
                LiteLLM Module settings
              '';
              default = { };
            };

            general_settings = lib.mkOption {
              type = settingsFormat.type;
              description = ''
                LiteLLM Server settings
              '';
              default = { };
            };

            environment_variables = lib.mkOption {
              type = settingsFormat.type;
              description = ''
                Environment variables to pass to the Lite
              '';
              default = { };
            };
          };
        };
        default = { };
        description = ''
          Configuration for LiteLLM.
          See <https://docs.litellm.ai/docs/proxy/configs> for more.
        '';
      };

      environment = lib.mkOption {
        type = types.attrsOf types.str;
        default = {
          SCARF_NO_ANALYTICS = "True";
          DO_NOT_TRACK = "True";
          ANONYMIZED_TELEMETRY = "False";
        };
        example = ''
          {
            NO_DOCS="True";
          }
        '';
        description = ''
          Extra environment variables for LiteLLM.
        '';
      };

      environmentFile = lib.mkOption {
        description = ''
          Environment file to be passed to the systemd service.
          Useful for passing secrets to the service to prevent them from being
          world-readable in the Nix store.
        '';
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/var/lib/secrets/liteLLMSecrets";
      };

      openFirewall = lib.mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to open the firewall for LiteLLM.
          This adds `services.litellm.port` to `networking.firewall.allowedTCPPorts`.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.litellm = {
      description = "LLM Gateway to provide model access, fallbacks and spend tracking across 100+ LLMs.";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      environment = cfg.environment;

      serviceConfig =
        let
          configFile = settingsFormat.generate "config.yaml" cfg.settings;
        in
        {
          ExecStart = "${lib.getExe cfg.package} --host \"${cfg.host}\" --port ${toString cfg.port} --config ${configFile}";
          EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
          WorkingDirectory = cfg.stateDir;
          StateDirectory = "litellm";
          RuntimeDirectory = "litellm";
          RuntimeDirectoryMode = "0755";
          PrivateTmp = true;
          DynamicUser = true;
          DevicePolicy = "closed";
          LockPersonality = true;
          PrivateUsers = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectControlGroups = true;
          RestrictNamespaces = true;
          RestrictRealtime = true;
          SystemCallArchitectures = "native";
          UMask = "0077";
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
          ];
          ProtectClock = true;
          ProtectProc = "invisible";
        };
    };

    networking.firewall = lib.mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };
  };

  meta.maintainers = with lib.maintainers; [ ];
}
