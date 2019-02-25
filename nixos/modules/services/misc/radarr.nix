{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.radarr;

in
{
  options = {
    services.radarr = {
      enable = mkEnableOption "Radarr";

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/radarr/.config/Radarr";
        description = "The directory where Radarr stores its data files.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = "Open ports in the firewall for the Radarr web interface.";
      };

      user = mkOption {
        type = types.str;
        default = "radarr";
        description = "User account under which Radarr runs.";
      };

      group = mkOption {
        type = types.str;
        default = "radarr";
        description = "Group under which Radarr runs.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.radarr = {
      description = "Radarr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        test -d ${cfg.dataDir} || {
          echo "Creating radarr data directory in ${cfg.dataDir}"
          mkdir -p ${cfg.dataDir}
        }
        chown -R ${cfg.user}:${cfg.group} ${cfg.dataDir}
        chmod 0700 ${cfg.dataDir}
      '';

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        PermissionsStartOnly = "true";
        ExecStart = "${pkgs.radarr}/bin/Radarr -nobrowser -data='${cfg.dataDir}'";
        Restart = "on-failure";
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 7878 ];
    };

    users.users = mkIf (cfg.user == "radarr") {
      radarr = {
        group = cfg.group;
        home = cfg.dataDir;
        uid = config.ids.uids.radarr;
      };
    };

    users.groups = mkIf (cfg.group == "radarr") {
      radarr.gid = config.ids.gids.radarr;
    };
  };
}
