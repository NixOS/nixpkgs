{ config, lib, pkgs, ... }:

with lib;

let

  uchiwa = pkgs.uchiwa;

  cfg = config.flyingcircus.services.uchiwa;

  uchiwa_json = pkgs.writeText "uchiwa.json" ''
    {
      "sensu": [
        {
          "name": "Local Site",
          "host": "localhost",
          "port": 4567
        }
      ],
      "uchiwa": {
        "host": "0.0.0.0",
        "port": 3000
      }
    }
  '';

in {

  options = {

    flyingcircus.services.uchiwa = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable the Uchiwa sensu dashboard daemon.
        '';
      };
      config = mkOption {
        type = types.lines;
        description = ''
          Contents of the uchiwa configuration file.
        '';
      };
      extraOpts = mkOption {
        type = with types; listOf str;
        default = [];
        description = ''
          Extra options used when launching uchiwa.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    ids.gids.uchiwa = 209;
    ids.uids.uchiwa = 209;

    users.extraGroups.uchiwa.gid = config.ids.gids.uchiwa;

    users.extraUsers.uchiwa = {
      description = "uchiwa daemon user";
      uid = config.ids.uids.uchiwa;
      group = "uchiwa";
    };

    systemd.services.uchiwa = {
      wantedBy = [ "multi-user.target" ];
      path = [ uchiwa ];
      serviceConfig = {
        User = "uchiwa";
        ExecStart = "${uchiwa}/bin/uchiwa -c ${uchiwa_json} -p ${uchiwa}/public";
      };
    };

  };

}
