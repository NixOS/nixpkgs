{
  config,
  options,
  lib,
  ...
}:
{
  config.nixpkgs =
    let
      hasExplicitReport =
        options.hardware.facter.report.isDefined || options.hardware.facter.reportPath.isDefined;
      detectedSystem = if hasExplicitReport then config.hardware.facter.report.system or null else null;
      canSetHostPlatform =
        hasExplicitReport && detectedSystem != null && !(options.nixpkgs.hostPlatform.readOnly or false);
    in
    lib.optionalAttrs canSetHostPlatform {
      hostPlatform = lib.mkDefault detectedSystem;
    };
}
