{ config, lib, pkgs, ... }:

let
  cfg = config.services.blackfire-agent;

  agentConfigFile = lib.generators.toINI {} {
    blackfire =  cfg.settings;
  };

  agentSock = "blackfire/agent.sock";
in {
  meta = {
    maintainers = pkgs.blackfire.meta.maintainers;
    doc = ./blackfire.xml;
  };

  options = {
    services.blackfire-agent = {
      enable = lib.mkEnableOption "Blackfire profiler agent";
      settings = lib.mkOption {
        description = ''
          See https://blackfire.io/docs/configuration/agent
        '';
        type = lib.types.submodule {
          freeformType = with lib.types; attrsOf str;

          options = {
            server-id = lib.mkOption {
              type = lib.types.str;
              description = ''
                Sets the server id used to authenticate with Blackfire

                You can find your personal server-id at https://blackfire.io/my/settings/credentials
              '';
            };

            server-token = lib.mkOption {
              type = lib.types.str;
              description = ''
                Sets the server token used to authenticate with Blackfire

                You can find your personal server-token at https://blackfire.io/my/settings/credentials
              '';
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc."blackfire/agent".text = agentConfigFile;

    services.blackfire-agent.settings.socket = "unix:///run/${agentSock}";

    systemd.services.blackfire-agent = {
      description = "Blackfire agent";

      serviceConfig = {
        ExecStart = "${pkgs.blackfire}/bin/blackfire-agent";
        RuntimeDirectory = "blackfire";
      };
    };
  };
}
