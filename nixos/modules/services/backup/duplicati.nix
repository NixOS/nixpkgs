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
        default = "127.0.0.1";
        type = types.str;
        description = ''
          Listening interface for the web UI
          Set it to "any" to listen on all available interfaces
        '';
      };

      user = mkOption {
        default = "duplicati";
        type = types.str;
        description = ''
          Duplicati runs as it's own user. It will only be able to backup world-readable files.
          Run as root with special care.
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
        User = cfg.user;
        Group = "duplicati";
        StateDirectory = "duplicati";
        ExecStart = "${pkgs.duplicati}/bin/duplicati-server --webservice-interface=${cfg.interface} --webservice-port=${toString cfg.port} --server-datafolder=/var/lib/duplicati";
        Restart = "on-failure";
      };
    };

    users.users.duplicati = lib.optionalAttrs (cfg.user == "duplicati") {
      uid = config.ids.uids.duplicati;
      home = "/var/lib/duplicati";
      createHome = true;
      group = "duplicati";
    };
    users.groups.duplicati.gid = config.ids.gids.duplicati;

  };
}

