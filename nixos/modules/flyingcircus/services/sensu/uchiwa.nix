{ config, lib, pkgs, ... }:

with lib;

let

  uchiwa = pkgs.uchiwa;

  cfg = config.flyingcircus.services.uchiwa;

  sensu_name =
    if lib.hasAttrByPath ["parameters" "location"] config.flyingcircus.enc
    then config.flyingcircus.enc.parameters.location
    else "local";

  api_servers = filter
    (x: x.service == "sensuserver-api")
    config.flyingcircus.enc_services;

  uchiwa_json = let
    api_servers_config = (lib.concatMapStringsSep ",\n" (
      api_server:
        ''
          {
            "name": "${api_server.location}",
            "host": "sensu.${api_server.location}.gocept.net",
            "port": 443,
            "ssl": true,
            "insecure": true,
            "path": "/api",
            "timeout": 5,
            "user": "${config.networking.hostName}.gocept.net"  ,
            "pass": "${api_server.password}"
           }'')
      api_servers);
    in pkgs.writeText "uchiwa.json" ''
    {
      "sensu": [
        ${api_servers_config}
      ],
      "uchiwa": {
        "host": "0.0.0.0",
        "port": 3000,
        "loglevel": "warn",
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
