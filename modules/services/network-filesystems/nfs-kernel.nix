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

  config = {

    services.portmap.enable = cfg.client.enable || cfg.server.enable;

    environment.systemPackages = mkIf cfg.server.enable [ pkgs.nfsUtils ];

    environment.etc = mkIf cfg.server.enable (singleton
      { source = exports;
        target = "exports";
      });

    boot.kernelModules = mkIf cfg.server.enable [ "nfsd" ];

    jobs =
      optionalAttrs cfg.server.enable
        { nfsd =
          { description = "Kernel NFS server";

            startOn = "started networking";

            path = [ pkgs.nfsUtils ];

            preStart =
              ''
                start portmap || true
                start mountd || true
              
                # Create a state directory required by NFSv4.
                mkdir -p /var/lib/nfs/v4recovery

                rpc.nfsd \
                  ${if cfg.server.hostName != null then "-H ${cfg.server.hostName}" else ""} \
                  ${builtins.toString cfg.server.nproc}
              '';

            postStop = "rpc.nfsd 0";

            postStart =
              ''
                start statd || true
              '';
          };
        }

      // optionalAttrs cfg.server.enable
        { mountd =
          { description = "Kernel NFS server - mount daemon";

            path = [ pkgs.nfsUtils pkgs.sysvtools pkgs.utillinux ];

            preStart =
              ''
                start portmap || true
                
                mkdir -p /var/lib/nfs
                touch /var/lib/nfs/rmtab
                
                mountpoint -q /proc/fs/nfsd || mount -t nfsd none /proc/fs/nfsd

                ${optionalString cfg.server.createMountPoints
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
        }

      // optionalAttrs (cfg.client.enable || cfg.server.enable)
        { statd =
          { description = "Kernel NFS server - Network Status Monitor";

            path = [ pkgs.nfsUtils pkgs.sysvtools pkgs.utillinux ];

            stopOn = "never"; # needed during shutdown

            preStart =
              ''
                start portmap || true
                mkdir -p /var/lib/nfs
                mkdir -p /var/lib/nfs/sm
                mkdir -p /var/lib/nfs/sm.bak
                sm-notify -d
              '';

            daemonType = "fork";

            exec = "rpc.statd --no-notify";
          };
        };

  };

}
