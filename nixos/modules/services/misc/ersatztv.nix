{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib)
    mkIf
    getExe
    maintainers
    mkEnableOption
    mkOption
    mkPackageOption
    ;
  inherit (lib.types)
    str
    path
    bool
    float
    int
    package
    ;
  cfg = config.services.ersatztv;
  defaultEnv = {
    ETV_UI_PORT = 8409;
    ETV_BASE_URL = "/";
  };

in
{
  options = {
    services.ersatztv = {
      enable = mkEnableOption "ErsatzTV";

      package = mkPackageOption pkgs "ersatztv" { };

      user = mkOption {
        type = str;
        default = "ersatztv";
        description = "User account under which ErsatzTV runs.";
      };

      group = mkOption {
        type = str;
        default = "ersatztv";
        description = "Group under which ErsatzTV runs.";
      };

      environment = mkOption {
        type =
          with lib.types;
          attrsOf (oneOf [
            str
            int
            float
            bool
            path
            package
          ]);
        default = defaultEnv;
        example = {
          ETV_UI_PORT = 8000;
          ETV_STREAMING_PORT = 8001;
        };
        description = "Environment variables to set for the ErsatzTV service.";
      };

      baseUrl = mkOption {
        type = str;
        default = "/";
        description = ''
          Base URL to support reverse proxies that use paths (e.g. `/ersatztv`)
        '';
      };

      openFirewall = mkOption {
        type = bool;
        default = false;
        description = ''
          Open the default ports in the firewall for the server.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.ersatztv.environment = lib.mapAttrs (_: lib.mkDefault) defaultEnv;

    systemd = {
      services.ersatztv = {
        description = "ErsatzTV";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;
          DynamicUser = true;
          UMask = "0077";
          StateDirectory = "ersatztv";
          WorkingDirectory = "/var/lib/ersatztv";
          ExecStart = getExe cfg.package;
          Restart = "on-failure";
        };

        # Set environment variables for the service, using known values for ETV_CONFIG_FOLDER and ETV_TRANSCODE_FOLDER, and allowing overrides from cfg.environment
        environment = {
          ETV_CONFIG_FOLDER = "/var/lib/ersatztv/config";
          ETV_TRANSCODE_FOLDER = "/var/lib/ersatztv/transcode";
        }
        // (lib.mapAttrs (_: s: if lib.isBool s then lib.boolToString s else toString s) cfg.environment);
      };
    };

    users.users = mkIf (cfg.user == "ersatztv") {
      ersatztv = {
        inherit (cfg) group;
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.group == "ersatztv") { ersatztv = { }; };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [
        cfg.environment.ETV_UI_PORT
      ];
    };

  };

  meta.maintainers = with maintainers; [ allout58 ];
}
