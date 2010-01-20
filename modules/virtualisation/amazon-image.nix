{ config, pkgs, ... }:

with pkgs.lib;

{
  system.build.ext2Image =
    pkgs.vmTools.runInLinuxVM (
      pkgs.runCommand "amazon-image"
        { preVM =
            ''
              mkdir $out
              diskImage=$out/nixos.img
              qemu-img create -f raw $diskImage "1024M"
            '';
          buildInputs = [ pkgs.utillinux pkgs.perl pkgs.rsync ];
          exportReferencesGraph = 
            [ "closure" config.system.build.toplevel ];
        }
        ''
          # Create an empty filesysten and mount it.
          ${pkgs.e2fsprogs}/sbin/mkfs.ext3 /dev/vda
          mkdir /mnt
          mount /dev/vda /mnt

          # Copy all paths in the closure to the filesystem.
          storePaths=$(perl ${pkgs.pathsFromGraph} $ORIG_TMPDIR/closure)

          mkdir -p /mnt/nix/store
          rsync -av $storePaths /mnt/nix/store/

          # Amazon assumes that there is a /sbin/init, so symlink it
          # to the stage 2 init script.  Since we cannot set the path
          # to the system configuration via the systemConfig kernel
          # parameter, use a /system symlink.
          mkdir -p /mnt/sbin
          ln -s ${config.system.build.bootStage2} /mnt/sbin/init
          ln -s ${config.system.build.toplevel} /mnt/system

          umount /mnt
        ''
    );

}
