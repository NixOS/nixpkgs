{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hardware.cpu.intel;
in
{
  ###### interface
  options = {

    hardware.cpu.intel.updateMicrocode = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Update the CPU microcode for Intel processors.
      '';
    };
    hardware.cpu.intel.microcodePackage = lib.mkPackageOption pkgs "microcode-intel" { };
  };

  ###### implementation
  config = lib.mkIf cfg.updateMicrocode {
    # Microcode updates must be the first item prepended in the initrd
    boot.initrd.prepend = lib.mkOrder 1 [ "${cfg.microcodePackage}/intel-ucode.img" ];
  };

}
