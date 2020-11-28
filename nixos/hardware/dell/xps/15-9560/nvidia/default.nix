{ lib, pkgs, ... }:

{
  imports = [
    ../../../../common/cpu/intel
    ../../../../common/pc/laptop
    ../xps-common.nix
  ];


  # This runs only nvidia, great for games or heavy use of render applications

  ##### disable intel, run nvidia only and as default
  services.xserver.videoDrivers = lib.mkDefault ["nvidia"];
  hardware.nvidia.modesetting.enable = lib.mkDefault true;
  hardware.nvidia.optimus_prime.enable = lib.mkDefault true;
  hardware.nvidia.optimus_prime.nvidiaBusId = lib.mkDefault "PCI:1:0:0";
  hardware.nvidia.optimus_prime.intelBusId = lib.mkDefault "PCI:0:2:0";

}
