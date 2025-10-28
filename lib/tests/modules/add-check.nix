(
  { lib, ... }:
  let
    inherit (lib) types mkOption;
    inherit (types) addCheck int attrsOf;

    # type with a v1 merge
    v1Type = addCheck int (v: v == 0);

    # type with a v2 merge
    v2Type = addCheck (attrsOf int) (v: v ? foo);
  in
  {
    options.v1CheckedPass = mkOption {
      type = v1Type;
      default = 0;
    };
    options.v1CheckedFail = mkOption {
      type = v1Type;
      default = 1;
    };
    options.v2checkedPass = mkOption {
      type = v2Type;
      default = {
        foo = 1;
      };
      # plug the value to make test script regex simple
      apply = v: v.foo == 1;
    };
    options.v2checkedFail = mkOption {
      type = v2Type;
      default = { };
      apply = v: lib.deepSeq v v;
    };
  }
)
