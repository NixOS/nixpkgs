{ lib, config, ... }:
let
  facterLib = import ./lib.nix lib;
in
{
  options.hardware.facter.detected.bluetooth.enable =
    lib.mkEnableOption "Enable the Facter bluetooth module"
    // {
      default = builtins.length (config.hardware.facter.report.hardware.bluetooth or [ ]) > 0;
      defaultText = "hardware dependent";
    };

  config = lib.mkIf config.hardware.facter.detected.bluetooth.enable (
    facterLib.mkFacterAssignment {
      moduleName = "bluetooth";
      path = "hardware.bluetooth.enable";
      value = lib.mkDefault true;
      facterValue = true;
    }
  );
}
