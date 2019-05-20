{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.lidarr;
in
{
  options = {
    services.lidarr = {
      enable = mkEnableOption "Lidarr";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.lidarr = {
      description = "Lidarr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = "lidarr";
        Group = "lidarr";
        ExecStart = "${pkgs.lidarr}/bin/Lidarr";
        Restart = "on-failure";

        StateDirectory = "lidarr";
        StateDirectoryMode = "0770";
      };
    };

    users.users.lidarr = {
      uid = config.ids.uids.lidarr;
      home = "/var/lib/lidarr";
      group = "lidarr";
    };

    users.groups.lidarr.gid = config.ids.gids.lidarr;
  };
}
