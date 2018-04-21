{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.duplicati;
in
{
  options = {
    services.duplicati = {
      enable = mkEnableOption "Duplicati";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.duplicati ];

    systemd.services.duplicati = {
      description = "Duplicati backup";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "duplicati";
        Group = "duplicati";
        ExecStart = "${pkgs.duplicati}/bin/duplicati-server --webservice-interface=any --webservice-port=8200 --server-datafolder=/var/lib/duplicati";
        Restart = "on-failure";
      };
    };

    users.extraUsers.duplicati = {
      uid = config.ids.uids.duplicati;
      home = "/var/lib/duplicati";
      createHome = true;
      group = "duplicati";
    };
    users.extraGroups.duplicati.gid = config.ids.gids.duplicati;

  };
}

