# This module provides the proprietary NVIDIA X11 / OpenGL drivers.

{ config, lib, pkgs, pkgs_i686, ... }:

with {
  inherit (lib)
    elem
    mkIf
    optionals
    optionalString
    singleton;
};

let

  drivers = config.services.xserver.videoDrivers;

  # FIXME: should introduce an option like
  # ‘hardware.video.nvidia.package’ for overriding the default NVIDIA
  # driver.
  nvidiaForKernel = kernelPackages:
    if elem "nvidia" drivers || elem "nvidiaLongLived" then
        kernelPackages.nvidia_x11_long_lived
    else if elem "nvidiaShortLived" drivers then
        kernelPackages.nvidia_x11_short_lived
    else if elem "nvidiaBeta" drivers then
        kernelPackages.nvidia_x11_beta
    else if elem "nvidiaLegacy304" drivers then
      kernelPackages.nvidia_x11_legacy304
    else if elem "nvidiaLegacy340" drivers then
      kernelPackages.nvidia_x11_legacy340
    else if elem "nvidiaVulkan" drivers then
      kernelPackages.nvidia_x11_vulkan
    else null;

  nvidia_x11 = nvidiaForKernel config.boot.kernelPackages;
  nvidia_x11_libs32 = (nvidiaForKernel pkgs_i686.linuxPackages).override {
    buildConfig = "userspace";
    libsOnly = true;
    kernel = null;
  };

  enabled = nvidia_x11 != null;
in

{

  config = mkIf enabled {

    boot.blacklistedKernelModules = [
      "nouveau"
      "nvidiafb"
      "rivafb"
      "rivatv"
    ];

    boot.extraModulePackages = [
      nvidia_x11
    ];

    boot.kernelModules = optionals nvidia_x11.cudaUVM [
      # nvidia-uvm is required by CUDA applications.
      "nvidia-uvm"
    ];

    environment.etc."OpenCL/vendors/nvidia.icd".source =
      "${nvidia-drivers}/etc/OpenCL/vendors/nvidia.icd";
    environment.etc."nvidia/nvidia-application-profiles-rc.d".source =
      "${nvidia-drivers}/etc/nvidia/nvidia-application-profiles-rc.d";

    environment.systemPackages = [
      nvidia_x11
    ];

    hardware.opengl.package = nvidia_x11;
    hardware.opengl.package32 = nvidia_x11_libs32;

    services.acpid.enable = true;

    # Create /dev/nvidia-uvm when the nvidia-uvm module is loaded.
    services.udev.extraRules = optionalString nvidia_x11.cudaUVM ''
      KERNEL=="nvidia_uvm", RUN+="${pkgs.stdenv.shell} -c 'mknod -m 666 /dev/nvidia-uvm c $(grep nvidia-uvm /proc/devices | cut -d \  -f 1) 0'"
    '';

    services.xserver.drivers = singleton {
      name = "nvidia";
      modules = [
        # x11glvnd module
        #pkgs.libglvnd
        nvidia_x11
      ];
      libPath = [
        nvidia_x11
      ];
    };

    services.xserver.screenSection = ''
      Option "RandRRotation" "on"
    '';

  };

}
