{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.jackett;

in
{
  options = {
    services.jackett = {
      enable = mkEnableOption "Jackett";

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/jackett/.config/Jackett";
        description = "The directory where Jackett stores its data files.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = "Open ports in the firewall for the Jackett web interface.";
      };

      user = mkOption {
        type = types.str;
        default = "jackett";
        description = "User account under which Jackett runs.";
      };

      group = mkOption {
        type = types.str;
        default = "jackett";
        description = "Group under which Jackett runs.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.jackett = {
      description = "Jackett";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        test -d ${cfg.dataDir} || {
          echo "Creating jackett data directory in ${cfg.dataDir}"
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
        ExecStart = "${pkgs.jackett}/bin/Jackett --NoUpdates --DataFolder '${cfg.dataDir}'";
        Restart = "on-failure";
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 9117 ];
    };

    users.users = mkIf (cfg.user == "jackett") {
      jackett = {
        group = cfg.group;
        home = cfg.dataDir;
        uid = config.ids.uids.jackett;
      };
    };

    users.groups = mkIf (cfg.group == "jackett") {
      jackett.gid = config.ids.gids.jackett;
    };
  };
}
