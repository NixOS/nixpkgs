{ config, lib, pkgs, ... }:
with lib;
{
  imports = [ ../profiles/qemu-guest.nix ];

  services.openssh = {
    enable = true;

    settings.PermitRootLogin = "prohibit-password";
    settings.PasswordAuthentication = mkDefault false;
  };

  networking = {
    usePredictableInterfaceNames = false;
    useDHCP = false;
    interfaces.eth0 = {
      useDHCP = true;

      # Linode expects IPv6 privacy extensions to be disabled, so disable them
      # See: https://www.linode.com/docs/guides/manual-network-configuration/#static-vs-dynamic-addressing
      tempAddress = "disabled";
    };
  };

  # Install diagnostic tools for Linode support
  environment.systemPackages = with pkgs; [
    inetutils
    mtr
    sysstat
  ];

  fileSystems."/" = {
    fsType = "ext4";
    device = "/dev/sda";
    autoResize = true;
  };

  swapDevices = mkDefault [{ device = "/dev/sdb"; }];

  # Enable LISH and Linode Booting w/ GRUB
  boot = {
    # Add Required Kernel Modules
    # NOTE: These are not documented in the install guide
    initrd.availableKernelModules = [
      "virtio_pci"
      "virtio_scsi"
      "ahci"
      "sd_mod"
    ];

    # Set Up LISH Serial Connection
    kernelParams = [ "console=ttyS0,19200n8" ];
    kernelModules = [ "virtio_net" ];

    loader = {
      # Increase Timeout to Allow LISH Connection
      # NOTE: The image generator tries to set a timeout of 0, so we must force
      timeout = lib.mkForce 10;

      grub = {
        enable = true;
        forceInstall = true;
        device = "nodev";

        # Allow serial connection for GRUB to be able to use LISH
        extraConfig = ''
          serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1;
          terminal_input serial;
          terminal_output serial
        '';
      };
    };
  };
}
