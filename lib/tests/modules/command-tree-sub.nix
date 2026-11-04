{ lib, ... }:
{
  imports = [
    (lib.modules.commandTree {
      directory = ./command-tree;
      package = {
        type = "derivation";
        name = "a";
        outPath = "/a";
      };
    }).prog.sub
  ];
}
