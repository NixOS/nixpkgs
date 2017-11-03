{ config, pkgs, lib, mono, ... }:

with lib;

let
  cfg = config.services.radarr;
in
{
  options = {
    services.radarr = {
      enable = mkEnableOption "Radarr";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.radarr = {
      description = "Radarr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        test -d /var/lib/radarr/ || {
          echo "Creating radarr data directory in /var/lib/radarr/"
          mkdir -p /var/lib/radarr/
        }
        chown -R radarr:radarr /var/lib/radarr/
        chmod 0700 /var/lib/radarr/
      '';

      serviceConfig = {
        Type = "simple";
        User = "radarr";
        Group = "radarr";
        PermissionsStartOnly = "true";
        ExecStart = "${pkgs.radarr}/bin/Radarr";
        Restart = "on-failure";
      };
    };

    users.extraUsers.radarr = {
      uid = config.ids.uids.radarr;
      home = "/var/lib/radarr";
      group = "radarr";
    };
    users.extraGroups.radarr.gid = config.ids.gids.radarr;

  };
}
