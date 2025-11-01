{
  config,
  options,
  lib,
  ...
}:
{
  # Skip setting hostPlatform if it's read-only
  nixpkgs =
    lib.optionalAttrs
      (config.hardware.facter.report.system or null != null && !options.nixpkgs.hostPlatform.readOnly)
      {
        hostPlatform = lib.mkDefault config.hardware.facter.report.system;
      };
}
