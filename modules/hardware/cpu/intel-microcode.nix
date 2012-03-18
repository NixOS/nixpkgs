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
    hardware.firmware = [ pkgs.microcodeIntel ];

    # This cannot be done using boot.kernelModules
    # discussion at http://lists.science.uu.nl/pipermail/nix-dev/2012-February/007959.html
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
