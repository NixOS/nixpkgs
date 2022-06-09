{ config, lib, extendModules, ... }:
let
  inherit (lib) mkOption types;

  extendModule = module: extendModules { modules = [ module ]; };

  choice = choice@{ name, ... }: {
    options = {
      value = mkOption {
        type = types.lazyAttrsOf (extendModule ({ })).type;
      };
    };
  };
in
{
  options = {
    matrix = mkOption {
      type = types.lazyAttrsOf (types.submodule choice);
      default = { };
    };

    items = mkOption {
      type = types.attrsOf types.str;
    };

    result = mkOption {
      default =
        let ds = x: lib.deepSeq x x;
        in ds config.matrix.cookie.value.accept.matrix.pill.value.red.items;
    };
  };
  config = {
    matrix.pill.value.blue.items.pill = "blue";
    matrix.pill.value.red.items.pill = "red";
    matrix.cookie.value.accept.items.cookie = "accept";
    matrix.cookie.value.reject.items.cookie = "reject";
  };
}
