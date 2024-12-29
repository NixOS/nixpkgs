{
  config,
  lib,
  pkgs,
  ...
}:
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

  };

  ###### implementation
  config = lib.mkIf config.hardware.cpu.intel.updateMicrocode {
    # Microcode updates must be the first item prepended in the initrd
    boot.initrd.prepend = lib.mkOrder 1 [ "${pkgs.microcode-intel}/intel-ucode.img" ];
  };

}
