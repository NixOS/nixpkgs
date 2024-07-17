# This module provides the proprietary AMDGPU-PRO drivers.

{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  drivers = config.services.xserver.videoDrivers;

  enabled = elem "amdgpu-pro" drivers;

  package = config.boot.kernelPackages.amdgpu-pro;
  package32 = pkgs.pkgsi686Linux.linuxPackages.amdgpu-pro.override { kernel = null; };

  opengl = config.hardware.opengl;

in

{

  config = mkIf enabled {
    services.xserver.drivers = singleton {
      name = "amdgpu";
      modules = [ package ];
      display = true;
    };

    hardware.opengl.package = package;
    hardware.opengl.package32 = package32;
    hardware.opengl.setLdLibraryPath = true;

    boot.extraModulePackages = [ package.kmod ];

    boot.kernelPackages = pkgs.linuxKernel.packagesFor (
      pkgs.linuxKernel.kernels.linux_5_10.override {
        structuredExtraConfig = {
          DEVICE_PRIVATE = kernel.yes;
          KALLSYMS_ALL = kernel.yes;
        };
      }
    );

    hardware.firmware = [ package.fw ];

    systemd.tmpfiles.settings.amdgpu-pro = {
      "/run/amdgpu"."L+".argument = "${package}/opt/amdgpu";
      "/run/amdgpu-pro"."L+".argument = "${package}/opt/amdgpu-pro";
    };

    system.requiredKernelConfig = with config.lib.kernelConfig; [
      (isYes "DEVICE_PRIVATE")
      (isYes "KALLSYMS_ALL")
    ];

    boot.initrd.extraUdevRulesCommands = mkIf (!config.boot.initrd.systemd.enable) ''
      cp -v ${package}/etc/udev/rules.d/*.rules $out/
    '';
    boot.initrd.services.udev.packages = [ package ];

    environment.systemPackages =
      [ package.vulkan ]
      ++
      # this isn't really DRI, but we'll reuse this option for now
      optional config.hardware.opengl.driSupport32Bit package32.vulkan;

    environment.etc = {
      "modprobe.d/blacklist-radeon.conf".source = package + "/etc/modprobe.d/blacklist-radeon.conf";
      amd.source = package + "/etc/amd";
    };

  };

}
