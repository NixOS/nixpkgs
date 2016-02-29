{ config, pkgs, lib, ... }:

with lib;

let

  sensu = pkgs.sensu;

  cfg = config.flyingcircus.services.sensu-api;

  # Duplicated from server.nix.
  enc_clients = if builtins.hasAttr "sensuserver" config.flyingcircus.enc_service_clients
    then config.flyingcircus.enc_service_clients.sensuserver
    else [];

  server_password = (lib.findSingle
    (x: x.node == "${config.networking.hostName}.gocept.net")
    "" "" enc_clients).password;

  sensu_api_json = pkgs.writeText "sensu-server.json"
    ''
    {
      "rabbitmq": {
        "host": "${config.networking.hostName}.gocept.net",
        "user": "sensu-server",
        "password": "${server_password}",
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
      requires = [
        "rabbitmq.service"
        "redis.service"];
      path = [ sensu ];
      serviceConfig = {
        User = "sensuapi";
        ExecStart = "${sensu}/bin/sensu-api -v -c ${sensu_api_json}";
        Restart = "always";
        RestartSec = "5s";
      };
    };

  };

}
