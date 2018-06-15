{ config, lib, pkgs, pkgs_i686, ... }:

with lib;

let
  prl-tools = config.hardware.parallels.package;
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

      autoMountShares = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Control prlfsmountd service. When this service is running, shares can not be manually
          mounted through `mount -t prl_fs ...` as this service will remount and trample any set options.
          Recommended to enable for simple file sharing, but extended share use such as for code should
          disable this to manually mount shares.
        '';
      };

      package = mkOption {
        type = types.package;
        default = config.boot.kernelPackages.prl-tools;
        defaultText = "config.boot.kernelPackages.prl-tools";
        example = literalExample "config.boot.kernelPackages.prl-tools";
        description = ''
          Defines which package to use for prl-tools. Override to change the version.
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

    boot.kernelModules = [ "prl_tg" "prl_eth" "prl_fs" "prl_fs_freeze" ];

    services.timesyncd.enable = false;

    systemd.services.prltoolsd = {
      description = "Parallels Tools' service";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${prl-tools}/bin/prltoolsd -f";
        PIDFile = "/var/run/prltoolsd.pid";
      };
    };

    systemd.services.prlfsmountd = mkIf config.hardware.parallels.autoMountShares {
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

    systemd.user.services = {
      prlcc = {
        description = "Parallels Control Center";
        wantedBy = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${prl-tools}/bin/prlcc";
        };
      };
      prldnd = {
        description = "Parallels Control Center";
        wantedBy = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${prl-tools}/bin/prldnd";
        };
      };
      prl_wmouse_d  = {
        description = "Parallels Walking Mouse Daemon";
        wantedBy = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${prl-tools}/bin/prl_wmouse_d";
        };
      };
      prlcp = {
        description = "Parallels CopyPaste Tool";
        wantedBy = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${prl-tools}/bin/prlcp";
        };
      };
      prlsga = {
        description = "Parallels Shared Guest Applications Tool";
        wantedBy = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${prl-tools}/bin/prlsga";
        };
      };
      prlshprof = {
        description = "Parallels Shared Profile Tool";
        wantedBy = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${prl-tools}/bin/prlshprof";
        };
      };
    };

  };
}
