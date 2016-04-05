{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.flyingcircus.services.sensu-server;

  sensu_clients = filter
    (x: x.service == "sensuserver-server")
    config.flyingcircus.enc_service_clients;

  server_password = (lib.findSingle
    (x: x.node == "${config.networking.hostName}.gocept.net")
    { password = ""; } { password = ""; } sensu_clients).password;

  directory_handler = "${pkgs.fcmanage}/bin/fc-monitor --enc ${config.flyingcircus.enc_path} handle-result";

  sensu_server_json = pkgs.writeText "sensu-server.json"
    ''
    {
      "mailer": {
        "mail_from": "admin@flyingcircus.io",
        "mail_to": "admin@flyingcircus.io",
        "smtp_address": "mail.gocept.net",
        "smtp_port": "25",
        "smtp_domain": "flyingcircus.io"
      },
      "rabbitmq": {
        "host": "${config.networking.hostName}.gocept.net",
        "user": "sensu-server",
        "password": "${server_password}",
        "vhost": "/sensu"
      },
      "handlers": {
        "mailer": {
          "type": "pipe",
          "command": "${pkgs.sensu}/bin/handler-mailer.rb"
        },
        "directory": {
          "type": "pipe",
          "command": "/var/setuid-wrappers/sudo ${directory_handler}"
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
    services.rabbitmq.listenAddress = "::";
    services.rabbitmq.plugins = [ "rabbitmq_management" ];
    services.redis.enable = true;
    services.postfix.enable = true;

    ##############
    # Sensu Server

    networking.firewall.extraCommands = ''
      ip46tables -A nixos-fw -i ethsrv -p tcp --dport 5672 -j nixos-fw-accept
    '';

    users.extraGroups.sensuserver.gid = config.ids.gids.sensuserver;

    users.extraUsers.sensuserver = {
      description = "sensu server daemon user";
      uid = config.ids.uids.sensuserver;
      group = "sensuserver";
    };

    security.sudo.extraConfig = ''
      Cmnd_Alias  SENSU_DIRECTORY_HANDLER = ${directory_handler}

      sensuserver ALL=(root) SENSU_DIRECTORY_HANDLER

    '';

    systemd.services.prepare-rabbitmq-for-sensu = {
      description = "Prepare rabbitmq for sensu-server.";
      requires = [ "rabbitmq.service" ];
      path = [ pkgs.rabbitmq_server ];
      serviceConfig = {
        Type = "oneshot";
        User = "rabbitmq";
      };
      script = let
        clients = (lib.concatMapStrings (
          client:
            let client_name = builtins.head (lib.splitString "." client.node);
            in ''
              rabbitmqctl add_user ${client.node} ${client.password} || true
              rabbitmqctl change_password ${client.node} ${client.password}
              # Permission for clients in order: conf, write, read
              # exchange.declare -> configure "keepalives"
              # queue.declare -> configure "node-*"
              # queue.bind -> write "node-*"
              rabbitmqctl set_permissions -p /sensu ${client.node} \
                "^((default|results|keepalives)$)|${client_name}-.*" \
                "^((keepalives|results)$)|${client_name}-.*" \
                "^(default$)|${client_name}-.*"
              '')
          sensu_clients);
      in
       ''
        set -ex

        rabbitmqctl start_app || sleep 5
        rabbitmqctl delete_user guest || true
        rabbitmqctl add_vhost /sensu || true

        rabbitmqctl add_user sensu-server ${server_password} || true
        rabbitmqctl change_password sensu-server ${server_password}
        rabbitmqctl set_permissions -p /sensu sensu-server ".*" ".*" ".*"

        ${clients}

      '';
    };

    systemd.services.sensu-server = {
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.sensu pkgs.openssl pkgs.bash pkgs.mailutils ];
      requires = [
        "rabbitmq.service"
        "redis.service"
        "prepare-rabbitmq-for-sensu.service" ];
      serviceConfig = {
        User = "sensuserver";
        ExecStart = "${pkgs.sensu}/bin/sensu-server -c ${sensu_server_json}";
        Restart = "always";
        RestartSec = "5s";
      };
      environment = { EMBEDDED_RUBY = "false"; };

      # rabbitmq needs some time to start up. The wait for pid
      # in the default service config doesn't really seem to help :(
      preStart = ''
          sleep 5
      '';
    };

  };

}
