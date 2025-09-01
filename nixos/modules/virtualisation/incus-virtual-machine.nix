{
  config,
  lib,
  pkgs,
  ...
}:

let
  serialDevice = if pkgs.stdenv.hostPlatform.isx86 then "ttyS0" else "ttyAMA0";
in
{
  meta = {
    maintainers = lib.teams.lxc.members;
  };

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

    boot.kernelParams = [
      "console=tty1"
      "console=${serialDevice}"
    ];

    # CPU hotplug
    services.udev.extraRules = ''
      SUBSYSTEM=="cpu", CONST{arch}=="x86-64", TEST=="online", ATTR{online}=="0", ATTR{online}="1"
    '';

    virtualisation.incus.agent.enable = lib.mkDefault true;
  };
}
