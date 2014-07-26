{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.rabbitmq;
  config_file = pkgs.writeText "rabbitmq.config" cfg.config;
  config_file_wo_suffix = builtins.substring 0 ((builtins.stringLength config_file) - 7) config_file;

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

      cookie = mkOption {
        default = "";
        type = types.str;
        description = ''
          Erlang cookie is a string of arbitrary length which must
          be the same for several nodes to be allowed to communicate.
          Leave empty to generate automatically.
        '';
      };

      config = mkOption {
        default = "";
        type = types.str;
        description = ''
          Verbatim configuration file contents.
          See http://www.rabbitmq.com/configure.htm
        '';
      };

      plugins = mkOption {
        default = [];
        type = types.listOf types.str;
        description = "The names of plugins to enable";
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
        RABBITMQ_ENABLED_PLUGINS_FILE = pkgs.writeText "enabled_plugins" ''
          [ ${concatStringsSep "," cfg.plugins} ].
        '';
      } //  optionalAttrs (cfg.config != "") { RABBITMQ_CONFIG_FILE = config_file_wo_suffix; };

      serviceConfig = {
        ExecStart = "${pkgs.rabbitmq_server}/sbin/rabbitmq-server";
        User = "rabbitmq";
        Group = "rabbitmq";
        PermissionsStartOnly = true;
      };

      preStart = ''
        mkdir -p ${cfg.dataDir} && chmod 0700 ${cfg.dataDir}
        if [ "$(id -u)" = 0 ]; then chown rabbitmq:rabbitmq ${cfg.dataDir}; fi
        
        ${optionalString (cfg.cookie != "") ''
            echo -n ${cfg.cookie} > ${cfg.dataDir}/.erlang.cookie
            chmod 400 ${cfg.dataDir}/.erlang.cookie
            chown rabbitmq:rabbitmq ${cfg.dataDir}/.erlang.cookie
        ''}

        mkdir -p /var/log/rabbitmq && chmod 0700 /var/log/rabbitmq
        chown rabbitmq:rabbitmq /var/log/rabbitmq
      '';
    };

  };

}
