
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
          check = v: v != "/etc/exports"; # this won't work
          description = "
            the file listing the directories to be exported.
            install nfsUtils and run man exports to learn about its format.
            The exports setting can either be a file path or the file contents.
            Don't use /etc/exports. This won't work as nix will overwrite it.
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
	
	createMountPoints = mkOption {
	  default = false;
	  description = "Whether to create the mount points in the exports file at startup time.";
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

  environment.etc = [
    { source = exports;
      target = "exports"; }
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
	  export PATH=${pkgs.nfsUtils}/sbin:$PATH
	  mkdir -p /var/lib/nfs
          ${modprobe}/sbin/modprobe nfsd || true
	  
	  ${if cfg.createMountPoints == true then
	    ''
              # create export directories:
              # skip comments, take first col which may either be a quoted
              # "foo bar" or just foo (-> man export)
              sed '/^#.*/d;s/^"\([^"]*\)".*/\1/;t;s/[ ].*//' ${exports} \
              | xargs -d '\n' mkdir -p
	    ''
	    else ""}
	    	  
          # exports file is ${exports}
          # keep this comment so that this job is restarted whenever exports changes!
          exportfs -ra
        end script

        respawn sleep 1000000
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
    {
      name = "nfs-kernel-statd";
      
      job = ''
        description "NSM (Network Status Monitor) of the RPC protocol"
      
        start on nfs-kernel-rpc-nfsd/started
	stop on nfs-kernel-exports/stop
	
        start script
          mkdir -p /var/lib/nfs
        end script

        respawn ${pkgs.nfsUtils}/sbin/rpc.statd -F
      '';
    }
    ];
  };
}
