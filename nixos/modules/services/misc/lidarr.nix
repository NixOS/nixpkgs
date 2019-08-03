{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.lidarr;
in
{
  options = {
    services.lidarr = {
      enable = mkEnableOption "Lidarr";

      package = mkOption {
        type = types.package;
        default = pkgs.lidarr;
        defaultText = "pkgs.lidarr";
        description = "The Lidarr package to use";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Open ports in the firewall for Lidarr
        '';
      };

      user = mkOption {
        type = types.str;
        default = "lidarr";
        description = ''
          User account under which Lidarr runs.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "lidarr";
        description = ''
          Group under which Lidarr runs.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.lidarr = {
      description = "Lidarr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/Lidarr";
        Restart = "on-failure";

        StateDirectory = "lidarr";
        StateDirectoryMode = "0770";
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 8686 ];
    };

    users.users = mkIf (cfg.user == "lidarr") {
      lidarr = {
        group = cfg.group;
        home = "/var/lib/lidarr";
        uid = config.ids.uids.lidarr;
      };
    };

    users.groups = mkIf (cfg.group == "lidarr") {
      lidarr = {
        gid = config.ids.gids.lidarr;
      };
    };
  };
}
