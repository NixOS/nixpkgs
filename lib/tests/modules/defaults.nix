{ lib, config, ... }:
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
    submoduleWithDefaults = lib.mkOption {
      type = types.submodule {
        options.enabled = lib.mkOption {
          type = types.bool;
          default = true;
        };
        options.count = lib.mkOption {
          type = types.int;
          default = 13;
        };
      };
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

    result = lib.mkOption {
      type = types.str;
      default =
        assert
          config.submoduleWithDefaults == {
            enabled = true;
            count = 13;
          };
        "ok";
    };
  };
}
