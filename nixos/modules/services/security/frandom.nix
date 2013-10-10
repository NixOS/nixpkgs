{pkgs, config, ...}:

let kernel = config.boot.kernelPackages;
in

{

  ###### interface

  options = {

    services.frandom.enable = pkgs.lib.mkOption {
      default = false;
      type = pkgs.lib.types.bool;
      description = ''
        enable the /dev/frandom device (a very fast random number generator)
      '';
    };

  };


  ###### implementation

  config = pkgs.lib.mkIf config.services.frandom.enable {
    boot.kernelModules = [ "frandom" ];
    boot.extraModulePackages = [ kernel.frandom ];
    services.udev.packages = [ kernel.frandom ];
  };

}
