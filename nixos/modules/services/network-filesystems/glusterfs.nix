{ config, lib, pkgs, ... }:

with lib;

let
  inherit (pkgs) glusterfs rsync;

  tlsCmd = if (cfg.tlsSettings != null) then
  ''
    mkdir -p /var/lib/glusterd
    touch /var/lib/glusterd/secure-access
  ''
  else
  ''
    rm -f /var/lib/glusterd/secure-access
  '';

  restartTriggers = if (cfg.tlsSettings != null) then [
    config.environment.etc."ssl/glusterfs.pem".source
    config.environment.etc."ssl/glusterfs.key".source
    config.environment.etc."ssl/glusterfs.ca".source
  ] else [];

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

      tlsSettings = mkOption {
        description = ''
          Make the server communicate via TLS.
          This means it will only connect to other gluster
          servers having certificates signed by the same CA.

          Enabling this will create a file <filename>/var/lib/glusterd/secure-access</filename>.
          Disabling will delete this file again.

          See also: https://gluster.readthedocs.io/en/latest/Administrator%20Guide/SSL/
        '';
        default = null;
        type = types.nullOr (types.submodule {
          options = {
            tlsKeyPath = mkOption {
              default = null;
              type = types.str;
              description = "Path to the private key used for TLS.";
            };

            tlsPem = mkOption {
              default = null;
              type = types.path;
              description = "Path to the certificate used for TLS.";
            };

            caCert = mkOption {
              default = null;
              type = types.path;
              description = "Path certificate authority used to sign the cluster certificates.";
            };
          };
        });
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.glusterfs ];

    services.rpcbind.enable = true;

    environment.etc = mkIf (cfg.tlsSettings != null) {
      "ssl/glusterfs.pem".source = cfg.tlsSettings.tlsPem;
      "ssl/glusterfs.key".source = cfg.tlsSettings.tlsKeyPath;
      "ssl/glusterfs.ca".source = cfg.tlsSettings.caCert;
    };

    systemd.services.glusterd = {
      inherit restartTriggers;

      description = "GlusterFS, a clustered file-system server";

      wantedBy = [ "multi-user.target" ];

      requires = [ "rpcbind.service" ];
      after = [ "rpcbind.service" "network.target" "local-fs.target" ];

      preStart = ''
        install -m 0755 -d /var/log/glusterfs
      ''
      # The copying of hooks is due to upstream bug https://bugzilla.redhat.com/show_bug.cgi?id=1452761
      + ''
        mkdir -p /var/lib/glusterd/hooks/
        ${rsync}/bin/rsync -a ${glusterfs}/var/lib/glusterd/hooks/ /var/lib/glusterd/hooks/

        ${tlsCmd}
      ''
      # `glusterfind` needs dirs that upstream installs at `make install` phase
      # https://github.com/gluster/glusterfs/blob/v3.10.2/tools/glusterfind/Makefile.am#L16-L17
      + ''
        mkdir -p /var/lib/glusterd/glusterfind/.keys
        mkdir -p /var/lib/glusterd/hooks/1/delete/post/
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
      inherit restartTriggers;

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
