# This module defines the software packages included in the "minimal"
# installation CD.  It might be useful elsewhere.

{ config, pkgs, ... }:

{
  # Include some utilities that are useful for installing or repairing
  # the system.
  environment.systemPackages = [
    pkgs.subversion # for nixos-checkout
    pkgs.w3m # needed for the manual anyway
    pkgs.testdisk # useful for repairing boot problems
    pkgs.mssys # for writing Microsoft boot sectors / MBRs
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

    # Tools to create / manipulate filesystems.
    pkgs.ntfsprogs # for resizing NTFS partitions
    pkgs.dosfstools
    pkgs.xfsprogs
    pkgs.jfsutils
    pkgs.jfsrec

    # Some compression/archiver tools.
    pkgs.unrar
    pkgs.unzip
    pkgs.zip
    pkgs.xz
    pkgs.dar # disk archiver
    pkgs.cabextract

    # Some editors.
    pkgs.vim
    pkgs.bvi # binary editor
    pkgs.joe
  ];

  # Include support for various filesystems.
  boot.supportedFilesystems = [ "btrfs" "reiserfs" "vfat" ];

}
