# {
#   config,
#   options,
#   lib,
#   ...
# }:
# {
#   config =
#     let
#       detectedSystem = config.hardware.facter.report.system or null;
#       hasExternalPkgs = options.nixpkgs.pkgs.isDefined || (config.nixpkgs ? pkgs);
#       canSetHostPlatform = detectedSystem != null && !config.boot.isContainer && !hasExternalPkgs;
#     in
#     lib.mkIf canSetHostPlatform {
#       nixpkgs.hostPlatform = lib.mkDefault detectedSystem;
#     };
# }
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
