{ pkgs, lib }:

let
  libExt = pkgs.stdenv.hostPlatform.extensions.sharedLibrary;
  grammarToAttrSet = drv:
    {
      name = "lib/lib${lib.strings.removeSuffix "-grammar" (lib.strings.getName drv)}${libExt}";
      path = "${drv}/parser";
    };

  # Usage:
  # treesit-grammars.with-grammars (p: [ p.tree-sitter-bash p.tree-sitter-c ... ])
  with-grammars = fn: pkgs.linkFarm "emacs-treesit-grammars"
    (map grammarToAttrSet (fn pkgs.tree-sitter.builtGrammars));
in
{
  inherit with-grammars;

  with-all-grammars = with-grammars builtins.attrValues;
}
