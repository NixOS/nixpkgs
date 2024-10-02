{ config, pkgs, lib, ... }:

{
  config = lib.mkMerge [

    (lib.mkIf (config.boot.initrd.supportedFilesystems.unionfs-fuse or false) {
      boot.initrd.kernelModules = [ "fuse" ];

      boot.initrd.extraUtilsCommands = lib.mkIf (!config.boot.initrd.systemd.enable) ''
        copy_bin_and_libs ${pkgs.fuse}/sbin/mount.fuse
        copy_bin_and_libs ${pkgs.unionfs-fuse}/bin/unionfs
        substitute ${pkgs.unionfs-fuse}/sbin/mount.unionfs-fuse $out/bin/mount.unionfs-fuse \
          --replace '${pkgs.bash}/bin/bash' /bin/sh \
          --replace '${pkgs.fuse}/sbin' /bin \
          --replace '${pkgs.unionfs-fuse}/bin' /bin
        chmod +x $out/bin/mount.unionfs-fuse
      '';

      boot.initrd.postDeviceCommands = lib.mkIf (!config.boot.initrd.systemd.enable) ''
          # Hacky!!! fuse hard-codes the path to mount
          mkdir -p /nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-${pkgs.util-linux.name}-bin/bin
          ln -s $(which mount) /nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-${pkgs.util-linux.name}-bin/bin
          ln -s $(which umount) /nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-${pkgs.util-linux.name}-bin/bin
        '';

      boot.initrd.systemd.extraBin = {
        "mount.fuse" = "${pkgs.fuse}/bin/mount.fuse";
        "unionfs" = "${pkgs.unionfs-fuse}/bin/unionfs";
        "mount.unionfs-fuse" = pkgs.runCommand "mount.unionfs-fuse" {} ''
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
