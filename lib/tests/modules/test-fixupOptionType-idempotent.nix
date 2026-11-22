{ lib, ... }:

let
  inherit (lib) mkOption types;
  decl = file: name: {
    _file = file;
    pos = null;
    options = mkOption {
      type = types.submodule { options.${name} = mkOption { type = types.int; }; };
    };
  };
  merged =
    lib.mergeOptionDecls
      [ "s" ]
      [
        (decl "a.nix" "x")
        (decl "b.nix" "y")
      ];
  once = lib.fixupOptionType [ "s" ] merged;
  twice = lib.fixupOptionType [ "s" ] once;
  subOptions = opt: lib.attrNames (removeAttrs (opt.type.getSubOptions [ ]) [ "_module" ]);
in

{
  options.result = mkOption { };
  config.result =
    assert
      subOptions once == [
        "x"
        "y"
      ];
    # Fixing up an already fixed-up option must not drop its submodules.
    assert subOptions twice == subOptions once;
    true;
}
