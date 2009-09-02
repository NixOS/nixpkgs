
{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption mkIf;

  options = {
    services = {
      nfsKernel = {

        enable = mkOption {
          default = false;
          description = "
            wether to use the kernel nfs functionality to export filesystems.
            You should be aware about existing security issues.
            requires portmap!
          ";
        };

        exports = mkOption {
          default = "/etc/exports";
          description = "
            the file listing the directories to be exported.
            install nfsUtils and run man exports to learn about its format.
            The exports setting can either be a file path or the file contents.
          ";
        };

        hostName = mkOption {
          default = null;
          description = "
             specify a particular hostname (or address) that NFS requests will be accepted on.
             Default: all.
             See man rpc.nfsd (-H option)
          ";
        };
        nproc = mkOption {
          default = 8;
          description = "
            specify  the  number  of NFS server threads. (-> man rpc.nfsd). Defaults to recommended value 8
          ";
        };
      };
    };
  };

###### implementation

  inherit (pkgs) writeText openssh;

  cfg = (config.services.nfsKernel);

  modprobe = config.system.sbin.modprobe;

  exports = if builtins.pathExists cfg.exports
    then cfg.exports else pkgs.writeText "exports" cfg.exports;

in


mkIf config.services.nfsKernel.enable {
  require = [
    options
  ];

  services = {
    extraJobs = [
    {
      name = "nfs-kernel-exports";

      job = ''
        description "export filesystems using kernel nfs"

        start on network-interfaces/started
        stop on network-interfaces/stop

        start script
	  export PATH=${pkgs.nfsUtils}/sbin
          ${modprobe}/sbin/modprobe nfsd || true
          exportfs -a
        end script

        respawn sleep 1000000

        start script
	  export PATH=${pkgs.nfsUtils}/sbin
          exportfs -au
        end script
      '';
    }
    {
      name = "nfs-kernel-rpc-nfsd";

      job = ''
        description "export filesystems using kernel nfs"

        start on nfs-kernel-exports/started
        stop on nfs-kernel-exports/stop

        respawn ${pkgs.nfsUtils}/sbin/rpc.nfsd ${if cfg.hostName != null then "-H ${cfg.hostName}" else ""} ${builtins.toString cfg.nproc}
      '';
    }
    {
      name = "nfs-kernel-mountd";

      job = ''
        description "export filesystems using kernel nfs"

        start on nfs-kernel-rpc-nfsd/started
        stop on nfs-kernel-exports/stop

        respawn ${pkgs.nfsUtils}/sbin/rpc.mountd -F -f ${exports}
      '';
    }
    ];
  };
}
