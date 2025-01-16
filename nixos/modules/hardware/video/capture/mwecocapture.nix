{ config, lib, ... }:

with lib;

let

  cfg = config.hardware.mwEcoCapture;

  kernelPackages = config.boot.kernelPackages;

in

{

  options.hardware.mwEcoCapture.enable = mkEnableOption (lib.mdDoc "Magewell Eco Capture family kernel module");

  config = mkIf cfg.enable {

    boot.kernelModules = [ "MWEcoCapture" ];

    environment.systemPackages = [ kernelPackages.mwecocapture ];

    boot.extraModulePackages = [ kernelPackages.mwecocapture ];

    boot.extraModprobeConfig = ''
      # Set the png picture to be displayed when no input signal is detected.
      options MWEcoCapture nosignal_file=${kernelPackages.mwecocapture}/res/NoSignal.png

      # Set the png picture to be displayed when an unsupported input signal is detected.
      options MWEcoCapture unsupported_file=${kernelPackages.mwecocapture}/res/Unsupported.png

      # Set the png picture to be displayed when an loking input signal is detected.
      options MWEcoCapture locking_file=${kernelPackages.mwecocapture}/res/Locking.png

      # Set the png picture to be displayed when the bandwidth is limited.
      options MWEcoCapture limited_bandwidth_file=${kernelPackages.mwecocapture}/res/LimitedBandwidth.png

      # Message signaled interrupts switch
      #options MWEcoCapture disable_msi=0

      # Set the debug level
      #options MWEcoCapture debug_level=0

      # Min frame interval for VIDIOC_ENUM_FRAMEINTERVALS (default: 166666(100ns))
      #options MWEcoCapture enum_frameinterval_min=166666

      # VIDIOC_ENUM_FRAMESIZES type (1: DISCRETE; 2: STEPWISE; otherwise: CONTINUOUS )
      #options MWEcoCapture enum_framesizes_type=0

      # Enable raw mode of video for V4L2
      #options MWEcoCapture enable_raw_mode=0

      # Parameters for internal usage
      #options MWEcoCapture internal_params=""
    '';

  };

}
