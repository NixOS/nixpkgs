{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.prowlarr;

in
{
  options = {
    services.prowlarr = {
      enable = mkEnableOption "Prowlarr";

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/prowlarr";
        description = "The directory where Prowlarr stores its data files.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = "Open ports in the firewall for the Prowlarr web interface.";
      };

      user = mkOption {
        type = types.str;
        default = "prowlarr";
        description = "User account under which Prowlarr runs.";
      };

      group = mkOption {
        type = types.str;
        default = "prowlarr";
        description = "Group under which Prowlarr runs.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0700 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.prowlarr = {
      description = "Prowlarr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${pkgs.prowlarr}/bin/Prowlarr -nobrowser -data=${cfg.dataDir}";
        Restart = "on-failure";
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 9696 ];
    };

    users.users = mkIf (cfg.user == "prowlarr") {
      prowlarr = {
        group = cfg.group;
        home = "/var/lib/prowlarr";
        uid = config.ids.uids.prowlarr;
      };
    };

    users.groups = mkIf (cfg.group == "prowlarr") {
      prowlarr = {
        gid = config.ids.gids.prowlarr;
      };
    };
  };
}
