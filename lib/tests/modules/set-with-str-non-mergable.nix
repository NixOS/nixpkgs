{ lib, ... }:
let
  inherit (lib) types mkOption;
in
{
  imports = [
    {
      options.set = mkOption {
        apply = v: lib.deepSeq v v;
        type = types.setWith {
          elemType = types.str;
          # Every element has the same key
          toKey = str: "A";
        };
      };
    }
    {
      set = [
        "foo"
      ];
    }
    {
      # Cannot merge because "foo" != "bar"
      set = [
        "bar"
      ];
    }
  ];
}
