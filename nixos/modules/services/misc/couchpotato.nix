{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.couchpotato;

in
{
  options = {
    services.couchpotato = {
      enable = mkEnableOption "CouchPotato Server";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.couchpotato = {
      description = "CouchPotato Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        mkdir -p /var/lib/couchpotato
        chown -R couchpotato:couchpotato /var/lib/couchpotato
      '';

      serviceConfig = {
        Type = "simple";
        User = "couchpotato";
        Group = "couchpotato";
        PermissionsStartOnly = "true";
        ExecStart = "${pkgs.couchpotato}/bin/couchpotato";
        Restart = "on-failure";
      };
    };

    users.users = singleton
      { name = "couchpotato";
        group = "couchpotato";
        home = "/var/lib/couchpotato/";
        description = "CouchPotato daemon user";
        uid = config.ids.uids.couchpotato;
      };

    users.groups = singleton
      { name = "couchpotato";
        gid = config.ids.gids.couchpotato;
      };
  };
}
