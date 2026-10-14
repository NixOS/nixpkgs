{ lib, options, ... }:
let
  inherit (lib) mkOption mkMerge types;
in
{
  imports = [
    {
      _file = "the-defs-file.nix";
      config.flags.my-flag = 3.14;
    }
  ];

  options.flags = mkOption {
    type = types.attrListWith {
      elemType = types.anything;
      asAttrs = true;
      mergeAttrValues = _name: vs: lib.head vs;
    };
  };
  options.argv = mkOption { type = types.listOf types.str; };

  # Feed definitions into argv; the float from the-defs-file.nix should cause
  # a type error mentioning that file
  config.argv = mkMerge options.flags.valueMeta.definitions;
}
