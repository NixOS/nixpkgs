{ config, pkgs, ... }:

with pkgs.lib;

{
  system.build.virtualBoxImage =
    pkgs.vmTools.runInLinuxVM (
      pkgs.runCommand "virtualbox-image"
        { memSize = 768;
          preVM =
            ''
              mkdir $out
              diskImage=$out/image
              ${pkgs.vmTools.qemu}/bin/qemu-img create -f raw $diskImage "10G"
              mv closure xchg/
            '';
          postVM =
            ''
              echo "creating VirtualBox disk image..."
              ${pkgs.vmTools.qemu}/bin/qemu-img convert -f raw -O vdi $diskImage $out/disk.vdi
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

          echo "filling Nix store..."
          mkdir -p /mnt/nix/store
          set -f
          cp -prvd $storePaths /mnt/nix/store/

          # Register the paths in the Nix database.
          printRegistration=1 perl ${pkgs.pathsFromGraph} /tmp/xchg/closure | \
              chroot /mnt ${config.nix.package}/bin/nix-store --load-db

          # Create the system profile to allow nixos-rebuild to work.
          chroot /mnt ${config.nix.package}/bin/nix-env \
              -p /nix/var/nix/profiles/system --set ${config.system.build.toplevel}

          # `nixos-rebuild' requires an /etc/NIXOS.
          mkdir -p /mnt/etc/nixos
          touch /mnt/etc/NIXOS

          # `switch-to-configuration' requires a /bin/sh
          mkdir -p /mnt/bin
          ln -s ${config.system.build.binsh}/bin/sh /mnt/bin/sh

          # Generate the GRUB menu.
          ln -s vda /dev/sda
          chroot /mnt ${config.system.build.toplevel}/bin/switch-to-configuration boot

          umount /mnt/proc /mnt/dev /mnt/sys
          umount /mnt
        ''
    );

  system.build.virtualBoxOVA = pkgs.runCommand "virtualbox-ova"
    { buildInputs = [ pkgs.linuxPackages.virtualbox ];
      vmName = "NixOS ${config.system.nixosVersion} (${pkgs.stdenv.system})";
      fileName = "nixos-${config.system.nixosVersion}-${pkgs.stdenv.system}.ova";
    }
    ''
      echo "creating VirtualBox VM..."
      export HOME=$PWD
      VBoxManage createvm --name "$vmName" --register \
        --ostype ${if pkgs.stdenv.system == "x86_64-linux" then "Linux26_64" else "Linux26"}
      VBoxManage modifyvm "$vmName" \
        --memory 1536 --acpi on --vram 10 \
        --nictype1 virtio --nic1 nat \
        --audiocontroller ac97 --audio alsa \
        --rtcuseutc on \
        --usb on --mouse usbtablet
      VBoxManage storagectl "$vmName" --name SATA --add sata --sataportcount 4 --bootable on --hostiocache on
      VBoxManage storageattach "$vmName" --storagectl SATA --port 0 --device 0 --type hdd \
        --medium ${config.system.build.virtualBoxImage}/disk.vdi

      echo "exporting VirtualBox VM..."
      mkdir -p $out
      VBoxManage export "$vmName" --output "$out/$fileName"
    '';

  fileSystems."/".device = "/dev/disk/by-label/nixos";

  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  services.virtualbox.enable = true;
}
