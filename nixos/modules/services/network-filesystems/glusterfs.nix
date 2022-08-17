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
        description = lib.mdDoc "Log level used by the GlusterFS daemon";
        default = "INFO";
      };

      useRpcbind = mkOption {
        type = types.bool;
        description = lib.mdDoc ''
          Enable use of rpcbind. This is required for Gluster's NFS functionality.

          You may want to turn it off to reduce the attack surface for DDoS reflection attacks.

          See https://davelozier.com/glusterfs-and-rpcbind-portmap-ddos-reflection-attacks/
          and https://bugzilla.redhat.com/show_bug.cgi?id=1426842 for details.
        '';
        default = true;
      };

      enableGlustereventsd = mkOption {
        type = types.bool;
        description = lib.mdDoc "Whether to enable the GlusterFS Events Daemon";
        default = true;
      };

      killMode = mkOption {
        type = types.enum ["control-group" "process" "mixed" "none"];
        description = lib.mdDoc ''
          The systemd KillMode to use for glusterd.

          glusterd spawns other daemons like gsyncd.
          If you want these to stop when glusterd is stopped (e.g. to ensure
          that NixOS config changes are reflected even for these sub-daemons),
          set this to 'control-group'.
          If however you want running volume processes (glusterfsd) and thus
          gluster mounts not be interrupted when glusterd is restarted
          (for example, when you want to restart them manually at a later time),
          set this to 'process'.
        '';
        default = "control-group";
      };

      stopKillTimeout = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          The systemd TimeoutStopSec to use.

          After this time after having been asked to shut down, glusterd
          (and depending on the killMode setting also its child processes)
          are killed by systemd.

          The default is set low because GlusterFS (as of 3.10) is known to
          not tell its children (like gsyncd) to terminate at all.
        '';
        default = "5s";
      };

      extraFlags = mkOption {
        type = types.listOf types.str;
        description = lib.mdDoc "Extra flags passed to the GlusterFS daemon";
        default = [];
      };

      tlsSettings = mkOption {
        description = lib.mdDoc ''
          Make the server communicate via TLS.
          This means it will only connect to other gluster
          servers having certificates signed by the same CA.

          Enabling this will create a file {file}`/var/lib/glusterd/secure-access`.
          Disabling will delete this file again.

          See also: https://gluster.readthedocs.io/en/latest/Administrator%20Guide/SSL/
        '';
        default = null;
        type = types.nullOr (types.submodule {
          options = {
            tlsKeyPath = mkOption {
              type = types.str;
              description = lib.mdDoc "Path to the private key used for TLS.";
            };

            tlsPem = mkOption {
              type = types.path;
              description = lib.mdDoc "Path to the certificate used for TLS.";
            };

            caCert = mkOption {
              type = types.path;
              description = lib.mdDoc "Path certificate authority used to sign the cluster certificates.";
            };
          };
        });
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.glusterfs ];

    services.rpcbind.enable = cfg.useRpcbind;

    environment.etc = mkIf (cfg.tlsSettings != null) {
      "ssl/glusterfs.pem".source = cfg.tlsSettings.tlsPem;
      "ssl/glusterfs.key".source = cfg.tlsSettings.tlsKeyPath;
      "ssl/glusterfs.ca".source = cfg.tlsSettings.caCert;
    };

    systemd.services.glusterd = {
      inherit restartTriggers;

      description = "GlusterFS, a clustered file-system server";

      wantedBy = [ "multi-user.target" ];

      requires = lib.optional cfg.useRpcbind "rpcbind.service";
      after = [ "network.target" ] ++ lib.optional cfg.useRpcbind "rpcbind.service";

      preStart = ''
        install -m 0755 -d /var/log/glusterfs
      ''
      # The copying of hooks is due to upstream bug https://bugzilla.redhat.com/show_bug.cgi?id=1452761
      # Excludes one hook due to missing SELinux binaries.
      + ''
        mkdir -p /var/lib/glusterd/hooks/
        ${rsync}/bin/rsync -a --exclude="S10selinux-label-brick.sh" ${glusterfs}/var/lib/glusterd/hooks/ /var/lib/glusterd/hooks/

        ${tlsCmd}
      ''
      # `glusterfind` needs dirs that upstream installs at `make install` phase
      # https://github.com/gluster/glusterfs/blob/v3.10.2/tools/glusterfind/Makefile.am#L16-L17
      + ''
        mkdir -p /var/lib/glusterd/glusterfind/.keys
        mkdir -p /var/lib/glusterd/hooks/1/delete/post/
      '';

      serviceConfig = {
        LimitNOFILE=65536;
        ExecStart="${glusterfs}/sbin/glusterd --no-daemon --log-level=${cfg.logLevel} ${toString cfg.extraFlags}";
        KillMode=cfg.killMode;
        TimeoutStopSec=cfg.stopKillTimeout;
      };
    };

    systemd.services.glustereventsd = mkIf cfg.enableGlustereventsd {
      inherit restartTriggers;

      description = "Gluster Events Notifier";

      wantedBy = [ "multi-user.target" ];

      after = [ "network.target" ];

      preStart = ''
        install -m 0755 -d /var/log/glusterfs
      '';

      # glustereventsd uses the `gluster` executable
      path = [ glusterfs ];

      serviceConfig = {
        Type="simple";
        PIDFile="/run/glustereventsd.pid";
        ExecStart="${glusterfs}/sbin/glustereventsd --pid-file /run/glustereventsd.pid";
        ExecReload="/bin/kill -SIGUSR2 $MAINPID";
        KillMode="control-group";
      };
    };
  };
}
