{ config, lib, pkgs, ... }:

with lib;
let
  diskSize = "4096";
in
{
  imports = [ ../profiles/headless.nix ];

  system.build.azureImage =
    pkgs.vmTools.runInLinuxVM (
      pkgs.runCommand "azure-image"
        { preVM =
            ''
              mkdir $out
              diskImage=$out/$diskImageBase

              cyl=$(((${diskSize}*1024*1024)/(512*63*255)))
              size=$(($cyl*255*63*512))              
              roundedsize=$((($size/(1024*1024)+1)*(1024*1024)))
              ${pkgs.vmTools.qemu}/bin/qemu-img create -f raw $diskImage $roundedsize
              mv closure xchg/
            '';

          postVM =
            ''
              mkdir -p $out
              ${pkgs.vmTools.qemu}/bin/qemu-img convert -f raw -O vpc $diskImage $out/disk.vhd
              rm $diskImage
            '';
          diskImageBase = "nixos-${config.system.nixosVersion}-${pkgs.stdenv.system}.raw";
          buildInputs = [ pkgs.utillinux pkgs.perl ];
          exportReferencesGraph =
            [ "closure" config.system.build.toplevel ];
        }
        ''
          # Create partition table
          ${pkgs.parted}/sbin/parted /dev/vda mklabel msdos
          ${pkgs.parted}/sbin/parted /dev/vda mkpart primary ext4 1 ${diskSize}M
          ${pkgs.parted}/sbin/parted /dev/vda print
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
          echo "copying everything (will take a while)..."
          cp -prd $storePaths /mnt/nix/store/

          # Register the paths in the Nix database.
          printRegistration=1 perl ${pkgs.pathsFromGraph} /tmp/xchg/closure | \
              chroot /mnt ${config.nix.package}/bin/nix-store --load-db

          # Create the system profile to allow nixos-rebuild to work.
          chroot /mnt ${config.nix.package}/bin/nix-env \
              -p /nix/var/nix/profiles/system --set ${config.system.build.toplevel}

          # `nixos-rebuild' requires an /etc/NIXOS.
          mkdir -p /mnt/etc
          touch /mnt/etc/NIXOS

          # `switch-to-configuration' requires a /bin/sh
          mkdir -p /mnt/bin
          ln -s ${config.system.build.binsh}/bin/sh /mnt/bin/sh

          # Install a configuration.nix.
          mkdir -p /mnt/etc/nixos /mnt/boot/grub
          cp ${./azure-config.nix} /mnt/etc/nixos/configuration.nix

          # Generate the GRUB menu.
          ln -s vda /dev/sda
          chroot /mnt ${config.system.build.toplevel}/bin/switch-to-configuration boot

          umount /mnt/proc /mnt/dev /mnt/sys
          umount /mnt
        ''
    );

  fileSystems."/".device = "/dev/disk/by-label/nixos";

  # Azure metadata is available as a CD-ROM drive.
  fileSystems."/metadata".device = "/dev/sr0";

  boot.kernelParams = [ "console=ttyS0" "earlyprintk=ttyS0" "rootdelay=300" "panic=1" "boot.panic_on_fail" ];
  boot.initrd.kernelModules = [ "hv_vmbus" "hv_netvsc" "hv_utils" "hv_storvsc" ];

  # Generate a GRUB menu. 
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.version = 2;
  boot.loader.grub.timeout = 0;

  # Don't put old configurations in the GRUB menu.  The user has no
  # way to select them anyway.
  boot.loader.grub.configurationLimit = 0;

  # Allow root logins only using the SSH key that the user specified
  # at instance creation time.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "without-password";

  # Force getting the hostname from Azure
  networking.hostName = mkDefault "";

  # Always include cryptsetup so that NixOps can use it.
  environment.systemPackages = [ pkgs.cryptsetup ];

  networking.usePredictableInterfaceNames = false;

  users.extraUsers.root.openssh.authorizedKeys.keys = [ (builtins.readFile <ssh-pub-key>) ];
}
