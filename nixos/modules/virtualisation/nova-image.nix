{ config, pkgs, ... }:

with pkgs.lib;

{
  imports = [ ../profiles/qemu-guest.nix ../profiles/headless.nix ./ec2-data.nix ];

  system.build.novaImage =
    pkgs.vmTools.runInLinuxVM (
      pkgs.runCommand "nova-image"
        { preVM =
            ''
              mkdir $out
              diskImage=$out/image
              ${pkgs.vmTools.qemu}/bin/qemu-img create -f raw $diskImage "4G"
              mv closure xchg/
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
          ${pkgs.e2fsprogs}/sbin/mkfs.ext3 -L nixos /dev/vda1
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
              chroot /mnt ${config.nix.package}/bin/nix-store --load-db

          # Create the system profile to allow nixos-rebuild to work.
          chroot /mnt ${config.nix.package}/bin/nix-env \
              -p /nix/var/nix/profiles/system --set ${config.system.build.toplevel}

          # `nixos-rebuild' requires an /etc/NIXOS.
          mkdir -p /mnt/etc
          touch /mnt/etc/NIXOS

          # Install a configuration.nix.
          mkdir -p /mnt/etc/nixos
          cp ${./nova-config.nix} /mnt/etc/nixos/configuration.nix

          # Generate the GRUB menu.
          chroot /mnt ${config.system.build.toplevel}/bin/switch-to-configuration boot

          umount /mnt/proc /mnt/dev /mnt/sys
          umount /mnt
        ''
    );

  fileSystems."/".device = "/dev/disk/by-label/nixos";

  boot.kernelParams = [ "console=ttyS0" ];

  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.timeout = 0;

  # Put /tmp and /var on /ephemeral0, which has a lot more space.
  # Unfortunately we can't do this with the `fileSystems' option
  # because it has no support for creating the source of a bind
  # mount.  Also, "move" /nix to /ephemeral0 by layering a unionfs-fuse
  # mount on top of it so we have a lot more space for Nix operations.
  /*
  boot.initrd.postMountCommands =
    ''
      mkdir -m 1777 -p $targetRoot/ephemeral0/tmp
      mkdir -m 1777 -p $targetRoot/tmp
      mount --bind $targetRoot/ephemeral0/tmp $targetRoot/tmp

      mkdir -m 755 -p $targetRoot/ephemeral0/var
      mkdir -m 755 -p $targetRoot/var
      mount --bind $targetRoot/ephemeral0/var $targetRoot/var

      mkdir -p /unionfs-chroot/ro-nix
      mount --rbind $targetRoot/nix /unionfs-chroot/ro-nix

      mkdir -p /unionfs-chroot/rw-nix
      mkdir -m 755 -p $targetRoot/ephemeral0/nix
      mount --rbind $targetRoot/ephemeral0/nix /unionfs-chroot/rw-nix
      unionfs -o allow_other,cow,nonempty,chroot=/unionfs-chroot,max_files=32768 /rw-nix=RW:/ro-nix=RO $targetRoot/nix
    '';

    boot.initrd.supportedFilesystems = [ "unionfs-fuse" ];
    */

  # Since Nova allows VNC access to instances, it's nice to start to
  # start a few virtual consoles.
  services.mingetty.ttys = [ "tty1" "tty2" ];

  # Allow root logins only using the SSH key that the user specified
  # at instance creation time.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "without-password";
}
