{ lib, ... }:

{
  imports = [ ../. ];

  boot.kernel.sysctl = {
    "vm.laptop_mode" = lib.mkDefault 5;
  };

  # TODO: fix in NixOS/nixpkgs
  # Disable governor set in hardware-configuration.nix,
  # required when services.tlp.enable is true:
  powerManagement.cpuFreqGovernor = lib.mkForce null;

  services.tlp.enable = lib.mkDefault true;
}
