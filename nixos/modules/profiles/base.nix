# This module defines the software packages included in the "minimal"
# installation CD.  It might be useful elsewhere.

{ config, lib, pkgs, ... }:

{
  # Include some utilities that are useful for installing or repairing
  # the system.
  environment.systemPackages = [
    pkgs.w3m # needed for the manual anyway
    pkgs.testdisk # useful for repairing boot problems
    pkgs.mssys # for writing Microsoft boot sectors / MBRs
    pkgs.efibootmgr
    pkgs.efivar
    pkgs.parted
    pkgs.gptfdisk
    pkgs.ddrescue
    pkgs.ccrypt
    pkgs.cryptsetup # needed for dm-crypt volumes

    # Some networking tools.
    pkgs.fuse
    pkgs.sshfsFuse
    pkgs.socat
    pkgs.screen

    # Hardware-related tools.
    pkgs.sdparm
    pkgs.hdparm
    pkgs.dmraid
    pkgs.smartmontools # for diagnosing hard disks
    pkgs.pciutils
    pkgs.usbutils

    # Tools to create / manipulate filesystems.
    pkgs.ntfsprogs # for resizing NTFS partitions
    pkgs.dosfstools
    pkgs.xfsprogs.bin
    pkgs.jfsutils
    pkgs.f2fs-tools

    # Some compression/archiver tools.
    pkgs.unzip
    pkgs.zip
    pkgs.dar # disk archiver
    pkgs.cabextract
  ];

  # Include support for various filesystems.
  boot.supportedFilesystems = [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "zfs" "ntfs" "cifs" ];

  # Configure host id for ZFS to work
  networking.hostId = lib.mkDefault "8425e349";
}
