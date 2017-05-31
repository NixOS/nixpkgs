# This module provides the proprietary ATI X11 / OpenGL drivers.

{ config, lib, pkgs, ... }:

with lib;

let

  drivers = config.services.xserver.videoDrivers;

  enabled = elem "ati_unfree" drivers;

  packageFun = pkgs_:
    if pkgs.stdenv.system == pkgs_.stdenv.system
    then config.boot.kernelPackages.ati_drivers_x11
    else pkgs_.linuxPackages.ati_drivers_x11.override { libsOnly = true; kernel = null; };
  package = packageFun pkgs;

in

{

  config = mkIf enabled {

    nixpkgs.config.xorg.abiCompat = "1.17";

    services.xserver.drivers = singleton
      { name = "fglrx"; modules = [ package ]; libPath = [ "${package}/lib" ]; };

    hardware.opengl.package = packageFun;

    environment.systemPackages = [ package ];

    boot.extraModulePackages = [ package ];

    boot.blacklistedKernelModules = [ "radeon" ];

    environment.etc."ati".source = "${package}/etc/ati";

  };

}
