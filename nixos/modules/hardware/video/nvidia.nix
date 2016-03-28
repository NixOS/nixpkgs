# This module provides the proprietary NVIDIA X11 / OpenGL drivers.

{ config, lib, pkgs, pkgs_i686, ... }:

with lib;

let

  drivers = config.services.xserver.videoDrivers;

  # FIXME: should introduce an option like
  # ‘hardware.video.nvidia.package’ for overriding the default NVIDIA
  # driver.
  nvidiaForKernel = kernelPackages:
    if elem "nvidia" drivers then
        kernelPackages.nvidia_x11
    else if elem "nvidiaBeta" drivers then
        kernelPackages.nvidia_x11_beta
    else if elem "nvidiaLegacy173" drivers then
      kernelPackages.nvidia_x11_legacy173
    else if elem "nvidiaLegacy304" drivers then
      kernelPackages.nvidia_x11_legacy304
    else if elem "nvidiaLegacy340" drivers then
      kernelPackages.nvidia_x11_legacy340
    else null;

  nvidia_x11 = nvidiaForKernel config.boot.kernelPackages;
  nvidia_libs32 = (nvidiaForKernel pkgs_i686.linuxPackages).override { libsOnly = true; kernel = null; };

  enabled = nvidia_x11 != null;
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
    hardware.opengl.package32 = nvidia_libs32;

    environment.systemPackages = [ nvidia_x11 ];

    boot.extraModulePackages = [ nvidia_x11 ];

    # nvidia-uvm is required by CUDA applications.
    boot.kernelModules = [ "nvidia-uvm" ];

    # Create /dev/nvidia-uvm when the nvidia-uvm module is loaded.
    services.udev.extraRules =
      ''
        KERNEL=="nvidia_uvm", RUN+="${pkgs.stdenv.shell} -c 'mknod -m 666 /dev/nvidia-uvm c $(grep nvidia-uvm /proc/devices | cut -d \  -f 1) 0'"
      '';

    boot.blacklistedKernelModules = [ "nouveau" "nvidiafb" ];

    services.acpid.enable = true;

    environment.etc."OpenCL/vendors/nvidia.icd".source = "${nvidia_x11}/lib/vendors/nvidia.icd";

  };

}
