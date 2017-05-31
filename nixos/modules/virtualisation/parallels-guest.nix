{ config, lib, pkgs, pkgs_i686, ... }:

with lib;

let

  packageFun = pkgs_:
    if pkgs.stdenv.system == pkgs_.stdenv.system
    then config.boot.kernelPackages.prl-tools
    else pkgs_.linuxPackages.prl-tools.override { libsOnly = true; kernel = null; };
  package = packageFun pkgs;

in

{

  options = {
    hardware.parallels = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          This enables Parallels Tools for Linux guests, along with provided
          video, mouse and other hardware drivers.
        '';
      };

    };

  };

  config = mkIf config.hardware.parallels.enable {

    services.xserver = {
      drivers = singleton
        { name = "prlvideo"; modules = [ package ]; libPath = [ package ]; };

      screenSection = ''
        Option "NoMTRR"
      '';

      config = ''
        Section "InputClass"
          Identifier "prlmouse"
          MatchIsPointer "on"
          MatchTag "prlmouse"
          Driver "prlmouse"
        EndSection
      '';
    };

    hardware.opengl.package = packageFun;

    services.udev.packages = [ package ];

    environment.systemPackages = [ package ];

    boot.extraModulePackages = [ package ];

    boot.kernelModules = [ "prl_tg" "prl_eth" "prl_fs" "prl_fs_freeze" "acpi_memhotplug" ];

    services.timesyncd.enable = false;

    systemd.services.prltoolsd = {
      description = "Parallels Tools' service";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${package}/bin/prltoolsd -f";
        PIDFile = "/var/run/prltoolsd.pid";
      };
    };

    systemd.services.prlfsmountd = {
      description = "Parallels Shared Folders Daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = rec {
        ExecStart = "${package}/sbin/prlfsmountd ${PIDFile}";
        ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /media";
        ExecStopPost = "${package}/sbin/prlfsmountd -u";
        PIDFile = "/run/prlfsmountd.pid";
      };
    };

    systemd.services.prlshprint = {
      description = "Parallels Shared Printer Tool";
      wantedBy = [ "multi-user.target" ];
      bindsTo = [ "cups.service" ];
      serviceConfig = {
        Type = "forking";
        ExecStart = "${package}/bin/prlshprint";
      };
    };

  };
}
