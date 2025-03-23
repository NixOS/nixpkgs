{
  config,
  lib,
  pkgs,
  ...
}:
{
  ###### interface
  options = {

    hardware.cpu.amd.updateMicrocode = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Update the CPU microcode for AMD processors.
      '';
    };

  };

  ###### implementation
  config = lib.mkIf config.hardware.cpu.amd.updateMicrocode {
    # Microcode updates must be the first item prepended in the initrd
    boot.initrd.prepend = lib.mkOrder 1 [ "${pkgs.microcode-amd}/amd-ucode.img" ];
  };

}
