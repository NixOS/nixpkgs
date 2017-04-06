{ config, pkgs, lib, mono, ... }:

with lib;

let
  cfg = config.services.jackett;
in
{
  options = {
    services.jackett = {
      enable = mkEnableOption "Jackett";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.jackett = {
      description = "Jackett";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        test -d /var/lib/jackett/ || {
          echo "Creating jackett data directory in /var/lib/jackett/"
          mkdir -p /var/lib/jackett/
        }
        chown -R jackett /var/lib/jackett/
        chmod 0700 /var/lib/jackett/
      '';

      serviceConfig = {
        Type = "simple";
        User = "jackett";
        Group = "nogroup";
        PermissionsStartOnly = "true";
        ExecStart = "${pkgs.jackett}/bin/Jackett";
        Restart = "on-failure";
      };
    };

    users.extraUsers.jackett = {
      home = "/var/lib/jackett";
    };

  };
}
