{ config, pkgs, ... }:

{
  imports =
    [ ../lib/kernel-version.nix
    ];

  ## BEGIN from generated hardware-configuration
  ## Probably better to just use a freshly generated hardware.configuration.nix
  ## than this, but including for reference.
  # boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  # boot.kernelModules = [ "kvm-intel" ];
  # boot.extraModulePackages = [  ];
  #
  #
  # nix.maxJobs = lib.mkDefault 4;
  ## END from generated hardware-configuration

  # Use the gummiboot efi boot loader. (From default generated configuration.nix)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_T460s
  kernelAtleast = [
    { version = "4.5.1"; msg = "The physical mouse buttons works incorrectly."; }
    { version = "4.6";   msg = "Suspending the T460s by closing the lid when running on battery causes the machine to freeze up entirely."; }
  ];

  hardware.enableAllFirmware = true;
}
