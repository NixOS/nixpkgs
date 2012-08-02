{ config, pkgs, ... }:

with pkgs.lib;

{
  require = [ ../profiles/headless.nix ./ec2-data.nix ];

  system.build.amazonImage =
    pkgs.vmTools.runInLinuxVM (
      pkgs.runCommand "amazon-image"
        { preVM =
            ''
              mkdir $out
              diskImage=$out/nixos.img
              ${pkgs.vmTools.kvm}/bin/qemu-img create -f raw $diskImage "4G"
              mv closure xchg/
            '';
          buildInputs = [ pkgs.utillinux pkgs.perl ];
          exportReferencesGraph =
            [ "closure" config.system.build.toplevel ];
        }
        ''
          # Create an empty filesystem and mount it.
          ${pkgs.e2fsprogs}/sbin/mkfs.ext3 -L nixos /dev/vda
          ${pkgs.e2fsprogs}/sbin/tune2fs -c 0 -i 0 /dev/vda
          mkdir /mnt
          mount /dev/vda /mnt

          # The initrd expects these directories to exist.
          mkdir /mnt/dev /mnt/proc /mnt/sys

          mount -o bind /proc /mnt/proc

          # Copy all paths in the closure to the filesystem.
          storePaths=$(perl ${pkgs.pathsFromGraph} /tmp/xchg/closure)

          mkdir -p /mnt/nix/store
          echo "copying everything (will take a while)..."
          cp -prd $storePaths /mnt/nix/store/

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
          cp ${./amazon-config.nix} /mnt/etc/nixos/configuration.nix

          # Generate the GRUB menu.
          chroot /mnt ${config.system.build.toplevel}/bin/switch-to-configuration boot

          umount /mnt/proc
          umount /mnt
        ''
    );

  fileSystems =
    [ { mountPoint = "/";
        device = "/dev/disk/by-label/nixos";
      }
    ];

  boot.initrd.kernelModules = [ "xen-blkfront" "aufs" ];
  boot.kernelModules = [ "xen-netfront" ];

  boot.extraModulePackages = [ config.boot.kernelPackages.aufs ];

  # Generate a GRUB menu.  Amazon's pv-grub uses this to boot our kernel/initrd.
  boot.loader.grub.device = "nodev";
  boot.loader.grub.timeout = 0;
  boot.loader.grub.extraPerEntryConfig = "root (hd0)";

  boot.initrd.postDeviceCommands =
    ''
      # Force udev to exit to prevent random "Device or resource busy
      # while trying to open /dev/xvda" errors from fsck.
      udevadm control --exit || true
      kill -9 -1
    '';
    
  # Mount all formatted ephemeral disks and activate all swap devices.
  # We cannot do this with the ‘fileSystems’ and ‘swapDevices’ options
  # because the set of devices is dependent on the instance type
  # (e.g. "m1.large" has one ephemeral filesystem and one swap device,
  # while "m1.large" has two ephemeral filesystems and no swap
  # devices).  Also, put /tmp and /var on /disk0, since it has a lot
  # more space than the root device.  Similarly, "move" /nix to /disk0
  # by layering an AUFS on top of it so we have a lot more space for
  # Nix operations.
  boot.initrd.postMountCommands =
    ''
      diskNr=0
      diskForAufs=
      for device in /dev/xvd[abcde]*; do
          if [ "$device" = /dev/xvda -o "$device" = /dev/xvda1 ]; then continue; fi
          fsType=$(blkid -o value -s TYPE "$device" || true)
          if [ "$fsType" = swap ]; then
              echo "activating swap device $device..."
              swapon "$device" || true
          elif [ "$fsType" = ext3 ]; then
              mp="/disk$diskNr"
              diskNr=$((diskNr + 1))
              echo "mounting $device on $mp..."
              if mountFS "$device" "$mp" "" ext3; then
                  if [ -z "$diskForAufs" ]; then diskForAufs="$mp"; fi
              fi
          else
              echo "skipping unknown device type $device"
          fi
      done

      if [ -n "$diskForAufs" ]; then
          mkdir -m 755 -p $targetRoot/$diskForAufs/root

          mkdir -m 1777 -p $targetRoot/$diskForAufs/root/tmp $targetRoot/tmp
          mount --bind $targetRoot/$diskForAufs/root/tmp $targetRoot/tmp

          if [ ! -e $targetRoot/.ebs ]; then
              mkdir -m 755 -p $targetRoot/$diskForAufs/root/var $targetRoot/var
              mount --bind $targetRoot/$diskForAufs/root/var $targetRoot/var

              mkdir -m 755 -p $targetRoot/$diskForAufs/root/nix
              mount -t aufs -o dirs=$targetRoot/$diskForAufs/root/nix=rw:$targetRoot/nix=rr none $targetRoot/nix
          fi
      fi
    '';

  boot.initrd.extraUtilsCommands =
    ''
      # We need swapon in the initrd.
      cp ${pkgs.utillinux}/sbin/swapon $out/bin
    '';

  # Don't put old configurations in the GRUB menu.  The user has no
  # way to select them anyway.
  boot.loader.grub.configurationLimit = 0;

  # Allow root logins only using the SSH key that the user specified
  # at instance creation time.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "without-password";

  # Force getting the hostname from EC2.
  networking.hostName = mkDefault "";

  # Always include cryptsetup so that Charon can use it.
  environment.systemPackages = [ pkgs.cryptsetup ];
}
