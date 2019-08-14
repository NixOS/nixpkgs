# This module provides the proprietary ATI X11 / OpenGL drivers.

{ config, lib, pkgs, ... }:

with lib;

let

  drivers = config.services.xserver.videoDrivers;

  enabled = elem "ati_unfree" drivers;

  ati_x11 = config.boot.kernelPackages.ati_drivers_x11;

in

{

  config = mkIf enabled {

    nixpkgs.config.xorg.abiCompat = "1.17";

    services.xserver.drivers = singleton
      { name = "fglrx"; modules = [ ati_x11 ]; display = true; };

    hardware.opengl.package = ati_x11;
    hardware.opengl.package32 = pkgs.pkgsi686Linux.linuxPackages.ati_drivers_x11.override { libsOnly = true; kernel = null; };
    hardware.opengl.setLdLibraryPath = true;

    environment.systemPackages = [ ati_x11 ];

    boot.extraModulePackages = [ ati_x11 ];

    boot.blacklistedKernelModules = [ "radeon" ];

    environment.etc.ati.source = "${ati_x11}/etc/ati";

  };

}
