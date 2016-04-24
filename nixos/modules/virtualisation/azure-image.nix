{ config, lib, pkgs, ... }:

with lib;
let
  diskSize = "30720";
in
{
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
              ${pkgs.vmTools.qemu-220}/bin/qemu-img create -f raw $diskImage $roundedsize
              mv closure xchg/
            '';

          postVM =
            ''
              mkdir -p $out
              ${pkgs.vmTools.qemu-220}/bin/qemu-img convert -f raw -O vpc $diskImage $out/disk.vhd
              rm $diskImage
            '';
          diskImageBase = "nixos-image-${config.system.nixosLabel}-${pkgs.stdenv.system}.raw";
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

          echo Register the paths in the Nix database.
          printRegistration=1 perl ${pkgs.pathsFromGraph} /tmp/xchg/closure | \
              chroot /mnt ${config.nix.package.out}/bin/nix-store --load-db --option build-users-group ""

          echo Create the system profile to allow nixos-rebuild to work.
          chroot /mnt ${config.nix.package.out}/bin/nix-env \
              -p /nix/var/nix/profiles/system --set ${config.system.build.toplevel} --option build-users-group ""

          echo nixos-rebuild requires an /etc/NIXOS.
          mkdir -p /mnt/etc
          touch /mnt/etc/NIXOS

          echo switch-to-configuration requires a /bin/sh
          mkdir -p /mnt/bin
          ln -s ${config.system.build.binsh}/bin/sh /mnt/bin/sh

          echo Install a configuration.nix.
          mkdir -p /mnt/etc/nixos /mnt/boot/grub
          cp ${./azure-config-user.nix} /mnt/etc/nixos/configuration.nix

          echo Generate the GRUB menu.
          ln -s vda /dev/sda
          chroot /mnt ${config.system.build.toplevel}/bin/switch-to-configuration boot

          echo Almost done
          umount /mnt/proc /mnt/dev /mnt/sys
          umount /mnt
        ''
    );

  imports = [ ./azure-common.nix ];

  # Azure metadata is available as a CD-ROM drive.
  fileSystems."/metadata".device = "/dev/sr0";

  systemd.services.fetch-ssh-keys =
    { description = "Fetch host keys and authorized_keys for root user";

      wantedBy = [ "sshd.service" "waagent.service" ];
      before = [ "sshd.service" "waagent.service" ];
      after = [ "local-fs.target" ];

      path  = [ pkgs.coreutils ];
      script =
        ''
          eval "$(cat /metadata/CustomData.bin)"
          if ! [ -z "$ssh_host_ecdsa_key" ]; then
            echo "downloaded ssh_host_ecdsa_key"
            echo "$ssh_host_ecdsa_key" > /etc/ssh/ssh_host_ed25519_key
            chmod 600 /etc/ssh/ssh_host_ed25519_key
          fi

          if ! [ -z "$ssh_host_ecdsa_key_pub" ]; then
            echo "downloaded ssh_host_ecdsa_key_pub"
            echo "$ssh_host_ecdsa_key_pub" > /etc/ssh/ssh_host_ed25519_key.pub
            chmod 644 /etc/ssh/ssh_host_ed25519_key.pub
          fi

          if ! [ -z "$ssh_root_auth_key" ]; then
            echo "downloaded ssh_root_auth_key"
            mkdir -m 0700 -p /root/.ssh
            echo "$ssh_root_auth_key" > /root/.ssh/authorized_keys
            chmod 600 /root/.ssh/authorized_keys
          fi
        '';
      serviceConfig.Type = "oneshot";
      serviceConfig.RemainAfterExit = true;
      serviceConfig.StandardError = "journal+console";
      serviceConfig.StandardOutput = "journal+console";
     };

}
