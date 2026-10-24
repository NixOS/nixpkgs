{
  config,
  lib,
  ...
}:
let
  facterLib = import ./lib.nix lib;
in
{
  options.hardware.facter.detected.uefi.supported = lib.mkEnableOption "the facter uefi module" // {
    default = config.hardware.facter.report.uefi.supported or false;
    defaultText = "hardware dependent";
  };

  config = lib.mkIf config.hardware.facter.detected.uefi.supported (
    facterLib.mkFacterAssignment {
      moduleName = "boot";
      path = "boot.loader.grub.efiSupport";
      value = lib.mkDefault true;
      facterValue = true;
    }
  );
}
