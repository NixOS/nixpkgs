{ config, lib, pkgs, ... }:

with lib;

let

  rspamdCfg = config.services.rspamd;
  postfixCfg = config.services.postfix;
  cfg = config.services.rmilter;

  inetSocket = addr: port: "inet:[${toString port}@${addr}]";
  unixSocket = sock: "unix:${sock}";

  systemdSocket = if cfg.bindSocket.type == "unix" then cfg.bindSocket.path
    else "${cfg.bindSocket.address}:${toString cfg.bindSocket.port}";
  rmilterSocket = if cfg.bindSocket.type == "unix" then unixSocket cfg.bindSocket.path
    else inetSocket cfg.bindSocket.address cfg.bindSocket.port;

  rmilterConf = ''
    pidfile = /run/rmilter/rmilter.pid;
    bind_socket = ${if cfg.socketActivation then "fd:3" else rmilterSocket};
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
        type = types.bool;
        default = cfg.rspamd.enable;
        description = "Whether to run the rmilter daemon.";
      };

      debug = mkOption {
        type = types.bool;
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

      bindSocket.type = mkOption {
        type = types.enum [ "unix" "inet" ];
        default = "unix";
        description = ''
          What kind of socket rmilter should listen on. Either "unix"
          for an Unix domain socket or "inet" for a TCP socket.
        '';
      };

      bindSocket.path = mkOption {
       type = types.str;
       default = "/run/rmilter/rmilter.sock";
       description = ''
          Path to Unix domain socket to listen on.
        '';
      };

      bindSocket.address = mkOption {
        type = types.str;
        default = "::1";
        example = "0.0.0.0";
        description = ''
          Inet address to listen on.
        '';
      };

      bindSocket.port = mkOption {
        type = types.int;
        default = 11990;
        description = ''
          Inet port to listen on.
        '';
      };

      socketActivation = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Enable systemd socket activation for rmilter.

          Disabling socket activation is not recommended when a Unix
          domain socket is used and could lead to incorrect
          permissions.
        '';
      };

      rspamd = {
        enable = mkOption {
          type = types.bool;
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
            smtpd_milters = ${rmilterSocket}
            milter_protocol = 6
            milter_mail_macros = i {mail_addr} {client_addr} {client_name} {auth_authen}
          '';
        };
      };

    };

  };


  ###### implementation

  config = mkMerge [

    (mkIf cfg.enable {

      users.extraUsers = singleton {
        name = cfg.user;
        description = "rmilter daemon";
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
          RuntimeDirectoryMode = "0750";
        };

      };

      systemd.sockets.rmilter = mkIf cfg.socketActivation {
        description = "Rmilter service socket";
        wantedBy = [ "sockets.target" ];
        socketConfig = {
          ListenStream = systemdSocket;
          SocketUser = cfg.user;
          SocketGroup = cfg.group;
          SocketMode = "0660";
        };
      };
    })

    (mkIf (cfg.enable && cfg.rspamd.enable && rspamdCfg.enable) {
      users.extraUsers.${cfg.user}.extraGroups = [ rspamdCfg.group ];
    })

    (mkIf (cfg.enable && cfg.postfix.enable) {
      services.postfix.extraConfig = cfg.postfix.configFragment;
      users.extraUsers.${postfixCfg.user}.extraGroups = [ cfg.group ];
    })
  ];
}
