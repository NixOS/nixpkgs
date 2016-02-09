{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.flyingcircus.services.sensu-server;

  urls = [
"www.google.com"
"flyingcircus.io"
"portal.staralliance.com"
"karl.soros.org"
];

  http_checks = lib.concatStringsSep ",\n" (map (x: ''
    "check_${x}": {
      "notification": "${x} HTTP failed",
      "command": "check_http ${x}",
      "subscribers": ["default"],
      "interval": 60,
      "handlers": [],
      "source": "${x}"
    }
'') urls);

  sensu_server_json = pkgs.writeText "sensu-server.json"
    ''
    {
      "checks": {
        ${http_checks}
    },

  "mailer": {
    "mail_from": "admin@flyingcircus.io",
    "mail_to": "admin@flyingcircus.io",
    "smtp_address": "mail.gocept.net",
    "smtp_port": "25",
    "smtp_domain": "flyingcircus.io"
  },

   "handlers": {
    "mailer": {
      "type": "pipe",
      "command": "${pkgs.sensu_plugins}/bin/handler-mailer.rb"
    },
    "default": {
      "handlers": [
        "mailer"
      ],
      "type": "set"
    }
  }

    ${cfg.config}

    }

    '';

in {

  options = {

    flyingcircus.services.sensu-server = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable the Sensu monitoring server daemon.
        '';
      };
      config = mkOption {
        type = types.lines;
        description = ''
          Contents of the sensu configuration file.
        '';
        default = "";
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

    # Dependencies

    services.rabbitmq.enable = true;
    services.redis.enable = true;
    services.postfix.enable = true;

    ##############
    # Sensu Server

    users.extraGroups.sensuserver.gid = config.ids.gids.sensuserver;

    users.extraUsers.sensuserver = {
      description = "sensu server daemon user";
      uid = config.ids.uids.sensuserver;
      group = "sensuserver";
    };

    systemd.services.sensu-server = {
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.sensu pkgs.sensu_plugins pkgs.openssl pkgs.bash pkgs.mailutils ];
      serviceConfig = {
        User = "sensuserver";
        ExecStart = "${pkgs.sensu}/bin/sensu-server -v -c ${sensu_server_json}";
        Restart = "always";
        RestartSec = "5s";
      };
        environment = { EMBEDDED_RUBY = "false"; };
    };

  };

}
