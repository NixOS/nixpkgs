{ config, lib, pkgs, ... }:

with lib;

{

  ###### interface

  options = {
    hardware.cpu.intel = {
      updateMicrocode = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Update the CPU microcode for Intel processors.
        '';
      };
      microcodePackage = mkOption {
        default = pkgs.microcodeIntel;
        defaultText = "pkgs.microcodeIntel";
        type = types.package;
        example = "pkgs.microcodeIntelDebian";
        description = "Microcode update package.";
      };
    };
  };


  ###### implementation

  config = mkIf config.hardware.cpu.intel.updateMicrocode {
    # Microcode updates must be the first item prepended in the initrd
    boot.initrd.prepend = mkOrder 1 [ "${config.hardware.cpu.intel.microcodePackage}/intel-ucode.img" ];
  };

}
