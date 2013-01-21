{ config, pkgs, ... }:

with pkgs.lib;

{
  system.build.virtualBoxImage =
    pkgs.vmTools.runInLinuxVM (
      pkgs.runCommand "virtualbox-image"
        { preVM =
            ''
              mkdir $out
              diskImage=$out/image
              ${pkgs.vmTools.kvm}/bin/qemu-img create -f raw $diskImage "10G"
              mv closure xchg/
            '';
          postVM =
            ''
              ${pkgs.vmTools.kvm}/bin/qemu-img convert -f raw -O vdi $diskImage $out/disk.vdi
              rm $diskImage
            '';
          buildInputs = [ pkgs.utillinux pkgs.perl ];
          exportReferencesGraph =
            [ "closure" config.system.build.toplevel ];
        }
        ''
          # Create a single / partition.
          ${pkgs.parted}/sbin/parted /dev/vda mklabel msdos
          ${pkgs.parted}/sbin/parted /dev/vda -- mkpart primary ext2 1M -1s
          . /sys/class/block/vda1/uevent
          mknod /dev/vda1 b $MAJOR $MINOR

          # Create an empty filesystem and mount it.
          ${pkgs.e2fsprogs}/sbin/mkfs.ext4 -L nixos /dev/vda1
          ${pkgs.e2fsprogs}/sbin/tune2fs -c 0 -i 0 /dev/vda1
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
              chroot /mnt ${config.environment.nix}/bin/nix-store --load-db

          # Create the system profile to allow nixos-rebuild to work.
          chroot /mnt ${config.environment.nix}/bin/nix-env \
              -p /nix/var/nix/profiles/system --set ${config.system.build.toplevel}

          # `nixos-rebuild' requires an /etc/NIXOS.
          mkdir -p /mnt/etc
          touch /mnt/etc/NIXOS

          # Install a configuration.nix.
          mkdir -p /mnt/etc/nixos
          cp ${./nova-config.nix} /mnt/etc/nixos/configuration.nix

          # `switch-to-configuration' requires a /bin/sh
          mkdir -p /mnt/bin
          ln -s ${config.system.build.binsh}/bin/sh /mnt/bin/sh

          # Generate the GRUB menu.
          chroot /mnt ${config.system.build.toplevel}/bin/switch-to-configuration boot

          umount /mnt/proc /mnt/dev /mnt/sys
          umount /mnt
        ''
    );

  fileSystems."/".device = "/dev/disk/by-label/nixos";

  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  services.virtualbox.enable = true;
}
