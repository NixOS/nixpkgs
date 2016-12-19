{lib, config, ...}:

let kernel = config.boot.kernelPackages;
in

{

  ###### interface

  options = {

    services.frandom.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        enable the /dev/frandom device (a very fast random number generator)
      '';
    };

  };


  ###### implementation

  config = lib.mkIf config.services.frandom.enable {
    boot.kernelModules = [ "frandom" ];
    boot.extraModulePackages = [ kernel.frandom ];
    services.udev.packages = [ kernel.frandom ];
  };

}
