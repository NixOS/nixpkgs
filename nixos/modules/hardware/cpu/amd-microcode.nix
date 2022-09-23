{ config, lib, pkgs, ... }:

with lib;

{

  ###### interface

  options = {

    hardware.cpu.amd.updateMicrocode = mkOption {
      default = false;
      type = types.bool;
      description = lib.mdDoc ''
        Update the CPU microcode for AMD processors.
      '';
    };

  };


  ###### implementation

  config = mkIf config.hardware.cpu.amd.updateMicrocode {
    # Microcode updates must be the first item prepended in the initrd
    boot.initrd.prepend = mkOrder 1 [ "${pkgs.microcodeAmd}/amd-ucode.img" ];
  };

}
