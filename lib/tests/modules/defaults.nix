{ lib, ... }:
let
  inherit (lib) types;
in
{
  options = {
    list = lib.mkOption {
      type = types.listOf types.int;
    };
    attrs = lib.mkOption {
      type = types.attrs;
    };
    attrsOf = lib.mkOption {
      type = types.attrsOf types.int;
    };
    null = lib.mkOption {
      type = types.nullOr types.int;
    };
    submodule = lib.mkOption {
      type = types.submodule { };
    };
    unique = lib.mkOption {
      type = types.unique { message = "hi"; } (types.listOf types.int);
    };
    coercedTo = lib.mkOption {
      type = types.coercedTo (types.attrsOf types.int) builtins.attrNames (types.listOf types.str);
    };
    # no empty value
    int = lib.mkOption {
      type = types.int;
    };
  };
}
