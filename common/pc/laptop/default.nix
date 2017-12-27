{ config, lib, ... }:

{
  imports = [ ../. ];

  # TODO: fix in NixOS/nixpkgs
  # Disable governor set in hardware-configuration.nix,
  # required when services.tlp.enable is true:
  powerManagement.cpuFreqGovernor =
    lib.mkIf config.services.tlp.enable (lib.mkForce null);

  services.tlp.enable = lib.mkDefault true;
}
