{ lib, optionDeclaration, ... }:
let
  inherit (lib) types mkOption;
in
{
  # Additional options available in mkOption { ..., meta = { ... } }
  options = {
    relatedPackages = mkOption {
      type = types.raw;
      default = optionDeclaration.relatedPackages or [ ];
    };
  };
}
