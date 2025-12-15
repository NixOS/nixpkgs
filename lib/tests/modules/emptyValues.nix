{ lib, ... }:
let
  inherit (lib) types;
in
{

  options = {
    int = lib.mkOption {
      type = types.lazyAttrsOf types.int;
    };
    list = lib.mkOption {
      type = types.lazyAttrsOf (types.listOf types.int);
    };
    nonEmptyList = lib.mkOption {
      type = types.lazyAttrsOf (types.nonEmptyListOf types.int);
    };
    attrs = lib.mkOption {
      type = types.lazyAttrsOf (types.attrsOf types.int);
    };
    null = lib.mkOption {
      type = types.lazyAttrsOf (types.nullOr types.int);
    };
    submodule = lib.mkOption {
      type = types.lazyAttrsOf (types.submodule { });
    };
  };

  config = {
    int.a = lib.mkIf false null;
    list.a = lib.mkIf false null;
    nonEmptyList.a = lib.mkIf false null;
    attrs.a = lib.mkIf false null;
    null.a = lib.mkIf false null;
    submodule.a = lib.mkIf false null;
  };

}
