{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  imports = [
    ./option-meta-required.nix
  ];
  options = {
    foo = lib.mkOption {
      type = lib.types.str;
      meta.required = true;
    };
    undeclared = lib.mkOption {
      type = lib.types.str;
      # typo, no q
      meta.reuired = false;
    };
    missingDef = mkOption {
      type = lib.types.str;
    };
  };
  config = {
    foo = "bar";
  };
}
