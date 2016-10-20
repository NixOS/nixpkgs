{ config, pkgs, ... }:

{
  imports =
    [ ../lib/kernel-version.nix
    ];

  ## BEGIN from generated hardware-configuration
  ## Probably better to just use a freshly generated hardware.configuration.nix
  ## than this, but including for reference.
  #imports =
  #  [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  #  ];
  #
  #boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "sd_mod" "sdhci_pci" ];
  #boot.kernelModules = [ "kvm-intel" "wl" ];
  #boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  #
  #nix.maxJobs = lib.mkDefault 8;
  ## END from generated hardware-configuration

  # Use the systemd-boot efi boot loader. (From default generated configuration.nix)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # I use this but not sure whether its needed.
  # Right click does *NOT* work
  services.xserver.libinput.enable = true;

  kernelAtleast =
    [ { version = "4.7"; msg = "Broadcom WiFi confirmed not to work."; }
    ];

  # Couldn't get X to work with nvidia
  # Also, PTYs don't work after X/nvidia starts
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.driSupport32Bit = true;

  # Seems to improve battery life *and* keep the CPU cooler
  services.mbpfan.enable = true;
}
