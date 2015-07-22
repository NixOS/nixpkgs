{ config, lib, pkgs, ... }:

with lib;

{

  ###### interface

  options = {

    hardware.cpu.amd.updateMicrocode = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Update the CPU microcode for AMD processors.
      '';
    };

  };


  ###### implementation

  config = mkIf config.hardware.cpu.amd.updateMicrocode {
    boot.initrd.prepend = [ "${pkgs.microcodeAmd}/amd-ucode.img" ];
  };

}
