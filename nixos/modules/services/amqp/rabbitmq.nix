{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.rabbitmq;

  run = cmd: "${pkgs.sudo}/bin/sudo -E -u rabbitmq ${cmd}";

in

{


  ###### interface

  options = {

    services.rabbitmq = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to enable the RabbitMQ server, an Advanced Message
          Queuing Protocol (AMQP) broker.
        '';
      };

      listenAddress = mkOption {
        default = "127.0.0.1";
        example = "";
        description = ''
          IP address on which RabbitMQ will listen for AMQP
          connections.  Set to the empty string to listen on all
          interfaces.  Note that RabbitMQ creates a user named
          <literal>guest</literal> with password
          <literal>guest</literal> by default, so you should delete
          this user if you intend to allow external access.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.rabbitmq_server ];

    users.extraUsers.rabbitmq = {
      description = "RabbitMQ server user";
      home = "/var/empty";
      group = "rabbitmq";
      uid = config.ids.uids.rabbitmq;
    };

    users.extraGroups.rabbitmq.gid = config.ids.gids.rabbitmq;

    jobs.rabbitmq = {
        description = "RabbitMQ server";

        startOn = "started network-interfaces";

        preStart =
          ''
            mkdir -m 0700 -p /var/lib/rabbitmq
            chown rabbitmq /var/lib/rabbitmq

            mkdir -m 0700 -p /var/log/rabbitmq
            chown rabbitmq /var/log/rabbitmq
          '';

        environment.HOME = "/var/lib/rabbitmq";
        environment.RABBITMQ_NODE_IP_ADDRESS = cfg.listenAddress;
        environment.SYS_PREFIX = "";

        exec =
          ''
            ${run "${pkgs.rabbitmq_server}/sbin/rabbitmq-server"}
          '';

        preStop =
          ''
            ${run "${pkgs.rabbitmq_server}/sbin/rabbitmqctl stop"}
          '';
      };

  };

}
