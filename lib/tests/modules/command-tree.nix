{ lib, ... }:
let
  tree =
    name:
    lib.modules.commandTree {
      directory = ./command-tree;
      package = {
        type = "derivation";
        inherit name;
        outPath = "/${name}";
      };
    };
in
{
  imports = [
    (tree "a").prog.commands.sub.commands.subsub
    # Not a conflict: this node sets the same package.
    (tree "a").prog
  ];
  options.names = lib.mkOption {
    default = lib.attrNames (tree "a").prog.commands;
  };
}
