# This module provides the proprietary AMD Radeon™ X11 / OpenGL drivers.

{ config, lib, pkgs, pkgs_i686, ... }:

with lib;

let

  drivers = config.services.xserver.videoDrivers;
  enabled = elem "amd-non-free" drivers;
  amd-fglrx = config.boot.kernelPackages.amd-non-free;
  amd-fglrx-libs = config.boot.kernelPackages.amd-non-free-libs;

  atieventsdUnit = {
    description = "Catalyst event Daemon.";
    serviceConfig = {
      requires="acpid.service";
      ExecStart="${amd-fglrx}/bin/atieventsd --acpidsocket=/run/acpid.socket --socket=/run/atieventsd.socket --nosyslog --xauthscript=${amd-fglrx}/etc/ati/authatieventsd.sh";
    };
    wantedBy = [ "graphical.target" ];
    after = [ "local-fs.target" "multi-user.target" "graphical.target" ];
  };

in

{

  config = mkIf enabled {

    environment.systemPackages = [ amd-fglrx ];

    services.xserver.drivers = singleton
      { name = "fglrx"; modules = [ amd-fglrx-libs ]; libPath = [ "${amd-fglrx-libs}/lib" ]; };

    hardware.opengl.driSupport32Bit = if pkgs.stdenv.isx86_64 then true else false;
    hardware.opengl.package = amd-fglrx-libs;
    hardware.opengl.package32 = pkgs_i686.linuxPackages.amd-non-free-libs;
    services.acpid.enable = true;
    boot.extraModulePackages = [ amd-fglrx ];
    boot.blacklistedKernelModules = [ "radeon" "amdgpu" "radeonfb" ];
    boot.kernelParams = [ "nomodeset" "irqpoll" ];
    environment.etc."ati".source = "${amd-fglrx}/etc/ati";
    systemd.services."atieventsd" = atieventsdUnit;

  };

}
