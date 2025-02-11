{ lib, ... }:
let
  deathtrapArgs = lib.mapAttrs (
    k: _: throw "The module system is too strict, accessing an unused option's ${k} mkOption-attribute."
  ) (lib.functionArgs lib.mkOption);
in
{
  options.value = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    default = { };
  };
  options.testing-laziness-so-don't-read-me = lib.mkOption deathtrapArgs;
}
