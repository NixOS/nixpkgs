{ config, lib, pkgs, ... }:

with lib;

let

  uchiwa = pkgs.uchiwa;

  cfg = config.flyingcircus.services.uchiwa;

  uchiwa_json = pkgs.writeText "uchiwa.json" ''
    {
      "sensu": [
        {
          "name": "${config.flyingcircus.enc.parameters.location}",
          "host": "localhost",
          "port": 4567
        }
      ],
      "uchiwa": {
        "host": "0.0.0.0",
        "port": 3000,
        "users": ${config.flyingcircus.services.uchiwa.users}
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
      users = mkOption {
        type = types.lines;
        default = ''
        []
        '';
        description = ''
          User configuration to insert into the configuration file.
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
