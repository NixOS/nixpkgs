{ lib, ... }:

let
  # An element type without options, with attribute sets as values.
  # Its merge adds `merged`, thus a test can see if `nestedAttrsOf` used it.
  tagged = lib.types.mkOptionType {
    name = "tagged";
    check = v: lib.isAttrs v && v ? tag;
    merge = loc: defs: (lib.mergeOneOption loc defs) // { merged = true; };
  };
in
{
  options = {
    value = lib.mkOption {
      type = lib.types.nestedAttrsOf tagged;
      default = {
        a = {
          tag = 1;
        };
        b.c = {
          tag = 2;
          d = 3;
        };
      };
    };
  };
}
