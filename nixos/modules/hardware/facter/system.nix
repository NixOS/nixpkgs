# nixos/modules/hardware/facter/system.nix
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
      canSetHostPlatform =
        detectedSystem != null
        && !config.boot.isContainer
        && !options.nixpkgs.pkgs.isDefined
        && !options.nixpkgs.hostPlatform.isDefined;
    in
    lib.mkIf canSetHostPlatform {
      nixpkgs.hostPlatform = lib.mkDefault detectedSystem;
    };
}
