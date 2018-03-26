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
    assertions = [
      {
        assertion = config.services.xserver.displayManager.gdm.wayland;
        message = "NVidia drivers don't support wayland";
      }
    ];

    services.xserver.drivers = singleton
      { name = "nvidia"; modules = [ nvidia_x11.bin ]; libPath = [ nvidia_x11 ]; };

    services.xserver.screenSection =
      ''
        Option "RandRRotation" "on"
      '';

    environment.etc."nvidia/nvidia-application-profiles-rc" = mkIf nvidia_x11.useProfiles {
      source = "${nvidia_x11.bin}/share/nvidia/nvidia-application-profiles-rc";
    };

    hardware.opengl.package = nvidia_x11.out;
    hardware.opengl.package32 = nvidia_libs32.out;

    environment.systemPackages = [ nvidia_x11.bin nvidia_x11.settings ]
      ++ lib.filter (p: p != null) [ nvidia_x11.persistenced ];

    boot.extraModulePackages = [ nvidia_x11.bin ];

    # nvidia-uvm is required by CUDA applications.
    boot.kernelModules = [ "nvidia-uvm" ] ++
      lib.optionals config.services.xserver.enable [ "nvidia" "nvidia_modeset" "nvidia_drm" ];


    # Create /dev/nvidia-uvm when the nvidia-uvm module is loaded.
    services.udev.extraRules =
      ''
        KERNEL=="nvidia", RUN+="${pkgs.runtimeShell} -c 'mknod -m 666 /dev/nvidiactl c $(grep nvidia-frontend /proc/devices | cut -d \  -f 1) 255'"
        KERNEL=="nvidia_modeset", RUN+="${pkgs.runtimeShell} -c 'mknod -m 666 /dev/nvidia-modeset c $(grep nvidia-frontend /proc/devices | cut -d \  -f 1) 254'"
        KERNEL=="card*", SUBSYSTEM=="drm", DRIVERS=="nvidia", RUN+="${pkgs.runtimeShell} -c 'mknod -m 666 /dev/nvidia%n c $(grep nvidia-frontend /proc/devices | cut -d \  -f 1) %n'"
        KERNEL=="nvidia_uvm", RUN+="${pkgs.runtimeShell} -c 'mknod -m 666 /dev/nvidia-uvm c $(grep nvidia-uvm /proc/devices | cut -d \  -f 1) 0'"
      '';

    boot.blacklistedKernelModules = [ "nouveau" "nvidiafb" ];

    services.acpid.enable = true;

  };

}
