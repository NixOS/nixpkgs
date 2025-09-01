# This module defines the software packages included in the "minimal"
# installation CD. It might be useful elsewhere.

{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Include some utilities that are useful for installing or repairing
  # the system.
  environment.systemPackages = [
    pkgs.w3m-nographics # needed for the manual anyway
    pkgs.testdisk # useful for repairing boot problems
    pkgs.ms-sys # for writing Microsoft boot sectors / MBRs
    pkgs.efibootmgr
    pkgs.efivar
    pkgs.parted
    pkgs.gptfdisk
    pkgs.ddrescue
    pkgs.ccrypt
    pkgs.cryptsetup # needed for dm-crypt volumes

    # Some text editors.
    pkgs.vim

    # Some networking tools.
    pkgs.fuse
    pkgs.fuse3
    pkgs.sshfs-fuse
    pkgs.socat
    pkgs.screen
    pkgs.tcpdump

    # Hardware-related tools.
    pkgs.sdparm
    pkgs.hdparm
    pkgs.smartmontools # for diagnosing hard disks
    pkgs.pciutils
    pkgs.usbutils
    pkgs.nvme-cli

    # Some compression/archiver tools.
    pkgs.unzip
    pkgs.zip

    # Some utilities
    pkgs.jq
  ];

  # Include support for various filesystems and tools to create / manipulate them.
  boot.supportedFilesystems = lib.mkMerge [
    [
      "btrfs"
      "cifs"
      "f2fs"
      "ntfs"
      "vfat"
      "xfs"
    ]
    (lib.mkIf (lib.meta.availableOn pkgs.stdenv.hostPlatform config.boot.zfs.package) {
      zfs = lib.mkDefault true;
    })
  ];

  # Configure host id for ZFS to work
  networking.hostId = lib.mkDefault "8425e349";
}
