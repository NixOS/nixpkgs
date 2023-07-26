{ config, lib, pkgs, ... }:

{
  imports = [
    ../profiles/qemu-guest.nix
  ];

  config = {
    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      autoResize = true;
    };

    boot.growPartition = true;
    boot.kernelParams = [ "console=ttyS0" ];
    boot.loader.grub.device = "/dev/vda";
    boot.loader.timeout = 0;

    services.qemuGuest.enable = true;
    services.openssh.enable = true;
    services.cloud-init.enable = true;
    systemd.services."serial-getty@ttyS0".enable = true;

    system.build.kubevirtImage = import ../../lib/make-disk-image.nix {
      inherit lib config pkgs;
      format = "qcow2";
    };
  };
}
