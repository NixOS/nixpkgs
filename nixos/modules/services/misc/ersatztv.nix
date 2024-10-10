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
  inherit (lib.types) str path bool;
  cfg = config.services.ersatztv;
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

      transcodeDir = mkOption {
        type = path;
        default = "/var/lib/etv-transcode";
        description = ''
          Temporary transcode directory
        '';
      };

      configDir = mkOption {
        type = path;
        default = "/var/lib/ersatztv";
        description = ''
          Directory containing the server configuration files and SQLite Database file
        '';
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
    systemd = {
      tmpfiles.settings.ersatztvDirs = {
        "${cfg.transcodeDir}"."d" = {
          mode = "700";
          inherit (cfg) user group;
        };
        "${cfg.configDir}"."d" = {
          mode = "700";
          inherit (cfg) user group;
        };
      };
      services.ersatztv = {
        description = "ErsatzTV";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;
          UMask = "0077";
          WorkingDirectory = cfg.configDir;
          ExecStart = getExe cfg.package;
          Restart = "on-failure";
        };

        environment = {
          ETV_CONFIG_FOLDER = cfg.configDir;
          ETV_TRANSCODE_FOLDER = cfg.transcodeDir;
          ETV_BASE_URL = cfg.baseUrl;
        };
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
      # from https://ersatztv.org/docs/user-guide/install#manual-installation-2
      allowedTCPPorts = [ 8409 ];
    };

  };

  meta.maintainers = with maintainers; [ allout58 ];
}
