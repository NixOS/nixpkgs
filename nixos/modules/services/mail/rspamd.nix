{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.rspamd;

  mkBindSockets = socks: concatStringsSep "\n" (map (each: "  bind_socket = \"${each}\"") socks);

   rspamdConfFile = pkgs.writeText "rspamd.conf"
    ''
      .include "$CONFDIR/common.conf"

      options {
        pidfile = "$RUNDIR/rspamd.pid";
        .include "$CONFDIR/options.inc"
      }

      logging {
        type = "syslog";
        .include "$CONFDIR/logging.inc"
      }

      worker {
      ${mkBindSockets cfg.bindSocket}
        .include "$CONFDIR/worker-normal.inc"
      }

      worker {
      ${mkBindSockets cfg.bindUISocket}
        .include "$CONFDIR/worker-controller.inc"
      }
   '';

in

{

  ###### interface

  options = {

    services.rspamd = {

      enable = mkEnableOption "Whether to run the rspamd daemon.";

      debug = mkOption {
        default = false;
        description = "Whether to run the rspamd daemon in debug mode.";
      };

      bindSocket = mkOption {
        type = types.listOf types.str;
        default = [
          "/run/rspamd/rspamd.sock mode=0666 owner=${cfg.user}"
        ];
        description = ''
          List of sockets to listen, in format acceptable by rspamd
        '';
        example = ''
          bindSocket = [
            "/run/rspamd.sock mode=0666 owner=rspamd"
            "*:11333"
          ];
        '';
      };

      bindUISocket = mkOption {
        type = types.listOf types.str;
        default = [
          "localhost:11334"
        ];
        description = ''
          List of sockets for web interface, in format acceptable by rspamd
        '';
      };

      user = mkOption {
        type = types.string;
        default = "rspamd";
        description = ''
          User to use when no root privileges are required.
        '';
       };

      group = mkOption {
        type = types.string;
        default = "rspamd";
        description = ''
          Group to use when no root privileges are required.
        '';
       };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    # Allow users to run 'rspamc' and 'rspamadm'.
    environment.systemPackages = [ pkgs.rspamd ];

    users.extraUsers = singleton {
      name = cfg.user;
      description = "rspamd daemon";
      uid = config.ids.uids.rspamd;
      group = cfg.group;
    };

    users.extraGroups = singleton {
      name = cfg.group;
      gid = config.ids.gids.rspamd;
    };

    systemd.services.rspamd = {
      description = "Rspamd Service";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.rspamd}/bin/rspamd ${optionalString cfg.debug "-d"} --user=${cfg.user} --group=${cfg.group} --pid=/run/rspamd.pid -c ${rspamdConfFile} -f";
        Restart = "always";
        RuntimeDirectory = "rspamd";
        PrivateTmp = true;
      };

      preStart = ''
        ${pkgs.coreutils}/bin/mkdir -p /var/lib/rspamd
        ${pkgs.coreutils}/bin/chown ${cfg.user}:${cfg.group} /var/lib/rspamd
      '';
    };
  };
}
