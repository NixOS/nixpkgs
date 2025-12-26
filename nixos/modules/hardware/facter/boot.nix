{
  config,
  lib,
  ...
}:

{
  options.hardware.facter.detected.uefi.supported = lib.mkEnableOption "the facter uefi module" // {
    default = config.hardware.facter.report.uefi.supported or false;
    defaultText = "hardware dependent";
  };

  config.boot.loader.grub.efiSupport = lib.mkIf config.hardware.facter.detected.uefi.supported (
    lib.mkDefault true
  );
}
