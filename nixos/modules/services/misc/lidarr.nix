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
      preStart = ''
        [ ! -d /var/lib/lidarr ] && mkdir -p /var/lib/lidarr
        chown -R lidarr:lidarr /var/lib/lidarr
      '';

      serviceConfig = {
        Type = "simple";
        User = "lidarr";
        Group = "lidarr";
        PermissionsStartOnly = "true";
        ExecStart = "${pkgs.lidarr}/bin/Lidarr";
        Restart = "on-failure";

        StateDirectory = "/var/lib/lidarr/";
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
