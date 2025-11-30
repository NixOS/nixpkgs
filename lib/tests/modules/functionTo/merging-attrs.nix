{ lib, config, ... }:
let
  inherit (lib) types;
in
{
  options = {
    fun = lib.mkOption {
      type = types.functionTo (types.attrsOf types.str);
    };

    result = lib.mkOption {
      type = types.str;
      default = toString (
        lib.attrValues (
          config.fun {
            a = "a";
            b = "b";
            c = "c";
          }
        )
      );
    };
  };

  config.fun = lib.mkMerge [
    (input: { inherit (input) a; })
    (input: { inherit (input) b; })
    (input: {
      b = lib.mkForce input.c;
    })
  ];
}
