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
        completely disable the nvidia gfx chip (saves power / heat) and just use IGP
      '';
    };

  };


  ###### implementation

  config = pkgs.lib.mkIf config.hardware.nvidiaOptimus.disable {
    boot.blacklistedKernelModules = ["nouveau" "nvidia" "nvidiafb"];
    boot.kernelModules = [ "bbswitch" ];
    boot.extraModulePackages = [ kernel.bbswitch ];

    jobs.bbswitch = {
      name = "bbswitch";
      description = "turn off nvidia card";
      startOn = "stopped udevtrigger";
      exec = "discrete_vga_poweroff";
      path = [kernel.bbswitch];
      task = true;
    };
  };

}
