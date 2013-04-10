{ config, pkgs, ... }:

{
  config = pkgs.lib.mkMerge [
    (pkgs.lib.mkIf (pkgs.lib.any (fs: fs == "unionfs-fuse") config.boot.initrd.supportedFilesystems) {
      boot.initrd.kernelModules = [ "fuse" ];
  
      boot.initrd.extraUtilsCommands = ''
        cp -v ${pkgs.fuse}/lib/libfuse* $out/lib
        cp -v ${pkgs.unionfs-fuse}/bin/unionfs $out/bin
      '';
  
      boot.initrd.postDeviceCommands = ''
          # Hacky!!! fuse hard-codes the path to mount
          mkdir -p /nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-${pkgs.utillinux.name}/bin
          ln -s $(which mount) /nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-${pkgs.utillinux.name}/bin
          ln -s $(which umount) /nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-${pkgs.utillinux.name}/bin
        '';
    })
    (pkgs.lib.mkIf (pkgs.lib.any (fs: fs == "unionfs-fuse") config.boot.supportedFilesystems) {
      system.fsPackages = [ pkgs.unionfs-fuse ];
    })
  ];
}
