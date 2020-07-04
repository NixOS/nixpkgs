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

      serviceConfig = {
        Type = "simple";
        User = "couchpotato";
        Group = "couchpotato";
        StateDirectory = "couchpotato";
        ExecStart = "${pkgs.couchpotato}/bin/couchpotato";
        Restart = "on-failure";
      };
    };

    users.users.couchpotato =
      { group = "couchpotato";
        home = "/var/lib/couchpotato/";
        description = "CouchPotato daemon user";
        uid = config.ids.uids.couchpotato;
      };

    users.groups.couchpotato =
      { gid = config.ids.gids.couchpotato; };
  };
}
