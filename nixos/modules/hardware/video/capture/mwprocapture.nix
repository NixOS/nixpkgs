{ config, lib, ... }:

with lib;

let

  cfg = config.hardware.mwProCapture;

  kernelPackages = config.boot.kernelPackages;

in

{

  options.hardware.mwProCapture.enable = mkEnableOption "the Magewell Pro Capture family kernel module";

  config = mkIf cfg.enable {

    boot.kernelModules = [ "ProCapture" ];

    environment.systemPackages = [ kernelPackages.mwprocapture ];

    boot.extraModulePackages = [ kernelPackages.mwprocapture ];

    boot.extraModprobeConfig = ''
      # Set the png picture to be displayed when no input signal is detected.
      options ProCapture nosignal_file=${kernelPackages.mwprocapture}/res/NoSignal.png

      # Set the png picture to be displayed when an unsupported input signal is detected.
      options ProCapture unsupported_file=${kernelPackages.mwprocapture}/res/Unsupported.png

      # Set the png picture to be displayed when an loking input signal is detected.
      options ProCapture locking_file=${kernelPackages.mwprocapture}/res/Locking.png

      # Message signaled interrupts switch
      #options ProCapture disable_msi=0

      # Set the debug level
      #options ProCapture debug_level=0

      # Force init switch eeprom
      #options ProCapture init_switch_eeprom=0

      # Min frame interval for VIDIOC_ENUM_FRAMEINTERVALS (default: 166666(100ns))
      #options ProCapture enum_frameinterval_min=166666

      # VIDIOC_ENUM_FRAMESIZES type (1: DISCRETE; 2: STEPWISE; otherwise: CONTINUOUS )
      #options ProCapture enum_framesizes_type=0

      # Parameters for internal usage
      #options ProCapture internal_params=""
    '';

  };

}
