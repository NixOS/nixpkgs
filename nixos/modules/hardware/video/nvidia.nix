# This module provides the proprietary NVIDIA X11 / OpenGL drivers.

{ config, lib, pkgs, pkgs_i686, ... }:

with lib;

let

  drivers = config.services.xserver.videoDrivers;

  # FIXME: should introduce an option like
  # ‘hardware.video.nvidia.package’ for overriding the default NVIDIA
  # driver.
  enabled = elem "nvidia" drivers || elem "nvidiaLegacy173" drivers
    || elem "nvidiaLegacy304" drivers || elem "nvidiaLegacy340" drivers;

  nvidia_x11 =
    if elem "nvidia" drivers then
      config.boot.kernelPackages.nvidia_x11
    else if elem "nvidiaLegacy173" drivers then
      config.boot.kernelPackages.nvidia_x11_legacy173
    else if elem "nvidiaLegacy304" drivers then
      config.boot.kernelPackages.nvidia_x11_legacy304
    else if elem "nvidiaLegacy340" drivers then
      config.boot.kernelPackages.nvidia_x11_legacy340
    else throw "impossible";

in

{

  config = mkIf enabled {

    services.xserver.drivers = singleton
      { name = "nvidia"; modules = [ nvidia_x11 ]; libPath = [ nvidia_x11 ]; };

    services.xserver.screenSection =
      ''
        Option "RandRRotation" "on"
      '';

    hardware.opengl.package = nvidia_x11;
    hardware.opengl.package32 = pkgs_i686.linuxPackages.nvidia_x11.override { libsOnly = true; kernel = null; };

    environment.systemPackages = [ nvidia_x11 ];

    boot.extraModulePackages = [ nvidia_x11 ];

    boot.blacklistedKernelModules = [ "nouveau" "nvidiafb" ];

    services.acpid.enable = true;

    environment.etc."OpenCL/vendors/nvidia.icd".source = "${nvidia_x11}/lib/vendors/nvidia.icd";

  };

}
