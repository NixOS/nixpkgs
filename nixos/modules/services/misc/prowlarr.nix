{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.prowlarr;

in
{
  options = {
    services.prowlarr = {
      enable = mkEnableOption (lib.mdDoc "Prowlarr");

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
        description = lib.mdDoc "Open ports in the firewall for the Prowlarr web interface.";
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
        ExecStart = "${pkgs.prowlarr}/bin/Prowlarr -nobrowser -data=/var/lib/prowlarr";
        Restart = "on-failure";
      };
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
