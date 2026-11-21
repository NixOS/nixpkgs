{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.oikb;
  inherit (cfg) daemonConfig;
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    getExe
    concatStringsSep
    optionalAttrs
    optional
    optionalString
    ;
in
{
  options.services.oikb = {
    enable = mkEnableOption "oikb Open WebUI Knowledge Base sync service";

    port = mkOption {
      type = types.port;
      description = "Port opened by the daemon";
      default = 8080;
    };

    openFirewall = mkEnableOption "Open the the daemon port in the firewall";

    configPath = mkOption {
      type = types.str;
      description = "Path of the config file to be used by the daemon. Generate a config with `oikb init`";
      default = "/etc/oikb/config.yaml";
    };

    openWebUiUrl = mkOption {
      type = types.str;
      description = "Base URL of the Open WebUI instance";
      example = "http://localhost:3000";
    };

    environment = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = ''
        Additional environment variables, such as:
          - SHAREPOINT_TENANT_ID
          - SHAREPOINT_CLIENT_ID
          - SHAREPOINT_CERTIFICATE_PATH
      '';
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Path to an EnvironmentFile providing OPEN_WEBUI_API_KEY
        and optionally:
        - SHAREPOINT_CLIENT_SECRET
        - SHAREPOINT_CERTIFICATE_PASSWORD
      '';
    };

    apiKeyFile = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Path to a file containing the API key that needs to be passed in web requests header `Authorization: Bearer your-secret-key`";
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Extra CLI arguments passed to `oikb daemon`";
    };

    daemonConfig = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "The daemon's yaml config file contents";
    };
  };

  config = mkIf cfg.enable {
    environment = {
      etc = lib.mkIf (daemonConfig != null) {
        "oikb/config.yaml" = {
          mode = "0444";
          text = daemonConfig;
        };
      };
      systemPackages =
        let
          oikbWrapper = pkgs.symlinkJoin {
            name = "oikb";
            paths = [
              (pkgs.writeShellScriptBin "oikb" ''
                exec systemd-run \
                  --user \
                  --quiet \
                  --pty \
                  --wait \
                  --collect \
                  --pipe \
                  --property=StateDirectory="oikb" \
                  --property=StateDirectoryMode="0750" \
                  --property=ConfigurationDirectory="oikb" \
                  --property=ConfigurationDirectoryMode="0750" \
                  --setenv=OPEN_WEBUI_URL="${cfg.openWebUiUrl}" \
                  --setenv=HOME="%S/oikb" \
                  ${
                    builtins.concatStringsSep " " (
                      map (name: "--property=Environment=${name}=${cfg.environment.${name}}") (
                        builtins.attrNames cfg.environment
                      )
                    )
                  } \
                  ${optionalString (
                    cfg.environmentFile != null
                  ) "--property=EnvironmentFile=${cfg.environmentFile} \\"}
                  -- \
                  ${lib.getExe pkgs.oikb} "$@"
              '')
            ];
          };
        in
        [
          oikbWrapper
        ];
    };

    systemd.services.oikb = {
      description = "oikb Open WebUI Knowledge Base sync (daemon mode)";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      environment = {
        OPEN_WEBUI_URL = cfg.openWebUiUrl;
        HOME = "%S/oikb";
      };

      serviceConfig = {
        ExecStart = "${getExe pkgs.oikb} daemon --port ${toString cfg.port} --config /etc/oikb/config.yaml ${lib.concatStringsSep " " cfg.extraArgs}";
        Restart = "on-failure";
        RestartSec = 5;
        DynamicUser = true;
        StateDirectory = "oikb";
        StateDirectoryMode = "0750";
        ConfigurationDirectory = "oikb";
        ConfigurationDirectoryMode = "0750";
      }
      // (optionalAttrs (cfg.environmentFile != null || cfg.apiKeyFile) {
        EnvironmentFile =
          (optional (cfg.environmentFile != null) cfg.environmentFile)
          ++ (optional (cfg.apiKeyFile != null) cfg.apiKeyFile);
      });
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [
        cfg.port
      ];
      allowedUDPPorts = [
        cfg.port
      ];
    };
  };
}
