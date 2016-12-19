{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.nfs.server;

  exports = pkgs.writeText "exports" cfg.exports;

in

{

  ###### interface

  options = {

    services.nfs = {

      server = {
        enable = mkOption {
          default = false;
          description = ''
            Whether to enable the kernel's NFS server.
          '';
        };

        exports = mkOption {
          default = "";
          description = ''
            Contents of the /etc/exports file.  See
            <citerefentry><refentrytitle>exports</refentrytitle>
            <manvolnum>5</manvolnum></citerefentry> for the format.
          '';
        };

        hostName = mkOption {
          default = null;
          description = ''
            Hostname or address on which NFS requests will be accepted.
            Default is all.  See the <option>-H</option> option in
            <citerefentry><refentrytitle>nfsd</refentrytitle>
            <manvolnum>8</manvolnum></citerefentry>.
          '';
        };

        nproc = mkOption {
          default = 8;
          description = ''
            Number of NFS server threads.  Defaults to the recommended value of 8.
          '';
        };

        createMountPoints = mkOption {
          default = false;
          description = "Whether to create the mount points in the exports file at startup time.";
        };

        mountdPort = mkOption {
          default = null;
          example = 4002;
          description = ''
            Use fixed port for rpc.mountd, useful if server is behind firewall.
          '';
        };

        lockdPort = mkOption {
          default = 0;
          description = ''
            Fix the lockd port number. This can help setting firewall rules for NFS.
          '';
        };
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    services.rpcbind.enable = true;

    boot.supportedFilesystems = [ "nfs" ]; # needed for statd and idmapd

    environment.systemPackages = [ pkgs.nfs-utils ];

    environment.etc.exports.source = exports;

    boot.kernelModules = [ "nfsd" ];

    systemd.services.nfsd =
      { description = "NFS Server";

        wantedBy = [ "multi-user.target" ];

        requires = [ "rpcbind.service" "mountd.service" ];
        after = [ "rpcbind.service" "mountd.service" "idmapd.service" ];
        before = [ "statd.service" ];

        path = [ pkgs.nfs-utils ];

        script =
          ''
            # Create a state directory required by NFSv4.
            mkdir -p /var/lib/nfs/v4recovery

            ${pkgs.procps}/sbin/sysctl -w fs.nfs.nlm_tcpport=${builtins.toString cfg.lockdPort}
            ${pkgs.procps}/sbin/sysctl -w fs.nfs.nlm_udpport=${builtins.toString cfg.lockdPort}

            rpc.nfsd \
              ${if cfg.hostName != null then "-H ${cfg.hostName}" else ""} \
              ${builtins.toString cfg.nproc}
          '';

        postStop = "rpc.nfsd 0";

        serviceConfig.Type = "oneshot";
        serviceConfig.RemainAfterExit = true;
      };

    systemd.services.mountd =
      { description = "NFSv3 Mount Daemon";

        requires = [ "rpcbind.service" ];
        after = [ "rpcbind.service" "local-fs.target" ];

        path = [ pkgs.nfs-utils pkgs.sysvtools pkgs.utillinux ];

        preStart =
          ''
            mkdir -p /var/lib/nfs
            touch /var/lib/nfs/rmtab

            mountpoint -q /proc/fs/nfsd || mount -t nfsd none /proc/fs/nfsd

            ${optionalString cfg.createMountPoints
              ''
                # create export directories:
                # skip comments, take first col which may either be a quoted
                # "foo bar" or just foo (-> man export)
                sed '/^#.*/d;s/^"\([^"]*\)".*/\1/;t;s/[ ].*//' ${exports} \
                | xargs -d '\n' mkdir -p
              ''
            }

            exportfs -rav
          '';

        restartTriggers = [ exports ];

        serviceConfig.Type = "forking";
        serviceConfig.ExecStart = ''
          @${pkgs.nfs-utils}/sbin/rpc.mountd rpc.mountd \
              ${if cfg.mountdPort != null then "-p ${toString cfg.mountdPort}" else ""}
        '';
        serviceConfig.Restart = "always";
      };

  };

}
