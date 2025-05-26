{ config, lib, ... }:

let
  kernel = config.boot.kernelPackages;
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

  };

  ###### implementation

  config = lib.mkIf config.hardware.nvidiaOptimus.disable {
    boot.blacklistedKernelModules = [
      "nouveau"
      "nvidia"
      "nvidiafb"
      "nvidia-drm"
      "nvidia-modeset"
    ];
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
