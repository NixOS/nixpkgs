{ config, lib, pkgs, ... }:

with lib;

let

  rspamdCfg = config.services.rspamd;
  cfg = config.services.rmilter;

  inetSockets = map (sock: let s = splitString ":" sock; in "inet:${last s}@${head s}") cfg.bindInetSockets;
  unixSockets = map (sock: "unix:${sock}") cfg.bindUnixSockets;

  allSockets = unixSockets ++ inetSockets;

  rmilterConf = ''
    pidfile = /run/rmilter/rmilter.pid;
    bind_socket = ${if cfg.socketActivation then "fd:3" else last inetSockets};
    tempdir = /tmp;
  '' + (with cfg.rspamd; if enable then ''
    spamd {
      servers = ${concatStringsSep ", " servers};
      connect_timeout = 1s;
      results_timeout = 20s;
      error_time = 10;
      dead_time = 300;
      maxerrors = 10;
      reject_message = "${rejectMessage}";
      ${optionalString (length whitelist != 0)  "whitelist = ${concatStringsSep ", " whitelist};"}

      # rspamd_metric - metric for using with rspamd
      # Default: "default"
      rspamd_metric = "default";
      ${extraConfig}
    };
    '' else "") + cfg.extraConfig;

  rmilterConfigFile = pkgs.writeText "rmilter.conf" rmilterConf;

in

{

  ###### interface

  options = {

    services.rmilter = {

      enable = mkOption {
        default = cfg.rspamd.enable;
        description = "Whether to run the rmilter daemon.";
      };

      debug = mkOption {
        default = false;
        description = "Whether to run the rmilter daemon in debug mode.";
      };

      user = mkOption {
        type = types.string;
        default = "rmilter";
        description = ''
          User to use when no root privileges are required.
        '';
       };

      group = mkOption {
        type = types.string;
        default = "rmilter";
        description = ''
          Group to use when no root privileges are required.
        '';
       };

      bindUnixSockets =  mkOption {
        type = types.listOf types.str;
        default = ["/run/rmilter/rmilter.sock"];
        description = ''
          Unix domain sockets to listen for MTA requests.
        '';
        example = ''
            [ "/run/rmilter.sock"]
        '';
      };

      bindInetSockets = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Inet addresses to listen (in format accepted by systemd.socket)
        '';
        example = ''
            ["127.0.0.1:11990"]
        '';
      };

      socketActivation = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Enable systemd socket activation for rmilter.

          Disabling socket activation is not recommended when a Unix
          domain socket is used and could lead to incorrect
          permissions.  Therefore, setting this to false will
          configure rmilter to use an inet socket only.
        '';
      };

      rspamd = {
        enable = mkOption {
          default = rspamdCfg.enable;
          description = "Whether to use rspamd to filter mails";
        };

        servers = mkOption {
          type = types.listOf types.str;
          default = ["r:/run/rspamd/rspamd.sock"];
          description = ''
            Spamd socket definitions.
            Is server name is prefixed with r: it is rspamd server.
          '';
        };

        whitelist = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "list of ips or nets that should be not checked with spamd";
        };

        rejectMessage = mkOption {
          type = types.str;
          default = "Spam message rejected; If this is not spam contact abuse";
          description = "reject message for spam";
        };

        extraConfig = mkOption {
          type = types.lines;
          default = "";
          description = "Custom snippet to append to end of `spamd' section";
        };
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Custom snippet to append to rmilter config";
      };

      postfix = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Add rmilter to postfix main.conf";
        };

        configFragment = mkOption {
          type = types.str;
          description = "Addon to postfix configuration";
          default = ''
smtpd_milters = ${head allSockets}
# or for TCP socket
# # smtpd_milters = inet:localhost:9900
milter_protocol = 6
milter_mail_macros = i {mail_addr} {client_addr} {client_name} {auth_authen}
# skip mail without checks if milter will die
milter_default_action = accept
          '';
        };
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    users.extraUsers = singleton {
      name = cfg.user;
      description = "rspamd daemon";
      uid = config.ids.uids.rmilter;
      group = cfg.group;
    };

    users.extraGroups = singleton {
      name = cfg.group;
      gid = config.ids.gids.rmilter;
    };

    systemd.services.rmilter = {
      description = "Rmilter Service";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.rmilter}/bin/rmilter ${optionalString cfg.debug "-d"} -n -c ${rmilterConfigFile}";
        ExecReload = "${pkgs.coreutils}/bin/kill -USR1 $MAINPID";
        User = cfg.user;
        Group = cfg.group;
        PermissionsStartOnly = true;
        Restart = "always";
        RuntimeDirectory = "rmilter";
        RuntimeDirectoryMode = "0755";
      };

    };

    systemd.sockets.rmilter = mkIf cfg.socketActivation {
      description = "Rmilter service socket";
      wantedBy = [ "sockets.target" ];
      socketConfig = {
        ListenStream = cfg.bindUnixSockets ++ cfg.bindInetSockets;
        SocketUser = cfg.user;
        SocketGroup = cfg.group;
        SocketMode = "0666";
      };
    };

    services.postfix.extraConfig = optionalString cfg.postfix.enable cfg.postfix.configFragment;
    users.users.postfix.extraGroups = [ cfg.group ];
  };

}
