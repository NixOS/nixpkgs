{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.duplicati;
in
{
  options = {
    services.duplicati = {
      enable = mkEnableOption (lib.mdDoc "Duplicati");

      port = mkOption {
        default = 8200;
        type = types.int;
        description = lib.mdDoc ''
          Port serving the web interface
        '';
      };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/duplicati";
        description = ''
          The directory where Duplicati stores its data files.

          <note><para>
            If left as the default value this directory will automatically be created
            before the Duplicati server starts, otherwise you are responsible for ensuring
            the directory exists with appropriate ownership and permissions.
          </para></note>
        '';
      };

      interface = mkOption {
        default = "127.0.0.1";
        type = types.str;
        description = lib.mdDoc ''
          Listening interface for the web UI
          Set it to "any" to listen on all available interfaces
        '';
      };

      user = mkOption {
        default = "duplicati";
        type = types.str;
        description = lib.mdDoc ''
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
      serviceConfig = mkMerge [
        {
          User = cfg.user;
          Group = "duplicati";
          ExecStart = "${pkgs.duplicati}/bin/duplicati-server --webservice-interface=${cfg.interface} --webservice-port=${toString cfg.port} --server-datafolder=${cfg.dataDir}";
          Restart = "on-failure";
        }
        (mkIf (cfg.dataDir == "/var/lib/duplicati") {
          StateDirectory = "duplicati";
        })
      ];
    };

    users.users = lib.optionalAttrs (cfg.user == "duplicati") {
      duplicati = {
        uid = config.ids.uids.duplicati;
        home = cfg.dataDir;
        group = "duplicati";
      };
    };
    users.groups.duplicati.gid = config.ids.gids.duplicati;

  };
}

