{ lib, ... }:
let
  deathtrapArgs = lib.mapAttrs (
    k: _: throw "The module system is too strict, accessing an unused option's ${k} mkOption-attribute."
  ) (lib.functionArgs lib.mkOption);
in
{
  options.nest.foo = lib.mkOption {
    type = lib.types.bool;
    default = false;
  };
  options.nest.unused = lib.mkOption deathtrapArgs;
  config.nest.bar = "bar";
}
