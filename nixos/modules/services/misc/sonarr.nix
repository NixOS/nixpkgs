{ config, pkgs, lib, mono, ... }:

with lib;

let
  cfg = config.services.sonarr;
in
{
  options = {
    services.sonarr = {
      enable = mkEnableOption "Sonarr";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.sonarr = {
      description = "Sonarr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        test -d /var/lib/sonarr/ || {
          echo "Creating sonarr data directory in /var/lib/sonarr/"
          mkdir -p /var/lib/sonarr/
        }
        chown -R sonarr:sonarr /var/lib/sonarr/
        chmod 0700 /var/lib/sonarr/
      '';

      serviceConfig = {
        Type = "simple";
        User = "sonarr";
        Group = "sonarr";
        PermissionsStartOnly = "true";
        ExecStart = "${pkgs.sonarr}/bin/NzbDrone --no-browser";
        Restart = "on-failure";
      };
    };

    users.extraUsers.sonarr = {
      uid = config.ids.uids.sonarr;
      home = "/var/lib/sonarr";
      group = "sonarr";
    };
    users.extraGroups.sonarr.gid = config.ids.gids.sonarr;

  };
}
