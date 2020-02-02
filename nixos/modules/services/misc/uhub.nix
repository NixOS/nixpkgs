{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.uhub;

  uhubPkg = pkgs.uhub.override { tlsSupport = cfg.enableTLS; };

  pluginConfig = ""
  + optionalString cfg.plugins.authSqlite.enable ''
    plugin ${uhubPkg.mod_auth_sqlite}/mod_auth_sqlite.so "file=${cfg.plugins.authSqlite.file}"
  ''
  + optionalString cfg.plugins.logging.enable ''
    plugin ${uhubPkg.mod_logging}/mod_logging.so ${if cfg.plugins.logging.syslog then "syslog=true" else "file=${cfg.plugins.logging.file}"}
  ''
  + optionalString cfg.plugins.welcome.enable ''
    plugin ${uhubPkg.mod_welcome}/mod_welcome.so "motd=${pkgs.writeText "motd.txt"  cfg.plugins.welcome.motd} rules=${pkgs.writeText "rules.txt" cfg.plugins.welcome.rules}"
  ''
  + optionalString cfg.plugins.history.enable ''
    plugin ${uhubPkg.mod_chat_history}/mod_chat_history.so "history_max=${toString cfg.plugins.history.max} history_default=${toString cfg.plugins.history.default} history_connect=${toString cfg.plugins.history.connect}"
  '';

  uhubConfigFile = pkgs.writeText "uhub.conf" ''
    file_acl=${pkgs.writeText "users.conf" cfg.aclConfig}
    file_plugins=${pkgs.writeText "plugins.conf" pluginConfig}
    server_bind_addr=${cfg.address}
    server_port=${toString cfg.port}
    ${lib.optionalString cfg.enableTLS "tls_enable=yes"}
    ${cfg.hubConfig}
  '';

in

{
  options = {

    services.uhub = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the uhub ADC hub.";
      };

      port = mkOption {
        type = types.int;
        default = 1511;
        description = "TCP port to bind the hub to.";
      };

      address = mkOption {
        type = types.str;
        default = "any";
        description = "Address to bind the hub to.";
      };

      enableTLS = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable TLS support.";
      };

      hubConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Contents of uhub configuration file.";
      };

      aclConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Contents of user ACL configuration file.";
      };

      plugins = {

        authSqlite = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = "Whether to enable the Sqlite authentication database plugin";
          };
          file = mkOption {
            type = types.path;
            example = "/var/db/uhub-users";
            description = "Path to user database. Use the uhub-passwd utility to create the database and add/remove users.";
          };
        };

        logging = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = "Whether to enable the logging plugin.";
          };
          file = mkOption {
            type = types.str;
            default = "";
            description = "Path of log file.";
          };
          syslog = mkOption {
            type = types.bool;
            default = false;
            description = "If true then the system log is used instead of writing to file.";
          };
        };

        welcome = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = "Whether to enable the welcome plugin.";
          };
          motd = mkOption {
            default = "";
            type = types.lines;
            description = ''
              Welcome message displayed to clients after connecting
              and with the <literal>!motd</literal> command.
            '';
          };
          rules = mkOption {
            default = "";
            type = types.lines;
            description = ''
              Rules message, displayed to clients with the <literal>!rules</literal> command.
            '';
          };
        };

        history = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = "Whether to enable the history plugin.";
          };
          max = mkOption {
            type = types.int;
            default = 200;
            description = "The maximum number of messages to keep in history";
          };
          default = mkOption {
            type = types.int;
            default = 10;
            description = "When !history is provided without arguments, then this default number of messages are returned.";
          };
          connect = mkOption {
            type = types.int;
            default = 5;
            description = "The number of chat history messages to send when users connect (0 = do not send any history).";
          };
        };

      };
    };

  };

  config = mkIf cfg.enable {

    users = {
      users.uhub.uid = config.ids.uids.uhub;
      groups.uhub.gid = config.ids.gids.uhub;
    };

    systemd.services.uhub = {
      description = "high performance peer-to-peer hub for the ADC network";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "notify";
        ExecStart  = "${uhubPkg}/bin/uhub -c ${uhubConfigFile} -u uhub -g uhub -L";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      };
    };
  };

}
