{
  config,
  options,
  lib,
  ...
}:
{
  config.nixpkgs =
    let
      detectedSystem = config.hardware.facter.report.system or null;
      canSetHostPlatform = detectedSystem != null && !(options.nixpkgs.hostPlatform.readOnly or false);
    in
    lib.mkIf canSetHostPlatform {
      hostPlatform = lib.mkDefault detectedSystem;
    };
}
