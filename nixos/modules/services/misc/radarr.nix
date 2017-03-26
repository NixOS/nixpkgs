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
        chown -R radarr /var/lib/radarr/
        chmod 0700 /var/lib/radarr/
      '';

      serviceConfig = {
        Type = "simple";
        User = "radarr";
        Group = "nogroup";
        PermissionsStartOnly = "true";
        ExecStart = "${pkgs.radarr}/bin/Radarr";
        Restart = "on-failure";
      };
    };

    users.extraUsers.radarr = {
      home = "/var/lib/radarr";
    };

  };
}
