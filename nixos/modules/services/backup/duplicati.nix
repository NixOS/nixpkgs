{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.duplicati;
in
{
  options = {
    services.duplicati = {
      enable = lib.mkEnableOption "Duplicati";

      package = lib.mkPackageOption pkgs "duplicati" { };

      port = lib.mkOption {
        default = 8200;
        type = lib.types.port;
        description = ''
          Port serving the web interface
        '';
      };

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/duplicati";
        description = ''
          The directory where Duplicati stores its data files.

          ::: {.note}
          If left as the default value this directory will automatically be created
          before the Duplicati server starts, otherwise you are responsible for ensuring
          the directory exists with appropriate ownership and permissions.
          :::
        '';
      };

      interface = lib.mkOption {
        default = "127.0.0.1";
        type = lib.types.str;
        description = ''
          Listening interface for the web UI
          Set it to "any" to listen on all available interfaces
        '';
      };

      user = lib.mkOption {
        default = "duplicati";
        type = lib.types.str;
        description = ''
          Duplicati runs as it's own user. It will only be able to backup world-readable files.
          Run as root with special care.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services.duplicati = {
      description = "Duplicati backup";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = lib.mkMerge [
        {
          User = cfg.user;
          Group = "duplicati";
          ExecStart = "${cfg.package}/bin/duplicati-server --webservice-interface=${cfg.interface} --webservice-port=${toString cfg.port} --server-datafolder=${cfg.dataDir}";
          Restart = "on-failure";
        }
        (lib.mkIf (cfg.dataDir == "/var/lib/duplicati") {
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
