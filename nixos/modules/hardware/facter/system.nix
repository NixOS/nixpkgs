{
  config,
  lib,
  ...
}:
{
  config =
    let
      detectedSystem = config.hardware.facter.report.system or null;
      canSetHostPlatform = detectedSystem != null && !config.boot.isContainer && !(config.nixpkgs ? pkgs);
    in
    lib.mkIf canSetHostPlatform {
      nixpkgs.hostPlatform = lib.mkDefault detectedSystem;
    };
}
