{
  config,
  options,
  lib,
  ...
}:
{
  # Skip setting hostPlatform if it's read-only
  config.nixpkgs =
    lib.optionalAttrs
      (
        config.hardware.facter.report.system or null != null
        && !(options.nixpkgs.hostPlatform.readOnly or false)
      )
      {
        hostPlatform = lib.mkDefault config.hardware.facter.report.system;
      };
}
