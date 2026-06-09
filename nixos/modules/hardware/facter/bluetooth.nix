{ lib, config, ... }:
{
  options.hardware.facter.detected.bluetooth.enable =
    lib.mkEnableOption "Enable the Facter bluetooth module"
    // {
      default = builtins.length (config.hardware.facter.report.hardware.bluetooth or [ ]) > 0;
      defaultText = "hardware dependent";
    };

  config = lib.mkIf config.hardware.facter.detected.bluetooth.enable {
    hardware.bluetooth.enable = lib.mkDefault true;

    hardware.facter.changes = {
      "hardware.bluetooth.enable".bluetooth = true;
    };
  };
}
