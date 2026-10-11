{ lib, ... }:
# Based on <nixpkgs/nixos/modules/misc/assertions.nix>
{
  options = {
    assertions = lib.mkOption {
      type = lib.types.listOf lib.types.unspecified;
      default = [ ];
      internal = true;
    };
    warnings = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      internal = true;
    };
  };
}
