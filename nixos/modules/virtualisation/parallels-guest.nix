{ config, lib, pkgs, pkgs_i686, ... }:

with lib;

let

  prl-tools = config.boot.kernelPackages.prl-tools;

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
        { name = "prlvideo"; modules = [ prl-tools ]; libPath = [ prl-tools ]; };

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

    hardware.opengl.package = prl-tools;
    hardware.opengl.package32 = pkgs_i686.linuxPackages.prl-tools.override { libsOnly = true; kernel = null; };

    services.udev.packages = [ prl-tools ];

    environment.systemPackages = [ prl-tools ];

    boot.extraModulePackages = [ prl-tools ];

    boot.kernelModules = [ "prl_tg" "prl_eth" "prl_fs" "prl_fs_freeze" "acpi_memhotplug" ];

    services.ntp.enable = false;

    systemd.services.prltoolsd = {
      description = "Parallels Tools' service";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${prl-tools}/bin/prltoolsd -f";
        PIDFile = "/var/run/prltoolsd.pid";
      };
    };

    systemd.services.prlfsmountd = {
      description = "Parallels Shared Folders Daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = rec {
        ExecStart = "${prl-tools}/sbin/prlfsmountd ${PIDFile}";
        ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /media";
        ExecStopPost = "${prl-tools}/sbin/prlfsmountd -u";
        PIDFile = "/run/prlfsmountd.pid";
      };
    };

    systemd.services.prlshprint = {
      description = "Parallels Shared Printer Tool";
      wantedBy = [ "multi-user.target" ];
      bindsTo = [ "cups.service" ];
      serviceConfig = {
        Type = "forking";
        ExecStart = "${prl-tools}/bin/prlshprint";
      };
    };

  };
}
