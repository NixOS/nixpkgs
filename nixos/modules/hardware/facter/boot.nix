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

  config = lib.mkIf config.hardware.facter.detected.uefi.supported {
    boot.loader.grub.efiSupport = lib.mkDefault true;

    hardware.facter.changes = {
      "boot.loader.grub.efiSupport".boot = true;
    };
  };
}
