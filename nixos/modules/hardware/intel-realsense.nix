{ config, lib, pkgs, ... }:

with lib;

{
  options = {
    hardware.intel.realsense.enable = mkOption {
      type = types.boolean;
      default = false;
      description = '' Enable (intel) librealsense udev rules '';
    };

    hardware.intel.realsense.package = mkOption {
      type = types.package;
      default = pkgs.librealsenseWithExamples;
      description = '' use pkgs.librealsense to avoid examples. The examples for instance contain realsense-viewer.'';
    };
  };

  config = mkIf (config.hardware.intel.realsense.enable) {
    environment.systemPackages = [ pkgs.librealsense ];
    services.udev.packages =     [ pkgs.librealsense ];
  };

}
