{ config, lib, pkgs, ... }:

let
  serialDevice =
    if pkgs.stdenv.hostPlatform.isx86
    then "ttyS0"
    else "ttyAMA0"; # aarch64
in {
  imports = [
    ./lxc-instance-common.nix

    ../profiles/qemu-guest.nix
  ];

  config = {
    system.build.qemuImage = import ../../lib/make-disk-image.nix {
      inherit pkgs lib config;

      partitionTableType = "efi";
      format = "qcow2-compressed";
      copyChannel = true;
    };

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-label/nixos";
        autoResize = true;
        fsType = "ext4";
      };
      "/boot" = {
        device = "/dev/disk/by-label/ESP";
        fsType = "vfat";
      };
    };

    boot.growPartition = true;
    boot.loader.systemd-boot.enable = true;

    # image building needs to know what device to install bootloader on
    boot.loader.grub.device = "/dev/vda";

    boot.kernelParams = ["console=tty1" "console=${serialDevice}"];

    virtualisation.lxd.agent.enable = lib.mkDefault true;
  };
}
