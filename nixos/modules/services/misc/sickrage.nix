{config, pkgs, lib, ...}:

with lib;

let cfg = config.services.sickrage;
in {
  options.services.sickrage = {
    enable = mkOption {
      description = "Activate Sickrage server";
      type = types.bool;
      visible = true;
      default = false;
    };
    port = mkOption {
      description = "Sickrage's listening port";
      type = types.int;
      visible = true;
      default = 8001;
    };
  };


  config = mkIf cfg.enable {
    systemd.services.sickrage = {
      enable = true;
      after = ["network.target"];
      description = "Sickrage server";
      serviceConfig = {
        Type = "forking";
        User = "sickrage";
        Group = "nogroup";
        RuntimeDirectory = "sickrage";
        StateDirectory = "sickrage";     
        PIDFile = "/run/sickrage/sickrage.pid";
        ExecStart = "/nix/store/niz2pzmfs0f0wkg64lbdrn2h8q7gzkyj-sickrage-v2018.07.18-2/SickBeard.py --daemon --datadir=/var/lib/sickrage --pidfile=/run/sickrage/sickrage.pid --port=${toString cfg.port}";
      };
      wantedBy = ["multi-user.target"];
    };
    users = {
      users = {
        sickrage = {
         isSystemUser = true;
         name = "sickrage";
        };
      };
    };
  };
}
