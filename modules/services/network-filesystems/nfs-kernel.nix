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
    
    assertions = mkIf (cfg.client.enable || cfg.server.enable) (singleton
      { assertion = cfg.client.enable || cfg.server.enable;
        message = "Please enable portmap (services.portmap.enable) to use nfs-kernel.";
      });

    environment.etc = mkIf cfg.server.enable (singleton
      { source = exports;
        target = "exports";
      });

    jobs =
      optionalAttrs cfg.server.enable
        { nfs_kernel_exports = 
          { name = "nfs-kernel-exports";
      
            description = "Kernel NFS server";

            startOn = "started network-interfaces";
            stopOn = "stopping network-interfaces";

            preStart =
              ''
                export PATH=${pkgs.nfsUtils}/sbin:$PATH
                mkdir -p /var/lib/nfs
                
                ${config.system.sbin.modprobe}/sbin/modprobe nfsd || true

                ${pkgs.sysvtools}/bin/mountpoint -q /proc/fs/nfsd \
                || ${config.system.sbin.mount}/bin/mount -t nfsd none /proc/fs/nfsd

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
          };
        }
    
      // optionalAttrs cfg.server.enable
        { nfs_kernel_nfsd = 
          { name = "nfs-kernel-nfsd";

            description = "Kernel NFS server";

            startOn = "started nfs-kernel-exports and started portmap";
            stopOn = "stopping nfs-kernel-exports";

            preStart = "${pkgs.nfsUtils}/sbin/rpc.nfsd ${if cfg.server.hostName != null then "-H ${cfg.server.hostName}" else ""} ${builtins.toString cfg.server.nproc}";

            postStop = "${pkgs.nfsUtils}/sbin/rpc.nfsd 0";
          };
        }

      // optionalAttrs cfg.server.enable
        { nfs_kernel_mountd =
          { name = "nfs-kernel-mountd";

            description = "Kernel NFS server - mount daemon";

            startOn = "starting nfs-kernel-nfsd and started portmap";
            stopOn = "stopped nfs-kernel-nfsd";

            daemonType = "fork";

            exec = "${pkgs.nfsUtils}/sbin/rpc.mountd -f /etc/exports";
          };
        }

      // optionalAttrs (cfg.client.enable || cfg.server.enable)
        { nfs_kernel_statd = 
          { name = "nfs-kernel-statd";

            description = "Kernel NFS server - Network Status Monitor";

            startOn = "${if cfg.server.enable then "starting nfs-kernel-nfsd and " else ""} started portmap";
            stopOn = if cfg.server.enable then "stopped nfs-kernel-nfsd" else "starting shutdown";

            preStart =
              ''	
                mkdir -p /var/lib/nfs
                mkdir -p /var/lib/nfs/sm
                mkdir -p /var/lib/nfs/sm.bak
              '';

            daemonType = "fork";

            exec = "${pkgs.nfsUtils}/sbin/rpc.statd --no-notify";
          };
        }
      
      // optionalAttrs (cfg.client.enable || cfg.server.enable)
        { nfs_kernel_sm_notify = 
          { name = "nfs-kernel-sm-notify";

            description = "Kernel NFS server - Reboot notification";

            startOn = "started nfs-kernel-statd"
              + (if cfg.client.enable then " and starting mountall" else "");

            task = true;

            exec = "${pkgs.nfsUtils}/sbin/sm-notify -d";
          };
        };
      
  };
  
}
