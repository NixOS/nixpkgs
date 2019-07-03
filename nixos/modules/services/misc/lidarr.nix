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
        ExecStart = "${cfg.package}/bin/Lidarr";
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
