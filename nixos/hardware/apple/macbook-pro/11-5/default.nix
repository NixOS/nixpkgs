{ lib, config, pkgs, ... }:

let

  kernelPackages = config.boot.kernelPackages;

in

{
  imports = [
    ../.
    ../../../common/pc/laptop/ssd
    <nixpkgs/nixos/modules/hardware/network/broadcom-43xx.nix>
  ];

  # Apparently this is currently only supported by ati_unfree drivers, not ati
  hardware.opengl.driSupport32Bit = false;

  services.xserver.videoDrivers = [ "ati" ];

  services.udev.extraRules =
    # Disable XHC1 wakeup signal to avoid resume getting triggered some time
    # after suspend. Reboot required for this to take effect.
    lib.optionalString
      (lib.versionAtLeast kernelPackages.kernel.version "3.13")
      ''SUBSYSTEM=="pci", KERNEL=="0000:00:14.0", ATTR{power/wakeup}="disabled"'';
}
