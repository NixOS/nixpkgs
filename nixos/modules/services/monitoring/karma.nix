{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.karma;
  yaml = pkgs.formats.yaml { };
in
{
  options.services.karma = {
    enable = lib.mkEnableOption "the Karma dashboard service";

    package = lib.mkPackageOption pkgs "karma" { };

    configFile = lib.mkOption {
      type = lib.types.path;
      default = yaml.generate "karma.yaml" cfg.settings;
      defaultText = "A configuration file generated from the provided nix attributes settings option.";
      description = ''
        A YAML config file which can be used to configure karma instead of the nix-generated file.
      '';
      example = "/etc/karma/karma.conf";
    };

    environment = lib.mkOption {
      type = with lib.types; attrsOf str;
      default = { };
      description = ''
        Additional environment variables to provide to karma.
      '';
      example = {
        ALERTMANAGER_URI = "https://alertmanager.example.com";
        ALERTMANAGER_NAME = "single";
      };
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open ports in the firewall needed for karma to function.
      '';
    };

    extraOptions = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = ''
        Extra command line options.
      '';
      example = [
        "--alertmanager.timeout 10s"
      ];
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = yaml.type;

        options.listen = {
          address = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1";
            description = ''
              Hostname or IP to listen on.
            '';
            example = "[::]";
          };

          port = lib.mkOption {
            type = lib.types.port;
            default = 8080;
            description = ''
              HTTP port to listen on.
            '';
            example = 8182;
          };
        };
      };
      default = {
        listen = {
          address = "127.0.0.1";
        };
      };
      description = ''
        Karma dashboard configuration as nix attributes.

        Reference: <https://github.com/prymitive/karma/blob/main/docs/CONFIGURATION.md>
      '';
      example = {
        listen = {
          address = "192.168.1.4";
          port = "8000";
          prefix = "/dashboard";
        };
        alertmanager = {
          interval = "15s";
          servers = [
            {
              name = "prod";
              uri = "http://alertmanager.example.com";
            }
          ];
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.karma = {
      description = "Alert dashboard for Prometheus Alertmanager";
      wantedBy = [ "multi-user.target" ];
      environment = cfg.environment;
      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        Restart = "on-failure";
        ExecStart = "${pkgs.karma}/bin/karma --config.file ${cfg.configFile} ${lib.concatStringsSep " " cfg.extraOptions}";
      };
    };
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.settings.listen.port ];
  };
}
