{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
      <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
      <nixpkgs/nixos/modules/profiles/clone-config.nix>
  ];

  # Images are provisioned independent of their data center location.
  flyingcircus.enc.parameters.location = "standalone";

  # Providing the expected device-indepentend symlink wasn't easily possible,
  # so we just start with the fixed known environment here.
  boot.loader.grub.device = lib.mkOverride 10 "/dev/vda";

  system.build.flyingcircusVMImage =
    pkgs.vmTools.runInLinuxVM (
      pkgs.runCommand "flyingcircus-image"
        { preVM =
            ''
              mkdir $out
              diskImage=$out/image.qcow2
              ${pkgs.vmTools.qemu}/bin/qemu-img create -f qcow2 $diskImage "10G"
              mv closure xchg/
            '';
          postVM = ''
              ${pkgs.bzip2}/bin/bzip2 $out/image.qcow2
            '';
          buildInputs = [ pkgs.utillinux pkgs.perl ];
          exportReferencesGraph =
            [ "closure" config.system.build.toplevel ];
        }
        ''
          # Create a root and bootloader partitions
          ${pkgs.gptfdisk}/sbin/sgdisk /dev/vda -o
          ${pkgs.gptfdisk}/sbin/sgdisk /dev/vda -a 8192 -n 1:8192:0 -c 1:root -t 1:8300
          ${pkgs.gptfdisk}/sbin/sgdisk /dev/vda -n 2:2048:+1M -c 2:gptbios -t 2:EF02
          . /sys/class/block/vda1/uevent
          mknod /dev/vda1 b $MAJOR $MINOR

          # Create an empty filesystem and mount it.
          ${pkgs.xfsprogs}/sbin/mkfs.xfs -m crc=1,finobt=1 -L root /dev/vda1
          mkdir /mnt
          mount /dev/vda1 /mnt

          # The initrd expects these directories to exist.
          mkdir /mnt/dev /mnt/proc /mnt/sys
          mount --bind /proc /mnt/proc
          mount --bind /dev /mnt/dev
          mount --bind /sys /mnt/sys

          # Copy all paths in the closure to the filesystem.
          storePaths=$(perl ${pkgs.pathsFromGraph} /tmp/xchg/closure)

          mkdir -p /mnt/nix/store
          ${pkgs.rsync}/bin/rsync -av $storePaths /mnt/nix/store/

          # Register the paths in the Nix database.
          printRegistration=1 perl ${pkgs.pathsFromGraph} /tmp/xchg/closure | \
              chroot /mnt ${config.nix.package}/bin/nix-store --load-db --option build-users-group ""

          # Create the system profile to allow nixos-rebuild to work.
          chroot /mnt ${config.nix.package}/bin/nix-env --option build-users-group "" \
              -p /nix/var/nix/profiles/system --set ${config.system.build.toplevel}

          # `nixos-rebuild' requires an /etc/NIXOS.
          mkdir -p /mnt/etc
          touch /mnt/etc/NIXOS

          # `switch-to-configuration' requires a /bin/sh
          mkdir -p /mnt/bin
          ln -s ${config.system.build.binsh}/bin/sh /mnt/bin/sh

          # Install our local, unmanaged configuration template.
          mkdir -p /mnt/etc/nixos
          cp ${../files/etc_nixos_local.nix} /mnt/etc/nixos/local.nix
          chmod u+rw /mnt/etc/nixos/local.nix

          # Generate the GRUB menu.
          chroot /mnt ${config.system.build.toplevel}/bin/switch-to-configuration boot

          umount /mnt/proc /mnt/dev /mnt/sys
          umount /mnt
        ''
    );

}
