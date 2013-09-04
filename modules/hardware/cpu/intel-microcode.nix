{ config, pkgs, ... }:

with pkgs.lib;

{

  ###### interface

  options = {

    hardware.cpu.intel.updateMicrocode = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Update the CPU microcode for Intel processors.
      '';
    };

  };


  ###### implementation

  config = mkIf config.hardware.cpu.intel.updateMicrocode {
    hardware.firmware = [ "${pkgs.microcodeIntel}/lib/firmware" ];
    boot.kernelModules = [ "microcode" ];
  };

}
