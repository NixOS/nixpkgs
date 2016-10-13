# This module provides the proprietary AMDGPU-PRO drivers.

{ config, lib, pkgs, pkgs_i686, ... }:

with lib;

let

  drivers = config.services.xserver.videoDrivers;

  enabled = elem "amdgpu-pro" drivers;

  package = config.boot.kernelPackages.amdgpu-pro;
  package32 = pkgs_i686.linuxPackages.amdgpu-pro.override { libsOnly = true; kernel = null; };

  opengl = config.hardware.opengl;

in

{

  config = mkIf enabled {

    services.xserver.drivers = singleton
      { name = "amdgpu"; modules = [ package ]; libPath = [ package ]; };

    hardware.opengl.package = package;
    hardware.opengl.package32 = package32;

    boot.extraModulePackages = [ package ];

    boot.blacklistedKernelModules = [ "radeon" ];

    hardware.firmware = [ package ];

    system.activationScripts.setup-amdgpu-pro = ''
      mkdir -p /run/lib
      ln -sfn ${package}/lib ${package.libCompatDir}
    '' + optionalString opengl.driSupport32Bit ''
      ln -sfn ${package32}/lib ${package32.libCompatDir}
    '';

    environment.etc = {
      "amd/amdrc".source = package + "/etc/amd/amdrc";
      "amd/amdapfxx.blb".source = package + "/etc/amd/amdapfxx.blb";
      "gbm/gbm.conf".source = package + "/etc/gbm/gbm.conf";
      "OpenCL/vendors/amdocl64.icd".source = package + "/etc/OpenCL/vendors/amdocl64.icd";
      "vulkan/icd.d/amd_icd64.json".source = package + "/etc/vulkan/icd.d/amd_icd64.json";
    } // optionalAttrs opengl.driSupport32Bit {
      "OpenCL/vendors/amdocl32.icd".source = package32 + "/etc/OpenCL/vendors/amdocl32.icd";
      "vulkan/icd.d/amd_icd32.json".source = package32 + "/etc/vulkan/icd.d/amd_icd32.json";
    };

  };

}
