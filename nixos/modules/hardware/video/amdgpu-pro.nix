# This module provides the proprietary AMDGPU-PRO drivers.

{ config, lib, pkgs, ... }:

with lib;

let

  drivers = config.services.xserver.videoDrivers;

  enabled = elem "amdgpu-pro" drivers;

  packageFun = pkgs_:
    if pkgs.stdenv.system == pkgs_.stdenv.system
    then config.boot.kernelPackages.amdgpu-pro
    else pkgs_.linuxPackages.amdgpu-pro.override { libsOnly = true; kernel = null; };
  package = packageFun pkgs;
  package32 = packageFun pkgs.pkgsi686Linux;

  opengl = config.hardware.opengl;

in

{

  config = mkIf enabled {

    nixpkgs.config.xorg.abiCompat = "1.18";

    services.xserver.drivers = singleton
      { name = "amdgpu"; modules = [ package ]; libPath = [ package ]; };

    hardware.opengl.package = packageFun;

    boot.extraModulePackages = [ package ];

    boot.blacklistedKernelModules = [ "radeon" ];

    hardware.firmware = [ package ];

    system.activationScripts.setup-amdgpu-pro = ''
      mkdir -p /run/lib
      ln -sfn ${package}/lib ${package.libCompatDir}
    '' + optionalString libraries.support32Bit ''
      ln -sfn ${package32}/lib ${package32.libCompatDir}
    '';

    environment.etc = {
      "amd/amdrc".source = package + "/etc/amd/amdrc";
      "amd/amdapfxx.blb".source = package + "/etc/amd/amdapfxx.blb";
      "gbm/gbm.conf".source = package + "/etc/gbm/gbm.conf";
    };

  };

}
