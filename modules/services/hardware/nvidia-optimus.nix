{pkgs, config, ...}:

let kernel = config.boot.kernelPackages;
in

{

  ###### interface

  options = {

    hardware.nvidiaOptimus.disable = pkgs.lib.mkOption {
      default = false;
      type = pkgs.lib.types.bool;
      description = ''
        Completely disable the nvidia gfx chip (saves power / heat) and just use IGP
      '';
    };

  };


  ###### implementation

  config = pkgs.lib.mkIf config.hardware.nvidiaOptimus.disable {
    boot.blacklistedKernelModules = ["nouveau" "nvidia" "nvidiafb"];
    boot.kernelModules = [ "bbswitch" ];
    boot.extraModulePackages = [ kernel.bbswitch ];

    systemd.services.bbswitch = {
      description = "turn off nvidia card";
      after = [ "sysinit.target" ];
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
