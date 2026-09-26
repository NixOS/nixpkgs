{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.home-assistant-matter-hub;
  settingsFormat = pkgs.formats.json { };
  configFile = settingsFormat.generate "home-assistant-matter-hub.json" cfg.settings;
in
{
  meta.maintainers = with lib.maintainers; [
    kranzes
    marie
  ];

  options.services.home-assistant-matter-hub = {
    enable = lib.mkEnableOption "home-assistant-matter-hub, a Matter bridge for Home Assistant";

    package = lib.mkPackageOption pkgs "home-assistant-matter-hub" { };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open the Matter commissioning ports (UDP/TCP 5540) in the
        firewall.
      '';
    };

    accessTokenFile = lib.mkOption {
      type = lib.types.externalPath;
      example = "/run/secrets/home-assistant-matter-hub-token";
      description = ''
        Path to a file containing a Home Assistant long-lived access token.
        The file is loaded as a systemd credential and read into
        `HAMH_HOME_ASSISTANT_ACCESS_TOKEN` at service start.
      '';
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
        options = {
          homeAssistantUrl = lib.mkOption {
            type = lib.types.str;
            example = lib.literalExpression "config.services.home-assistant.config.homeassistant.internal_url";
            description = "HTTP URL of the Home Assistant instance to bridge.";
          };

          httpPort = lib.mkOption {
            type = lib.types.port;
            default = 8482;
            description = "Port the web interface listens on.";
          };
        };
      };
      default = { };
      example = lib.literalExpression ''
        {
          homeAssistantUrl = config.services.home-assistant.config.homeassistant.internal_url;
        }
      '';
      description = ''
        Configuration written to a JSON file and passed to
        `home-assistant-matter-hub start --config`. Keys use camelCase, matching
        the long-form CLI flags. See
        <https://riddix.github.io/home-assistant-matter-hub/getting-started/installation#23-configuration-options>
        for the full list of options.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ 5540 ];
      allowedUDPPorts = [ 5540 ];
    };

    systemd.services.home-assistant-matter-hub = {
      description = "Home Assistant Matter Hub";
      documentation = [ "https://riddix.github.io/home-assistant-matter-hub/" ];
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      script = ''
        export HAMH_HOME_ASSISTANT_ACCESS_TOKEN=$(systemd-creds cat HAMH_HOME_ASSISTANT_ACCESS_TOKEN)
        exec ${lib.getExe cfg.package} start --config=${configFile} --storage-location="$1"
      '';
      scriptArgs = "%S/home-assistant-matter-hub";

      serviceConfig = {
        LoadCredential = [ "HAMH_HOME_ASSISTANT_ACCESS_TOKEN:${cfg.accessTokenFile}" ];
        DynamicUser = true;
        StateDirectory = "home-assistant-matter-hub";
      };
    };
  };
}
