{ config, pkgs, ... }:

with pkgs.lib;

let

  inInitrd = any (fs: fs == "nfs") config.boot.initrd.supportedFilesystems;

in

{

  ###### interface

  options = {

    services.nfs.client.enable = mkOption {
      default = any (fs: fs.fsType == "nfs" || fs.fsType == "nfs4") config.fileSystems;
      description = ''
        Whether to enable support for mounting NFS filesystems.
      '';
    };

  };


  ###### implementation

  config = mkIf config.services.nfs.client.enable {

    services.portmap.enable = true;
    
    system.fsPackages = [ pkgs.nfsUtils ];

    boot.initrd.kernelModules = mkIf inInitrd [ "nfs" ];

    boot.initrd.extraUtilsCommands = mkIf inInitrd
      ''
        # !!! Uh, why don't we just install mount.nfs?
        cp -v ${pkgs.klibc}/lib/klibc/bin.static/nfsmount $out/bin
      '';

    jobs.statd =
      { description = "Kernel NFS server - Network Status Monitor";

        path = [ pkgs.nfsUtils pkgs.sysvtools pkgs.utillinux ];

        stopOn = ""; # needed during shutdown

        preStart =
          ''
            ensure portmap
            mkdir -p /var/lib/nfs
            mkdir -p /var/lib/nfs/sm
            mkdir -p /var/lib/nfs/sm.bak
            sm-notify -d
          '';

        daemonType = "fork";

        exec = "rpc.statd --no-notify";
      };

  };
}
