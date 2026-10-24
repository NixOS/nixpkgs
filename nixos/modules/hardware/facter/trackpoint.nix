{ lib, config, ... }:
let
  cfg = config.hardware.facter;

  isTrackpoint = device: device.mouse_type.name == "Track Point";

  # Trackpoint devices does not seem to be added to `report.hardware.mouse`, but
  # are available in `report.smbios.pointing_device`
  pointingDevices = lib.attrByPath [ "report" "smbios" "pointing_device" ] [ ] cfg;
in
{
  options.hardware.facter.detected.trackpoint.enable =
    lib.mkEnableOption "Trackpoint input device"
    // {
      default = lib.any isTrackpoint pointingDevices;
      defaultText = "Enabled if trackpoint is found in facter report";
    };

  config.hardware.trackpoint = lib.mkIf (cfg.enable && cfg.detected.trackpoint.enable) {
    enable = lib.mkDefault cfg.detected.trackpoint.enable;
    emulateWheel = lib.mkDefault cfg.detected.trackpoint.enable;
  };
}
