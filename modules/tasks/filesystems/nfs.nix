{ config, pkgs, ... }:

with pkgs.lib;

let

  inInitrd = any (fs: fs == "nfs") config.boot.initrd.supportedFilesystems;

  nfsStateDir = "/var/lib/nfs";

  rpcMountpoint = "${nfsStateDir}/rpc_pipefs";

  idmapdConfFile = pkgs.writeText "idmapd.conf" ''
    [General]
    Pipefs-Directory = ${rpcMountpoint}
    ${optionalString (config.networking.domain != "")
      "Domain = ${config.networking.domain}"}

    [Mapping]
    Nobody-User = nobody
    Nobody-Group = nogroup

    [Translation]
    Method = nsswitch
  '';

in

{

  ###### implementation

  config = mkIf (any (fs: fs == "nfs" || fs == "nfs4") config.boot.supportedFilesystems) {

    services.rpcbind.enable = true;
    
    system.fsPackages = [ pkgs.nfsUtils ];

    boot.kernelModules = [ "sunrpc" ];

    boot.initrd.kernelModules = mkIf inInitrd [ "nfs" ];

    # Ensure that statd and idmapd are started before mountall.
    jobs.mountall.preStart =
      ''
        ensure statd || true
        ensure idmapd || true
      '';

    jobs.statd =
      { description = "Kernel NFS server - Network Status Monitor";

        path = [ pkgs.nfsUtils pkgs.sysvtools pkgs.utillinux ];

        stopOn = ""; # needed during shutdown

        preStart =
          ''
            ensure rpcbind
            mkdir -p ${nfsStateDir}/sm
            mkdir -p ${nfsStateDir}/sm.bak
            sm-notify -d
          '';

        daemonType = "fork";

        exec = "rpc.statd --no-notify";
      };

    jobs.idmapd =
      { description = "NFS ID mapping daemon";

        path = [ pkgs.nfsUtils pkgs.sysvtools pkgs.utillinux ];

        startOn = "started udev";

        preStart =
          ''
            ensure rpcbind
            mkdir -p ${rpcMountpoint}
            mount -t rpc_pipefs rpc_pipefs ${rpcMountpoint}
          '';

        postStop =
          ''
            umount ${rpcMountpoint}
          '';

        daemonType = "fork";

        exec = "rpc.idmapd -v -c ${idmapdConfFile}";
      };

  };
}
