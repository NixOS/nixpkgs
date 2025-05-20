{
  config,
  lib,
  pkgs,
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
  cfg = config.services.rdt-client;
in
{
  options = {
    services.rdt-client = {
      enable = mkEnableOption "Rdt-Client";

      package = mkPackageOption pkgs "rdt-client" { };

      user = mkOption {
        type = str;
        default = "rdt-client";
        description = "User account under which rdt-client runs.";
      };

      group = mkOption {
        type = str;
        default = "rdt-client";
        description = "Group under which rdt-client runs.";
      };

      dataDir = mkOption {
        type = path;
        default = "/var/lib/rdt-client";
        description = "Base data directory.";
      };

      databaseDir = mkOption {
        type = path;
        default = "${cfg.dataDir}/db";
        defaultText = "\${cfg.dataDir}/db";
        description = "Directory containing the database.";
      };

      logDir = mkOption {
        type = path;
        default = "${cfg.dataDir}/log";
        defaultText = "\${cfg.dataDir}/log";
        description = "Directory where the logs will be stored.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 6500;
        description = "Rdt-Client web UI port.";
      };

      openFirewall = mkOption {
        type = bool;
        default = false;
        description = "Open the port in the firewall for the rdt-client.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd = {
      tmpfiles.settings.rdtClientDirs = {
        "${cfg.dataDir}"."d" = {
          mode = "700";
          inherit (cfg) user group;
        };
        "${cfg.databaseDir}"."d" = {
          mode = "700";
          inherit (cfg) user group;
        };
        "${cfg.logDir}"."d" = {
          mode = "700";
          inherit (cfg) user group;
        };
      };

      services.rdt-client = {
        description = "Rdt-Client";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          User = cfg.user;
          Group = cfg.group;
          StateDirectoryMode = "0750";
          WorkingDirectory = cfg.dataDir;
          StateDirectory = baseNameOf cfg.dataDir;
          ExecStart = "${getExe cfg.package}";
          Restart = "on-failure";
          TimeoutSec = 15;
        };

        environment = {
          Port = "${toString cfg.port}";
          Database__Path = "${cfg.databaseDir}/rdtclient.db";
          Logging__File__Path = "${cfg.logDir}/rdtclient.db";
        };
      };
    };

    users.users = mkIf (cfg.user == "rdt-client") {
      rdt-client = {
        inherit (cfg) group;
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.group == "rdt-client") {
      rdt-client = { };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };

  meta.maintainers = with maintainers; [
    dmilligan
  ];
}
