{ config, lib, pkgs, ... }:

with lib;

let
  inherit (pkgs) glusterfs;

  cfg = config.services.glusterfs;

in

{

  ###### interface

  options = {

    services.glusterfs = {

      enable = mkEnableOption "GlusterFS Daemon";

      logLevel = mkOption {
        type = types.enum ["DEBUG" "INFO" "WARNING" "ERROR" "CRITICAL" "TRACE" "NONE"];
        description = "Log level used by the GlusterFS daemon";
        default = "INFO";
      };

      extraFlags = mkOption {
        type = types.listOf types.str;
        description = "Extra flags passed to the GlusterFS daemon";
        default = [];
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.glusterfs ];

    services.rpcbind.enable = true;

    systemd.services.glusterd = {

      description = "GlusterFS, a clustered file-system server";

      wantedBy = [ "multi-user.target" ];

      requires = [ "rpcbind.service" ];
      after = [ "rpcbind.service" "network.target" "local-fs.target" ];
      before = [ "network-online.target" ];

      preStart = ''
        install -m 0755 -d /var/log/glusterfs
      '';

      serviceConfig = {
        Type="forking";
        PIDFile="/run/glusterd.pid";
        LimitNOFILE=65536;
        ExecStart="${glusterfs}/sbin/glusterd -p /run/glusterd.pid --log-level=${cfg.logLevel} ${toString cfg.extraFlags}";
        KillMode="process";
      };
    };

    systemd.services.glustereventsd = {

      description = "Gluster Events Notifier";

      wantedBy = [ "multi-user.target" ];

      after = [ "syslog.target" "network.target" ];

      serviceConfig = {
        Type="simple";
        Environment="PYTHONPATH=${glusterfs}/usr/lib/python2.7/site-packages";
        PIDFile="/run/glustereventsd.pid";
        ExecStart="${glusterfs}/sbin/glustereventsd --pid-file /run/glustereventsd.pid";
        ExecReload="/bin/kill -SIGUSR2 $MAINPID";
        KillMode="control-group";
      };
    };
  };
}
