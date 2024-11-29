{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.prowlarr;

in
{
  options = {
    services.prowlarr = {
      enable = mkEnableOption "Prowlarr, an indexer manager/proxy for Torrent trackers and Usenet indexers";

      package = mkPackageOption pkgs "prowlarr" { };

      user = mkOption {
        type = types.str;
        default = "prowlarr";
        description = lib.mdDoc "User account under which Prowlarr runs.";
      };

      group = mkOption {
        type = types.str;
        default = "prowlarr";
        description = lib.mdDoc "Group under which Prowlarr runs.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = "Open ports in the firewall for the Prowlarr web interface.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.prowlarr = {
      description = "Prowlarr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = "prowlarr";
        ExecStart = "${lib.getExe cfg.package} -nobrowser -data=/var/lib/prowlarr";
        Restart = "on-failure";
      };
      environment.HOME = "/var/empty";
    };

    users.users = mkIf (cfg.user == "prowlarr") {
      prowlarr = { group = cfg.group; };
    };

    users.groups = mkIf (cfg.group == "prowlarr") {
      prowlarr = { };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 9696 ];
    };
  };
}
