# NOTE: this doesn't inherit from the `general.nix`
# as z510 is not a ThinkPad

{ config, pkgs, ... }:
{
  hardware.cpu.intel.updateMicrocode = true;
  
  # see https://github.com/NixOS/nixpkgs/issues/18356
  # found buggy driver with method https://wiki.ubuntu.com/DebuggingKernelSuspend
  boot.blacklistedKernelModules = [ "nouveau" ];
}
