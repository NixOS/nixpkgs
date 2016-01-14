{ config, lib, pkgs, ... }:

with lib;

let

  rspamdCfg = config.services.rspamd;
  cfg = config.services.rmilter;

  rmilterConf = ''
pidfile = /run/rmilter/rmilter.pid;
bind_socket = ${cfg.bindSocket};
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

      bindSocket =  mkOption {
        type = types.string;
        default = "unix:/run/rmilter/rmilter.sock";
        description = "Socket to listed for MTA requests";
        example = ''
            "unix:/run/rmilter/rmilter.sock" or
            "inet:11990@127.0.0.1"
          '';
      };

      rspamd = {
        enable = mkOption {
          default = rspamdCfg.enable;
          description = "Whether to use rspamd to filter mails";
        };

        servers = mkOption {
          type = types.listOf types.str;
          default = ["r:0.0.0.0:11333"];
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
smtpd_milters = ${cfg.bindSocket}
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
        User = cfg.user;
        Group = cfg.group;
        PermissionsStartOnly = true;
        Restart = "always";
      };

      preStart = ''
        ${pkgs.coreutils}/bin/mkdir -p /run/rmilter
        ${pkgs.coreutils}/bin/chown ${cfg.user}:${cfg.group} /run/rmilter
      '';

    };

    services.postfix.extraConfig = optionalString cfg.postfix.enable cfg.postfix.configFragment;

  };

}
