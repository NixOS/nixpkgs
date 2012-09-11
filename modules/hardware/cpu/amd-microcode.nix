{ config, pkgs, ... }:

with pkgs.lib;

{

  ###### interface

  options = {

    hardware.cpu.amd.updateMicrocode = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Update the CPU microcode for Amd processors.
      '';
    };

  };


  ###### implementation

  config = mkIf config.hardware.cpu.amd.updateMicrocode {
    hardware.firmware = [ pkgs.amdUcode ];
    boot.kernelModules = [ "microcode" ];
  };

}
