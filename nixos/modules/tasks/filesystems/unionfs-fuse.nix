{
  config,
  pkgs,
  lib,
  ...
}:

{
  config = lib.mkMerge [

    (lib.mkIf (config.boot.initrd.supportedFilesystems.unionfs-fuse or false) {
      boot.initrd.kernelModules = [ "fuse" ];

      boot.initrd.systemd.extraBin = {
        "mount.fuse" = "${pkgs.fuse}/bin/mount.fuse";
        "unionfs" = "${pkgs.unionfs-fuse}/bin/unionfs";
        "mount.unionfs-fuse" = pkgs.runCommand "mount.unionfs-fuse" { } ''
          substitute ${pkgs.unionfs-fuse}/sbin/mount.unionfs-fuse $out \
            --replace '${pkgs.bash}/bin/bash' /bin/sh \
            --replace '${pkgs.fuse}/sbin' /bin \
            --replace '${pkgs.unionfs-fuse}/bin' /bin
        '';
      };
    })

    (lib.mkIf (config.boot.supportedFilesystems.unionfs-fuse or false) {
      system.fsPackages = [ pkgs.unionfs-fuse ];
    })

  ];
}
