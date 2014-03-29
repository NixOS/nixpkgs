{ config, pkgs, ... }:

with pkgs.lib;

let
  cfg = config.services.rabbitmq;

in {
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


      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/rabbitmq";
        description = ''
          Data directory for rabbitmq.
        '';
      };

    };
  };


  ###### implementation
  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.rabbitmq_server ];

    users.extraUsers.rabbitmq = {
      description = "RabbitMQ server user";
      home = "${cfg.dataDir}";
      group = "rabbitmq";
      uid = config.ids.uids.rabbitmq;
    };

    users.extraGroups.rabbitmq.gid = config.ids.gids.rabbitmq;

    systemd.services.rabbitmq = {
      description = "RabbitMQ Server";

      wantedBy = [ "multi-user.target" ];
      after = [ "network-interfaces.target" ];

      environment = {
        RABBITMQ_MNESIA_BASE = "${cfg.dataDir}/mnesia";
        RABBITMQ_NODE_IP_ADDRESS = cfg.listenAddress;
        RABBITMQ_SERVER_START_ARGS = "-rabbit error_logger tty -rabbit sasl_error_logger false";
        SYS_PREFIX = "";
      };

      serviceConfig = {
        ExecStart = "${pkgs.rabbitmq_server}/sbin/rabbitmq-server";
        User = "rabbitmq";
        Group = "rabbitmq";
        PermissionsStartOnly = true;
      };

      preStart = ''
        mkdir -p ${cfg.dataDir} && chmod 0700 ${cfg.dataDir}
        if [ "$(id -u)" = 0 ]; then chown rabbitmq:rabbitmq ${cfg.dataDir}; fi
      '';
    };

  };

}
