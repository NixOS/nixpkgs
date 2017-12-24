{ lib, ... }:

{
  hardware.cpu.intel.updateMicrocode = lib.mkDefault true;

  # https://github.com/NixOS/nixpkgs/issues/18356
  boot.blacklistedKernelModules = [ "nouveau" ];
}
