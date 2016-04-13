{ config, pkgs, lib, ... }:

{
  config = lib.mkMerge [

    (lib.mkIf (lib.any (fs: fs == "unionfs-fuse") config.boot.initrd.supportedFilesystems) {
      boot.initrd.kernelModules = [ "fuse" ];

      boot.initrd.extraUtilsCommands = ''
        copy_bin_and_libs ${pkgs.fuse}/sbin/mount.fuse
        copy_bin_and_libs ${pkgs.unionfs-fuse}/bin/unionfs
        substitute ${pkgs.unionfs-fuse}/sbin/mount.unionfs-fuse $out/bin/mount.unionfs-fuse \
          --replace '${pkgs.bash}/bin/bash' /bin/sh \
          --replace '${pkgs.fuse}/sbin' /bin \
          --replace '${pkgs.unionfs-fuse}/bin' /bin
        chmod +x $out/bin/mount.unionfs-fuse
      '';

      boot.initrd.postDeviceCommands = ''
          # Hacky!!! fuse hard-codes the path to mount
          mkdir -p /nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-${pkgs.utillinux.name}-bin/bin
          ln -s $(which mount) /nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-${pkgs.utillinux.name}-bin/bin
          ln -s $(which umount) /nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-${pkgs.utillinux.name}-bin/bin
        '';
    })

    (lib.mkIf (lib.any (fs: fs == "unionfs-fuse") config.boot.supportedFilesystems) {
      system.fsPackages = [ pkgs.unionfs-fuse ];
    })

  ];
}
