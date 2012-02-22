{pkgs, config, ...}:

{

  ###### interface

  options = {

    hardware.cpu.intel.updateMicrocode = pkgs.lib.mkOption {
      default = false;
      type = pkgs.lib.types.bool;
      description = ''
        Update the CPU microcode for intel processors.
      '';
    };

  };


  ###### implementation

  config = pkgs.lib.mkIf config.hardware.cpu.intel.updateMicrocode {
    hardware.firmware = [pkgs.microcodeIntel];
    jobs.microcode = {
      name = "microcode";
      description = "load microcode";
      startOn = "started udev";
      exec = "modprobe microcode";
      path = [config.system.sbin.modprobe];
      task = true;
    };
  };

}
