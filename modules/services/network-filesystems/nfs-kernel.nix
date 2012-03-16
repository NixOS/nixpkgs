{ config, pkgs, ... }:

with pkgs.lib;

let

  inherit (pkgs) writeText openssh;

  cfg = config.services.nfsKernel;

  exports = pkgs.writeText "exports" cfg.server.exports;

in

{

  ###### interface

  options = {

    services.nfsKernel = {

      client.enable = mkOption {
        default = any (fs: fs.fsType == "nfs" || fs.fsType == "nfs4") config.fileSystems;
        description = ''
          Whether to enable the kernel's NFS client daemons.
        '';
      };

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
      };

    };

  };


  ###### implementation

  config =
  mkAssert
    (cfg.client.enable || cfg.server.enable -> config.services.portmap.enable) "
    Please enable portmap (services.portmap.enable) to use nfsd.
  " {

    services.portmap.enable = mkAlways (cfg.client.enable || cfg.server.enable);

    environment.etc = mkIf cfg.server.enable (singleton
      { source = exports;
        target = "exports";
      });

    jobs =
      optionalAttrs cfg.server.enable
        { nfsd =
          { description = "Kernel NFS server";

            startOn = "started portmap";
            stopOn = "stopped statd";

            preStart =
              ''
                export PATH=${pkgs.nfsUtils}/sbin:$PATH
                mkdir -p /var/lib/nfs

                # Create a state directory required by NFSv4.
                mkdir -p /var/lib/nfs/v4recovery

                # exports file is ${exports}
                # keep this comment so that this job is restarted whenever exports changes!
                ${pkgs.nfsUtils}/sbin/exportfs -ra
                
                # rpc.nfsd needs the kernel support
                ${config.system.sbin.modprobe}/sbin/modprobe nfsd || true

                ${pkgs.sysvtools}/bin/mountpoint -q /proc/fs/nfsd \
                || ${pkgs.utillinux}/bin/mount -t nfsd none /proc/fs/nfsd

                ${optionalString cfg.server.createMountPoints
                  ''
                    # create export directories:
                    # skip comments, take first col which may either be a quoted
                    # "foo bar" or just foo (-> man export)
                    sed '/^#.*/d;s/^"\([^"]*\)".*/\1/;t;s/[ ].*//' ${exports} \
                    | xargs -d '\n' mkdir -p
                  ''
                }

                ${pkgs.nfsUtils}/sbin/rpc.nfsd \
                  ${if cfg.server.hostName != null then "-H ${cfg.server.hostName}" else ""} \
                  ${builtins.toString cfg.server.nproc}
              '';

            postStop = "${pkgs.nfsUtils}/sbin/rpc.nfsd 0";
          };
        }

      // optionalAttrs cfg.server.enable
        { mountd =
          { description = "Kernel NFS server - mount daemon";

            startOn = "started nfsd";
            stopOn = "stopped statd";

            daemonType = "fork";

            exec = "${pkgs.nfsUtils}/sbin/rpc.mountd -f /etc/exports";
          };
        }

      // optionalAttrs (cfg.client.enable || cfg.server.enable)
        { statd =
          { description = "Kernel NFS server - Network Status Monitor";

            startOn = if cfg.server.enable then
                "started mountd and started nfsd"
              else
                "started portmap";
            stopOn = "stopping nfsd";

            preStart =
              ''
                mkdir -p /var/lib/nfs
                mkdir -p /var/lib/nfs/sm
                mkdir -p /var/lib/nfs/sm.bak
              '';

            daemonType = "fork";

            exec = "${pkgs.nfsUtils}/sbin/rpc.statd --no-notify";

            postStart = "${pkgs.nfsUtils}/sbin/sm-notify -d";
          };
        };

  };

}
