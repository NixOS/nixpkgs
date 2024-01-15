{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.radarr;

in
{
  options = {
    services.radarr = {
      enable = mkEnableOption (lib.mdDoc "Radarr");

      package = mkPackageOption pkgs "radarr" { };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/radarr/.config/Radarr";
        description = lib.mdDoc "The directory where Radarr stores its data files.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Open ports in the firewall for the Radarr web interface.";
      };

      user = mkOption {
        type = types.str;
        default = "radarr";
        description = lib.mdDoc "User account under which Radarr runs.";
      };

      group = mkOption {
        type = types.str;
        default = "radarr";
        description = lib.mdDoc "Group under which Radarr runs.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0700 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.radarr = {
      description = "Radarr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/Radarr -nobrowser -data='${cfg.dataDir}'";
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
