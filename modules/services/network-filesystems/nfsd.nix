{ config, pkgs, ... }:

with pkgs.lib;

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
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    services.portmap.enable = true;

    services.nfs.client.enable = true; # needed for statd and idmapd

    environment.systemPackages = [ pkgs.nfsUtils ];

    environment.etc = singleton
      { source = exports;
        target = "exports";
      };

    boot.kernelModules = [ "nfsd" ];

    jobs.nfsd =
      { description = "Kernel NFS server";

        startOn = "started networking";

        path = [ pkgs.nfsUtils ];

        preStart =
          ''
            ensure portmap
            ensure mountd

            # Create a state directory required by NFSv4.
            mkdir -p /var/lib/nfs/v4recovery

            rpc.nfsd \
              ${if cfg.hostName != null then "-H ${cfg.hostName}" else ""} \
              ${builtins.toString cfg.nproc}
          '';

        postStop = "rpc.nfsd 0";

        postStart =
          ''
            ensure statd
            ensure idmapd
          '';
      };

    jobs.mountd =
      { description = "Kernel NFS server - mount daemon";

        path = [ pkgs.nfsUtils pkgs.sysvtools pkgs.utillinux ];

        preStart =
          ''
            ensure portmap

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

            # exports file is ${exports}
            # keep this comment so that this job is restarted whenever exports changes!
            exportfs -ra
          '';

        daemonType = "fork";

        exec = "rpc.mountd -f /etc/exports";
      };

  };

}
