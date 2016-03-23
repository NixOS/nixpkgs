{ config, pkgs, ... }:

{
  imports =
    [ ../lib/kernel-version.nix
    ];

  ## BEGIN from generated hardware-configuration
  ## Probably better to just use a freshly generated hardware.configuration.nix
  ## than this, but including for reference.
  #imports =
  #  [ <nixos/modules/hardware/network/broadcom-43xx.nix>
  #    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  #  ];
  #
  #boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "rtsx_pci_sdmmc" ];
  #boot.kernelModules = [ "kvm-intel" ];
  #boot.extraModulePackages = [ ];
  #
  #nix.maxJobs = 8;
  ## END from generated hardware-configuration

  # Use the gummiboot efi boot loader. (From default generated configuration.nix)
  boot.loader.gummiboot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Honestly forget if needed or just better for touchpad.
  # Synaptics also works, but doesn't have working palm and thumb detection.
  services.xserver.libinput.enable = true;

  # Intel Graphics confirmed not working at 4.1, confirmed working at {4.3, 4.4}
  kernelAtleast =
    [ { version = "4.2"; msg = "Intel Graphics confirmed not to work."; }
      { version = "4.3"; msg = "Intel Graphics untested."; }
      { version = "4.4"; msg = "Touchpad does not work, though the touchscreen still does"; }
    ];

  # To just use intel integrated graphics with Intel's open source driver
  # hardware.nvidiaOptimus.disable = true;
}
