{ config, pkgs, lib, ... }:

let
  kernel = config.boot.kernelPackages;
  cfg = config.hardware.nvidiaOptimus;
in

{

  ###### interface

  options = {

    hardware.nvidiaOptimus.disable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Completely disable the NVIDIA graphics card and use the
        integrated graphics processor instead.
      '';
    };

    hardware.nvidiaOptimus.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      internal = true;
    };

  };


  ###### implementation

  config = lib.mkIf (cfg.disable || cfg.enable) {
    boot.blacklistedKernelModules = ["nouveau" "nvidia" "nvidiafb" "nvidia-drm"];
    boot.kernelModules = [ "bbswitch" ];
    boot.extraModulePackages = [ kernel.bbswitch ];

    systemd.services.bbswitch = {
      description = "Disable NVIDIA Card";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${kernel.bbswitch}/bin/discrete_vga_poweroff";
        ExecStop = "${kernel.bbswitch}/bin/discrete_vga_poweron";
      };
      path = [ kernel.bbswitch ];
    };
  };

}
