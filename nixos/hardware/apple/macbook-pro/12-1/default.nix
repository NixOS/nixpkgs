{ lib, ... }:

{
  imports = [
    ../.
    ../../../common/pc/laptop/ssd
    <nixpkgs/nixos/modules/hardware/network/broadcom-43xx.nix>
  ];

  # USB subsystem wakes up MBP right after suspend unless we disable it.
  services.udev.extraRules = lib.mkDefault ''
    SUBSYSTEM=="pci", KERNEL=="0000:00:14.0", ATTR{power/wakeup}="disabled"
  '';
}
