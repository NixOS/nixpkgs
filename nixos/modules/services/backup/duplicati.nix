{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.duplicati;
in
{
  options = {
    services.duplicati = {
      enable = mkEnableOption "Duplicati";

      port = mkOption {
        default = 8200;
        type = types.int;
        description = ''
          Port serving the web interface
        '';
      };

      interface = mkOption {
        default = "lo";
        type = types.str;
        description = ''
          Listening interface for the web UI
          Set it to "any" to listen on all available interfaces
        '';
      };
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
        ExecStart = "${pkgs.duplicati}/bin/duplicati-server --webservice-interface=${cfg.interface} --webservice-port=${toString cfg.port} --server-datafolder=/var/lib/duplicati";
        Restart = "on-failure";
      };
    };

    users.users.duplicati = {
      uid = config.ids.uids.duplicati;
      home = "/var/lib/duplicati";
      createHome = true;
      group = "duplicati";
    };
    users.groups.duplicati.gid = config.ids.gids.duplicati;

  };
}

