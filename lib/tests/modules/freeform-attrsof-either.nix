{ lib, ... }:
let
  inherit (lib) types mkOption;
in
{
  options.number = mkOption {
    type = types.submodule {
      freeformType = types.attrsOf (types.either types.int types.int);
    };
    default = {
      int = 42;
    }; # should not emit a warning
  };
}
