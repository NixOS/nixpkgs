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

    systemd.services.statd =
      { description = "NFSv3 Network Status Monitor";

        path = [ pkgs.nfsUtils pkgs.sysvtools pkgs.utillinux ];

        wantedBy = [ "network-online.target" "multi-user.target" ];
        before = [ "network-online.target" ];
        requires = [ "basic.target" "rpcbind.service" ];
        after = [ "basic.target" "rpcbind.service" "network.target" ];

        unitConfig.DefaultDependencies = false; # don't stop during shutdown

        preStart =
          ''
            mkdir -p ${nfsStateDir}/sm
            mkdir -p ${nfsStateDir}/sm.bak
            sm-notify -d
          '';

        serviceConfig.Type = "forking";
        serviceConfig.ExecStart = "@${pkgs.nfsUtils}/sbin/rpc.statd rpc.statd --no-notify";
        serviceConfig.Restart = "always";
      };

    systemd.services.idmapd =
      { description = "NFSv4 ID Mapping Daemon";

        path = [ pkgs.sysvtools pkgs.utillinux ];

        wantedBy = [ "network-online.target" "multi-user.target" ];
        before = [ "network-online.target" ];
        requires = [ "rpcbind.service" ];
        after = [ "rpcbind.service" ];

        preStart =
          ''
            mkdir -p ${rpcMountpoint}
            mount -t rpc_pipefs rpc_pipefs ${rpcMountpoint}
          '';

        postStop =
          ''
            umount ${rpcMountpoint}
          '';

        serviceConfig.Type = "forking";
        serviceConfig.ExecStart = "@${pkgs.nfsUtils}/sbin/rpc.idmapd rpc.idmapd -c ${idmapdConfFile}";
        serviceConfig.Restart = "always";
      };

  };
}
