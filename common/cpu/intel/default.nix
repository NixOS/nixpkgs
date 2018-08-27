{ lib, pkgs, ... }:

{
  boot.initrd.kernelModules = [ "i915" ];

  hardware.cpu.intel.updateMicrocode = lib.mkDefault true;
  
  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
  ];
}
