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

  packageFun = pkgs_:
    if pkgs.stdenv.system == pkgs_.stdenv.system
    then nvidiaForKernel config.boot.kernelPackages
    else (nvidiaForKernel pkgs_.linuxPackages).override { libsOnly = true; kernel = null; };
  package = packageFun pkgs;

  nvidiaPackage = pkgs:
    if !nvidia.useGLVND then (packageFun pkgs).out
    else pkgs.buildEnv {
      name = "nvidia-libs";
      paths = [ pkgs.libglvnd (packageFun pkgs).out ];
    };

  enabled = package != null;
in

{

  config = mkIf enabled {

    services.xserver.drivers = singleton
      { name = "nvidia"; modules = [ package.bin ]; libPath = [ package ]; };

    services.xserver.screenSection =
      ''
        Option "RandRRotation" "on"
      '';

    environment.etc."nvidia/nvidia-application-profiles-rc" = mkIf package.useProfiles {
      source = "${package.bin}/share/nvidia/nvidia-application-profiles-rc";
    };

    hardware.opengl.package = nvidiaPackage;

    environment.systemPackages = [ package.bin package.settings ]
      ++ lib.filter (p: p != null) [ package.persistenced ];

    boot.extraModulePackages = [ package.bin ];

    # nvidia-uvm is required by CUDA applications.
    boot.kernelModules = [ "nvidia-uvm" ];

    # Create /dev/nvidia-uvm when the nvidia-uvm module is loaded.
    services.udev.extraRules =
      ''
        KERNEL=="nvidia_uvm", RUN+="${pkgs.stdenv.shell} -c 'mknod -m 666 /dev/nvidia-uvm c $(grep nvidia-uvm /proc/devices | cut -d \  -f 1) 0'"
      '';

    boot.blacklistedKernelModules = [ "nouveau" "nvidiafb" ];

    services.acpid.enable = true;

  };

}
