{
  config,
  lib,
  ...
}:
{
  config =
    let
      detectedSystem = config.hardware.facter.report.system or null;
    in
    lib.mkIf (!config.boot.isContainer && detectedSystem != null) {
      nixpkgs.hostPlatform = lib.mkDefault detectedSystem;
    };
}
