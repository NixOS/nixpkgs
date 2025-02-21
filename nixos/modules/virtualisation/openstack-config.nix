{ config, pkgs, lib, ... }:

# image metadata:
# hw_firmware_type=uefi

let
  inherit (lib) mkIf mkDefault;
  cfg = config.openstack;
  metadataFetcher = import ./openstack-metadata-fetcher.nix {
    targetRoot = "/";
    wgetExtraOptions = "--retry-connrefused";
  };
in
{
  imports = [
    ../profiles/qemu-guest.nix

    # Note: While we do use the headless profile, we also explicitly
    # turn on the serial console on tty1 below.
    # Note that I could not find any documentation indicating tty1 was
    # the correct choice. I picked tty1 because that is what one
    # particular host was using.
    ../profiles/headless.nix

    # The Openstack Metadata service exposes data on an EC2 API also.
    ./ec2-data.nix
    ./amazon-init.nix
  ];

  config = {
    fileSystems."/" = mkIf (!cfg.zfs.enable) {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      autoResize = true;
    };

    fileSystems."/boot" = mkIf (cfg.efi || cfg.zfs.enable) {
      # The ZFS image uses a partition labeled ESP whether or not we're
      # booting with EFI.
      device = "/dev/disk/by-label/ESP";
      fsType = "vfat";
    };

    boot.growPartition = true;
    boot.kernelParams = [ "console=tty1" ];
    boot.loader.grub.device = if (!cfg.efi) then "/dev/vda" else "nodev";
    boot.loader.grub.efiSupport = cfg.efi;
    boot.loader.grub.efiInstallAsRemovable = cfg.efi;
    boot.loader.timeout = 1;
    boot.loader.grub.extraConfig = ''
      serial --unit=1 --speed=115200 --word=8 --parity=no --stop=1
      terminal_output console serial
      terminal_input console serial
    '';

    services.zfs.expandOnBoot = mkIf cfg.zfs.enable (lib.mkDefault "all");
    boot.zfs.devNodes = mkIf cfg.zfs.enable "/dev/";

    # Allow root logins
    services.openssh = {
      enable = true;
      settings.PermitRootLogin = "prohibit-password";
      settings.PasswordAuthentication = mkDefault false;
    };

    # Enable the serial console on tty1
    systemd.services."serial-getty@tty1".enable = true;

    # Force getting the hostname from Openstack metadata.
    networking.hostName = mkDefault "";

    systemd.services.openstack-init = {
      path = [ pkgs.wget ];
      description = "Fetch Metadata on startup";
      wantedBy = [ "multi-user.target" ];
      before = [ "apply-ec2-data.service" "amazon-init.service" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      script = metadataFetcher;
      restartIfChanged = false;
      unitConfig.X-StopOnRemoval = false;
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };
  };
}
