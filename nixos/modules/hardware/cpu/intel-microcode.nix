{ config, lib, pkgs, ... }:

with lib;

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
    boot.initrd.prepend = [ "${pkgs.microcodeIntel}/intel-ucode.img" ];
  };

}
