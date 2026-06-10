{
  config,
  options,
  lib,
  ...
}:
{
  config =
    let
      detectedSystem = config.hardware.facter.report.system or null;
      hasExternalPkgs = options.nixpkgs.pkgs.isDefined || (config.nixpkgs ? pkgs);
      canSetHostPlatform = detectedSystem != null && !config.boot.isContainer && !hasExternalPkgs;
    in
    lib.mkIf canSetHostPlatform {
      nixpkgs.hostPlatform = lib.mkDefault detectedSystem;
    };
}
