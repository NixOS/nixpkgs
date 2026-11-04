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
    (tree "a").prog
    (tree "b").prog.commands.sub
  ];
}
