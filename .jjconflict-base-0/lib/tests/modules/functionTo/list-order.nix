{ lib, config, ... }:
let
  inherit (lib) types;
in
{
  options = {
    fun = lib.mkOption {
      type = types.functionTo (types.listOf types.str);
    };

    result = lib.mkOption {
      type = types.str;
      default = toString (
        config.fun {
          a = "a";
          b = "b";
          c = "c";
        }
      );
    };
  };

  config.fun = lib.mkMerge [
    (input: lib.mkAfter [ input.a ])
    (input: [ input.b ])
  ];
}
