{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.rabbitmq;

  inherit (builtins) concatStringsSep;

  config_file_content = lib.generators.toKeyValue { } cfg.configItems;
  config_file = pkgs.writeText "rabbitmq.conf" config_file_content;

  advanced_config_file = pkgs.writeText "advanced.config" cfg.config;

in
{
  ###### interface
  options = {
    services.rabbitmq = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable the RabbitMQ server, an Advanced Message
          Queuing Protocol (AMQP) broker.
        '';
      };

      package = mkOption {
        default = pkgs.rabbitmq-server;
        type = types.package;
        defaultText = literalExpression "pkgs.rabbitmq-server";
        description = lib.mdDoc ''
          Which rabbitmq package to use.
        '';
      };

      listenAddress = mkOption {
        default = "127.0.0.1";
        example = "";
        description = lib.mdDoc ''
          IP address on which RabbitMQ will listen for AMQP
          connections.  Set to the empty string to listen on all
          interfaces.  Note that RabbitMQ creates a user named
          `guest` with password
          `guest` by default, so you should delete
          this user if you intend to allow external access.

          Together with 'port' setting it's mostly an alias for
          configItems."listeners.tcp.1" and it's left for backwards
          compatibility with previous version of this module.
        '';
        type = types.str;
      };

      port = mkOption {
        default = 5672;
        description = lib.mdDoc ''
          Port on which RabbitMQ will listen for AMQP connections.
        '';
        type = types.port;
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/rabbitmq";
        description = lib.mdDoc ''
          Data directory for rabbitmq.
        '';
      };

      cookie = mkOption {
        default = "";
        type = types.str;
        description = lib.mdDoc ''
          Erlang cookie is a string of arbitrary length which must
          be the same for several nodes to be allowed to communicate.
          Leave empty to generate automatically.
        '';
      };

      configItems = mkOption {
        default = { };
        type = types.attrsOf types.str;
        example = literalExpression ''
          {
            "auth_backends.1.authn" = "rabbit_auth_backend_ldap";
            "auth_backends.1.authz" = "rabbit_auth_backend_internal";
          }
        '';
        description = lib.mdDoc ''
          Configuration options in RabbitMQ's new config file format,
          which is a simple key-value format that can not express nested
          data structures. This is known as the `rabbitmq.conf` file,
          although outside NixOS that filename may have Erlang syntax, particularly
          prior to RabbitMQ 3.7.0.

          If you do need to express nested data structures, you can use
          `config` option. Configuration from `config`
          will be merged into these options by RabbitMQ at runtime to
          form the final configuration.

          See https://www.rabbitmq.com/configure.html#config-items
          For the distinct formats, see https://www.rabbitmq.com/configure.html#config-file-formats
        '';
      };

      config = mkOption {
        default = "";
        type = types.str;
        description = lib.mdDoc ''
          Verbatim advanced configuration file contents using the Erlang syntax.
          This is also known as the `advanced.config` file or the old config format.

          `configItems` is preferred whenever possible. However, nested
          data structures can only be expressed properly using the `config` option.

          The contents of this option will be merged into the `configItems`
          by RabbitMQ at runtime to form the final configuration.

          See the second table on https://www.rabbitmq.com/configure.html#config-items
          For the distinct formats, see https://www.rabbitmq.com/configure.html#config-file-formats
        '';
      };

      plugins = mkOption {
        default = [ ];
        type = types.listOf types.str;
        description = lib.mdDoc "The names of plugins to enable";
      };

      pluginDirs = mkOption {
        default = [ ];
        type = types.listOf types.path;
        description = lib.mdDoc "The list of directories containing external plugins";
      };

      managementPlugin = {
        enable = mkEnableOption "the management plugin";
        port = mkOption {
          default = 15672;
          type = types.port;
          description = lib.mdDoc ''
            On which port to run the management plugin
          '';
        };
      };
    };
  };


  ###### implementation
  config = mkIf cfg.enable {

    # This is needed so we will have 'rabbitmqctl' in our PATH
    environment.systemPackages = [ cfg.package ];

    services.epmd.enable = true;

    users.users.rabbitmq = {
      description = "RabbitMQ server user";
      home = "${cfg.dataDir}";
      createHome = true;
      group = "rabbitmq";
      uid = config.ids.uids.rabbitmq;
    };

    users.groups.rabbitmq.gid = config.ids.gids.rabbitmq;

    services.rabbitmq.configItems = {
      "listeners.tcp.1" = mkDefault "${cfg.listenAddress}:${toString cfg.port}";
    } // optionalAttrs cfg.managementPlugin.enable {
      "management.tcp.port" = toString cfg.managementPlugin.port;
      "management.tcp.ip" = cfg.listenAddress;
    };

    services.rabbitmq.plugins = optional cfg.managementPlugin.enable "rabbitmq_management";

    systemd.services.rabbitmq = {
      description = "RabbitMQ Server";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "epmd.socket" ];
      wants = [ "network.target" "epmd.socket" ];

      path = [
        cfg.package
        pkgs.coreutils # mkdir/chown/chmod for preStart
      ];

      environment = {
        RABBITMQ_MNESIA_BASE = "${cfg.dataDir}/mnesia";
        RABBITMQ_LOGS = "-";
        SYS_PREFIX = "";
        RABBITMQ_CONFIG_FILE = config_file;
        RABBITMQ_PLUGINS_DIR = concatStringsSep ":" cfg.pluginDirs;
        RABBITMQ_ENABLED_PLUGINS_FILE = pkgs.writeText "enabled_plugins" ''
          [ ${concatStringsSep "," cfg.plugins} ].
        '';
      } // optionalAttrs (cfg.config != "") { RABBITMQ_ADVANCED_CONFIG_FILE = advanced_config_file; };

      serviceConfig = {
        ExecStart = "${cfg.package}/sbin/rabbitmq-server";
        ExecStop = "${cfg.package}/sbin/rabbitmqctl shutdown";
        User = "rabbitmq";
        Group = "rabbitmq";
        LogsDirectory = "rabbitmq";
        WorkingDirectory = cfg.dataDir;
        Type = "notify";
        NotifyAccess = "all";
        UMask = "0027";
        LimitNOFILE = "100000";
        Restart = "on-failure";
        RestartSec = "10";
        TimeoutStartSec = "3600";
      };

      preStart = ''
        ${optionalString (cfg.cookie != "") ''
            echo -n ${cfg.cookie} > ${cfg.dataDir}/.erlang.cookie
            chmod 600 ${cfg.dataDir}/.erlang.cookie
        ''}
      '';
    };

  };

}
