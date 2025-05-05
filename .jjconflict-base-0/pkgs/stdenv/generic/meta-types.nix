{ lib }:
# Simple internal type checks for meta.
# This file is not a stable interface and may be changed arbitrarily.
#
# TODO: add a method to the module system types
#       see https://github.com/NixOS/nixpkgs/pull/273935#issuecomment-1854173100
let
  inherit (builtins)
    isString
    isInt
    isAttrs
    isList
    all
    any
    attrValues
    isFunction
    isBool
    concatStringsSep
    isFloat
    ;
  isTypeDef = t: isAttrs t && t ? name && isString t.name && t ? verify && isFunction t.verify;

in
lib.fix (self: {
  string = {
    name = "string";
    verify = isString;
  };
  str = self.string; # Type alias

  any = {
    name = "any";
    verify = _: true;
  };

  int = {
    name = "int";
    verify = isInt;
  };

  float = {
    name = "float";
    verify = isFloat;
  };

  bool = {
    name = "bool";
    verify = isBool;
  };

  attrs = {
    name = "attrs";
    verify = isAttrs;
  };

  list = {
    name = "list";
    verify = isList;
  };

  attrsOf =
    t:
    assert isTypeDef t;
    let
      inherit (t) verify;
    in
    {
      name = "attrsOf<${t.name}>";
      verify =
        # attrsOf<any> can be optimised to just isAttrs
        if t == self.any then isAttrs else attrs: isAttrs attrs && all verify (attrValues attrs);
    };

  listOf =
    t:
    assert isTypeDef t;
    let
      inherit (t) verify;
    in
    {
      name = "listOf<${t.name}>";
      verify =
        # listOf<any> can be optimised to just isList
        if t == self.any then isList else v: isList v && all verify v;
    };

  union =
    types:
    assert all isTypeDef types;
    let
      # Store a list of functions so we don't have to pay the cost of attrset lookups at runtime.
      funcs = map (t: t.verify) types;
    in
    {
      name = "union<${concatStringsSep "," (map (t: t.name) types)}>";
      verify = v: any (func: func v) funcs;
    };
})
