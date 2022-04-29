{ config, lib, ... }:
let inherit (lib) types mkOption attrNames;
in
{
  options = {
    attrs = mkOption { type = types.attrsOf lib.types.int; };
    result = mkOption { };
    resultFoo = mkOption { };
    resultFooBar = mkOption { };
    resultFooFoo = mkOption { };
  };
  config = {
    attrs.a = 1;
    variants.foo.attrs.b = 1;
    variants.bar.attrs.y = 1;
    variants.foo.variants.bar.attrs.z = 1;
    variants.foo.variants.foo.attrs.c = 3;
    resultFoo = lib.concatMapStringsSep " " toString (attrNames config.variants.foo.attrs);
    resultFooBar = lib.concatMapStringsSep " " toString (attrNames config.variants.foo.variants.bar.attrs);
    resultFooFoo = lib.concatMapStringsSep " " toString (attrNames config.variants.foo.variants.foo.attrs);
  };
}
