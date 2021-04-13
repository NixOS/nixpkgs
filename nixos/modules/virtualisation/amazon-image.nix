# Configuration for Amazon EC2 instances. (Note that this file is a
# misnomer - it should be "amazon-config.nix" or so, not
# "amazon-image.nix", since it's used not only to build images but
# also to reconfigure instances. However, we can't rename it because
# existing "configuration.nix" files on EC2 instances refer to it.)

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.ec2;
  metadataFetcher = import ./ec2-metadata-fetcher.nix {
    inherit (pkgs) curl;
    targetRoot = "$targetRoot/";
    wgetExtraOptions = "-q";
  };
in

{
  imports = [ ../profiles/headless.nix ./ec2-data.nix ./amazon-init.nix ];

  config = {

    assertions = [
      { assertion = cfg.hvm;
        message = "Paravirtualized EC2 instances are no longer supported.";
      }
      { assertion = cfg.efi -> cfg.hvm;
        message = "EC2 instances using EFI must be HVM instances.";
      }
    ];

    boot.growPartition = cfg.hvm;

    fileSystems."/" = mkIf (!cfg.zfsRoot) {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      autoResize = true;
    };

    fileSystems."/boot" = if cfg.efi then {
      device = "/dev/disk/by-label/ESP";
      fsType = "vfat";
    } else if cfg.zfsRoot then {
      device = "boot/boot";
      fsType = "zfs";
    } else {};

    boot.zfs.devNodes = mkIf cfg.zfsRoot "/dev/";

    boot.extraModulePackages = [
      config.boot.kernelPackages.ena
    ];
    boot.initrd.kernelModules = [ "xen-blkfront" "xen-netfront" ];
    boot.initrd.availableKernelModules = [ "ixgbevf" "ena" "nvme" ];
    boot.kernelParams = mkIf cfg.hvm [ "console=ttyS0,115200n8" "random.trust_cpu=on" ];

    # Prevent the nouveau kernel module from being loaded, as it
    # interferes with the nvidia/nvidia-uvm modules needed for CUDA.
    # Also blacklist xen_fbfront to prevent a 30 second delay during
    # boot.
    boot.blacklistedKernelModules = [ "nouveau" "xen_fbfront" ];

    # Generate a GRUB menu.  Amazon's pv-grub uses this to boot our kernel/initrd.
    boot.loader.grub.version = if cfg.hvm then 2 else 1;
    boot.loader.grub.device = if (cfg.hvm && !cfg.efi) then "/dev/xvda" else "nodev";
    boot.loader.grub.extraPerEntryConfig = mkIf (!cfg.hvm) "root (hd0)";
    boot.loader.grub.efiSupport = cfg.efi;
    boot.loader.grub.efiInstallAsRemovable = cfg.efi;
    boot.loader.timeout = 0;

    boot.initrd.network.enable = true;
    boot.initrd.postDeviceCommands = lib.mkMerge [
      (lib.mkBefore ''
        (
          set -x
          PATH=${pkgs.jq}/bin/:${pkgs.cloud-utils}/bin/:$PATH
          lsblk --json -O --all \
            | jq -cf ${./amazon-image-zfs.jq} \
            | (while read -r line; do
                part_path=$(echo "$line" | jq -r .part_path);
                disk_path=$(echo "$line" | jq -r .disk_path);
                growpart "$disk_path" "$(cat "$part_path")";
              done)
        )
      '')
      # zfs mounts within postDeviceCommands so mkBefore and mkAfter must be used
      (lib.mkAfter ''
        (
          set -x
          for pool in $(zpool list -H | awk '{print $1}'); do
            for vdev in $(zpool list -vLPH "$pool" | awk '($1 ~ "^/dev" && $10 = "ONLINE") {print $1;}'); do
              zpool online -e "$pool" "$vdev";
            done
          done
        )
      '')
    ];

    # Mount all formatted ephemeral disks and activate all swap devices.
    # We cannot do this with the ‘fileSystems’ and ‘swapDevices’ options
    # because the set of devices is dependent on the instance type
    # (e.g. "m1.small" has one ephemeral filesystem and one swap device,
    # while "m1.large" has two ephemeral filesystems and no swap
    # devices).  Also, put /tmp and /var on /disk0, since it has a lot
    # more space than the root device.  Similarly, "move" /nix to /disk0
    # by layering a unionfs-fuse mount on top of it so we have a lot more space for
    # Nix operations.
    boot.initrd.postMountCommands =
      ''
        ${metadataFetcher}

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

            if [ "$(cat "$metaDir/ami-manifest-path")" != "(unknown)" ]; then
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
        copy_bin_and_libs ${pkgs.util-linux}/sbin/swapon
      '';

    # Don't put old configurations in the GRUB menu.  The user has no
    # way to select them anyway.
    boot.loader.grub.configurationLimit = 0;

    # Allow root logins only using the SSH key that the user specified
    # at instance creation time.
    services.openssh.enable = true;
    services.openssh.permitRootLogin = "prohibit-password";

    # Creates symlinks for block device names.
    services.udev.packages = [ pkgs.ec2-utils ];

    # Force getting the hostname from EC2.
    networking.hostName = mkDefault "";

    # Always include cryptsetup so that Charon can use it.
    environment.systemPackages = [ pkgs.cryptsetup ];

    boot.initrd.supportedFilesystems = [ "unionfs-fuse" ];

    # EC2 has its own NTP server provided by the hypervisor
    networking.timeServers = [ "169.254.169.123" ];

    # udisks has become too bloated to have in a headless system
    # (e.g. it depends on GTK).
    services.udisks2.enable = false;
  };
}
