{ config, lib, pkgs, ... }:

let
  cfg = config.oci;
in
{
  imports = [ ../profiles/qemu-guest.nix ];

  # Taken from /proc/cmdline of Ubuntu 20.04.2 LTS on OCI
  boot.kernelParams = [
    "nvme.shutdown_timeout=10"
    "nvme_core.shutdown_timeout=10"
    "libiscsi.debug_libiscsi_eh=1"
    "crash_kexec_post_notifiers"

    # VNC console
    "console=tty1"

    # x86_64-linux
    "console=ttyS0"

    # aarch64-linux
    "console=ttyAMA0,115200"
  ];

  boot.growPartition = true;

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
    autoResize = true;
  };

  fileSystems."/boot" = lib.mkIf cfg.efi {
    device = "/dev/disk/by-label/ESP";
    fsType = "vfat";
  };

  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.grub = {
    device = if cfg.efi then "nodev" else "/dev/sda";
    splashImage = null;
    extraConfig = ''
      serial --unit=0 --speed=115200 --word=8 --parity=no --stop=1
      terminal_input --append serial
      terminal_output --append serial
    '';
    efiInstallAsRemovable = cfg.efi;
    efiSupport = cfg.efi;
  };

  # https://docs.oracle.com/en-us/iaas/Content/Compute/Tasks/configuringntpservice.htm#Configuring_the_Oracle_Cloud_Infrastructure_NTP_Service_for_an_Instance
  networking.timeServers = [ "169.254.169.254" ];

  services.openssh.enable = true;

  # Otherwise the instance may not have a working network-online.target,
  # making the fetch-ssh-keys.service fail
  networking.useNetworkd = lib.mkDefault true;
}
