{ config, pkgs, lib, ... }:

with pkgs;
with lib;

let

  sensu = pkgs.callPackage ../pkgs/sensu { };
  sensu_plugins = pkgs.callPackage ../pkgs/sensu-plugins { };

  cfg = config.flyingcircus.services.sensu-client;

  client_json = writeText "client.json" ''
    {
      "client": {
        "name": "${config.networking.hostName}",
        "address": "localhost",
        "subscriptions": ["default"]
      },
     "checks": {
        "load": {
            "notification": "Load is too high",
            "command": "check_load -r -w 0.8,0.8,0.8 -c 2,2,2",
            "interval": 10,
            "standalone": true
        },
        "swap": {
            "notification": "Swap is running low",
            "command": "check_swap -w 20% -c 10%",
            "interval": 300,
            "standalone": true
        },
        "ssh": {
            "notification": "SSH server is not responding properly",
            "command": "check_ssh localhost",
            "interval": 300,
            "standalone": true
        },
        "ntp_time": {
            "notification": "Clock is skewed",
            "command": "check_ntp_time -H 0.de.pool.ntp.org",
            "interval": 300,
            "standalone": true
        },
        "internet_uplink_ipv4": {
            "notification": "Internet (Google) is not available",
            "command": "check_ping  -w 100,5% -c 200,10% -H google.com  -4",
            "interval": 60,
            "standalone": true
        },
        "internet_uplink_ipv6": {
            "notification": "Internet (Google) is not available",
            "command": "check_ping  -w 100,5% -c 200,10% -H google.com  -6",
            "interval": 60,
            "standalone": true
        },
        "uptime": {
            "notification": "Host was down",
            "command": "check_uptime",
            "interval": 60,
            "standalone": true
        },
        "users": {
            "notification": "Many users logged in",
            "command": "check_users -w 5 -c 10",
            "interval": 60,
            "standalone": true
        }
      }
    }
  '';


in {

  options = {

    flyingcircus.services.sensu-client = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable the Sensu monitoring client daemon.
        '';
      };
      config = mkOption {
        type = types.lines;
        description = ''
          Contents of the sensu client configuration file.
        '';
      };
      extraOpts = mkOption {
        type = with types; listOf str;
        default = [];
        description = ''
          Extra options used when launching sensu.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    ids.gids.sensuclient = 207;
    ids.uids.sensuclient = 207;

    users.extraGroups.sensuclient.gid = config.ids.gids.sensuclient;

    users.extraUsers.sensuclient = {
      description = "sensu client daemon user";
      uid = config.ids.uids.sensuclient;
      group = "sensuclient";
    };

    systemd.services.sensu-client = {
      wantedBy = [ "multi-user.target" ];
      path = [ sensu sensu_plugins pkgs.nagiosPluginsOfficial pkgs.bash pkgs.lm_sensors ];
      serviceConfig = {
        User = "sensuclient";
        ExecStart = "${sensu}/bin/sensu-client -c ${client_json} -v";
        Restart = "always";
        RestartSec = "5s";
      };
        environment = { EMBEDDED_RUBY = "false"; };
    };

  };

}
