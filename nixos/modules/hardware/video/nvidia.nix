# This module provides the proprietary NVIDIA X11 / OpenGL drivers.

{ config, lib, pkgs, pkgs_i686, options, ... }:

with lib;

let

  cfg = config.hardware.video.nvidia;
  drivers = config.services.xserver.videoDrivers;

  nvidiaForKernel = kernelPackages:
    if elem "nvidia" cfg.package then
        kernelPackages.nvidia_x11
    else if elem "nvidiaBeta" cfg.package then
        kernelPackages.nvidia_x11_beta
    else if elem "nvidiaLegacy173" cfg.package then
      kernelPackages.nvidia_x11_legacy173
    else if elem "nvidiaLegacy304" cfg.package then
      kernelPackages.nvidia_x11_legacy304
    else if elem "nvidiaLegacy340" cfg.package then
      kernelPackages.nvidia_x11_legacy340
    else null;

  nvidia_x11 = nvidiaForKernel config.boot.kernelPackages;
  nvidia_libs32 = (nvidiaForKernel pkgs_i686.linuxPackages).override { libsOnly = true; kernel = null; };

  nvidiaPackage = nvidia: pkgs:
    assert config.hardware.opengl.useGLVND -> nvidia.useGLVND;
    if !nvidia.useGLVND || config.hardware.opengl.useGLVND then nvidia.out
    else pkgs.buildEnv {
      name = "nvidia-libs";
      paths = [ pkgs.libglvnd nvidia.out ];
    };

  package = nvidiaPackage nvidia_x11 pkgs;
  package32 = nvidiaPackage nvidia_libs32 pkgs_i686;

  enabled = nvidia_x11 != null;
  optimus = config.hardware.nvidiaOptimus.enable;
in

{

  options = {
    hardware.video.nvidia.package = options.services.xserver.videoDrivers // {
      default = drivers;
      description = ''
        Package to use. One of nvidia, nvidiaBeta, nvidiaLegacy173,
        nvidiaLegacy304, nvidiaLegacy340.
      '';
    };
  };

  config = mkIf enabled {
    assertions = [
      {
        assertion = config.services.xserver.displayManager.gdm.wayland;
        message = "NVidia drivers don't support wayland";
      }
    ];

    services.xserver.drivers = optional (!optimus)
      { name = "nvidia"; modules = [ nvidia_x11.bin ]; libPath = [ nvidia_x11 ]; };

    services.xserver.screenSection = optionalString (!optimus)
      ''
        Option "RandRRotation" "on"
      '';

    environment.etc."nvidia/nvidia-application-profiles-rc" = mkIf nvidia_x11.useProfiles {
      source = "${nvidia_x11.bin}/share/nvidia/nvidia-application-profiles-rc";
    };

    hardware.opengl = if (!optimus) then {
      inherit package package32;
    } else {
      useGLVND = true;
      extraPackages = singleton package;
      extraPackages32 = singleton package32;
    };

    environment.systemPackages = [ nvidia_x11.bin nvidia_x11.settings ]
      ++ lib.filter (p: p != null) [ nvidia_x11.persistenced ];

    boot.extraModulePackages = [ nvidia_x11.bin ];

    # nvidia-uvm is required by CUDA applications.
    boot.kernelModules = optionals (!optimus) ([ "nvidia-uvm" ] ++
      lib.optionals config.services.xserver.enable [ "nvidia" "nvidia_modeset" "nvidia_drm" ]);


    # Create /dev/nvidia-uvm when the nvidia-uvm module is loaded.
    services.udev.extraRules =
      ''
        KERNEL=="nvidia", RUN+="${pkgs.stdenv.shell} -c 'mknod -m 666 /dev/nvidiactl c $(grep nvidia-frontend /proc/devices | cut -d \  -f 1) 255'"
        KERNEL=="nvidia_modeset", RUN+="${pkgs.stdenv.shell} -c 'mknod -m 666 /dev/nvidia-modeset c $(grep nvidia-frontend /proc/devices | cut -d \  -f 1) 254'"
        KERNEL=="card*", SUBSYSTEM=="drm", DRIVERS=="nvidia", RUN+="${pkgs.stdenv.shell} -c 'mknod -m 666 /dev/nvidia%n c $(grep nvidia-frontend /proc/devices | cut -d \  -f 1) %n'"
        KERNEL=="nvidia_uvm", RUN+="${pkgs.stdenv.shell} -c 'mknod -m 666 /dev/nvidia-uvm c $(grep nvidia-uvm /proc/devices | cut -d \  -f 1) 0'"
      '';

    boot.blacklistedKernelModules = [ "nouveau" "nvidiafb" ];

    services.acpid.enable = true;

  };

}
