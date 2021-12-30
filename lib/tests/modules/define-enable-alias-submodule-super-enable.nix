{ lib, options, ... }:

{
  config.enable = lib.mkForEachSubModule
    (eval: lib.mkAliasDefinitions eval.options.super.enable)
    options.submodule;
}
