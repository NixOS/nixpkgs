# Configuration for Amazon EC2 instances. (Note that this file is a
# misnomer - it should be "amazon-config.nix" or so, not
# "amazon-image.nix", since it's used not only to build images but
# also to reconfigure instances. However, we can't rename it because
# existing "configuration.nix" files on EC2 instances refer to it.)

{ config, lib, pkgs, ... }:

with lib;

let cfg = config.ec2; in

{
  imports = [ ../profiles/headless.nix ./ec2-data.nix ./amazon-grow-partition.nix ];

  config = {

    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      autoResize = true;
    };

    boot.initrd.kernelModules = [ "xen-blkfront" ];
    boot.kernelModules = [ "xen-netfront" ];
    boot.kernelParams = mkIf cfg.hvm [ "console=ttyS0" ];

    # Prevent the nouveau kernel module from being loaded, as it
    # interferes with the nvidia/nvidia-uvm modules needed for CUDA.
    boot.blacklistedKernelModules = [ "nouveau" ];

    # Generate a GRUB menu.  Amazon's pv-grub uses this to boot our kernel/initrd.
    boot.loader.grub.version = if cfg.hvm then 2 else 1;
    boot.loader.grub.device = if cfg.hvm then "/dev/xvda" else "nodev";
    boot.loader.grub.timeout = 0;
    boot.loader.grub.extraPerEntryConfig = "root (hd0${lib.optionalString cfg.hvm ",0"})";

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
    # by layering a unionfs-fuse mount on top of it so we have a lot more space for
    # Nix operations.
    boot.initrd.postMountCommands =
      ''
        diskNr=0
        diskForUnionfs=
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
                    if [ -z "$diskForUnionfs" ]; then diskForUnionfs="$mp"; fi
                fi
            else
                echo "skipping unknown device type $device"
            fi
        done

        if [ -n "$diskForUnionfs" ]; then
            mkdir -m 755 -p $targetRoot/$diskForUnionfs/root

            mkdir -m 1777 -p $targetRoot/$diskForUnionfs/root/tmp $targetRoot/tmp
            mount --bind $targetRoot/$diskForUnionfs/root/tmp $targetRoot/tmp

            if [ ! -e $targetRoot/.ebs ]; then
                mkdir -m 755 -p $targetRoot/$diskForUnionfs/root/var $targetRoot/var
                mount --bind $targetRoot/$diskForUnionfs/root/var $targetRoot/var

                mkdir -p /unionfs-chroot/ro-nix
                mount --rbind $targetRoot/nix /unionfs-chroot/ro-nix

                mkdir -m 755 -p $targetRoot/$diskForUnionfs/root/nix
                mkdir -p /unionfs-chroot/rw-nix
                mount --rbind $targetRoot/$diskForUnionfs/root/nix /unionfs-chroot/rw-nix

                unionfs -o allow_other,cow,nonempty,chroot=/unionfs-chroot,max_files=32768 /rw-nix=RW:/ro-nix=RO $targetRoot/nix
            fi
        fi
      '';

    boot.initrd.extraUtilsCommands =
      ''
        # We need swapon in the initrd.
        copy_bin_and_libs ${pkgs.utillinux}/sbin/swapon
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

    boot.initrd.supportedFilesystems = [ "unionfs-fuse" ];
  };
}
