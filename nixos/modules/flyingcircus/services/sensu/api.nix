{ config, pkgs, lib, ... }:

with lib;

let

  sensu = pkgs.sensu;

  cfg = config.flyingcircus.services.sensu-api;


  sensu_api_cfg = pkgs.writeText "sensu-api.json" ''
   {
      "rabbitmq": {
        "host": "${config.networking.hostName}.gocept.net",
        "user": "sensu-server",
        "password": "asdf1",
        "vhost": "/sensu"
      }
    }
  '';

in  {

  options = {

    flyingcircus.services.sensu-api = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable the Sensu monitoring API daemon.
        '';
      };
      config = mkOption {
        type = types.lines;
        description = ''
          Contents of the sensu API configuration file.
        '';
      };
      extraOpts = mkOption {
        type = with types; listOf str;
        default = [];
        description = ''
          Extra options used when launching sensu API.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    users.extraGroups.sensuapi.gid = config.ids.gids.sensuapi;

    users.extraUsers.sensuapi = {
      description = "sensu api daemon user";
      uid = config.ids.uids.sensuapi;
      group = "sensuapi";
    };

    services.rabbitmq.enable = true;
    services.redis.enable = true;

    systemd.services.sensu-api = {
      wantedBy = [ "multi-user.target" ];
      path = [ sensu ];
      serviceConfig = {
        User = "sensuapi";
        ExecStart = "${sensu}/bin/sensu-api -c ${sensu_api_cfg}";
        Restart = "always";
        RestartSec = "5s";
      };
    };

  };

}
