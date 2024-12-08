{ lib, ... }:
let
  inherit (lib) types mkOption;
in
{
  options = {
    opt = mkOption {
      type = types.attrTag {
        int = types.int;
      };
      default = { int = 1; };
    };
  };
}
