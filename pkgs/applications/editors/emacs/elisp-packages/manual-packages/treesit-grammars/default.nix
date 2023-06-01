{ pkgs, lib, tree-sitter, ... }:

let
  libExt = pkgs.stdenv.targetPlatform.extensions.sharedLibrary;
  grammarToAttrSet = drv:
      {
        name = "lib/lib${lib.strings.removeSuffix "-grammar" (lib.strings.getName drv)}${libExt}";
        path = "${drv}/parser";
      };
in
{
  with-all-grammars = pkgs.linkFarm "emacs-treesit-grammars"
    (map grammarToAttrSet pkgs.tree-sitter.allGrammars);

  # Use this one like this:
  # treesit-grammars.with-grammars (grammars: with grammars; [tree-sitter-bash])
  with-grammars = fn: pkgs.linkFarm "emacs-treesit-grammars"
    (map grammarToAttrSet (fn pkgs.tree-sitter.builtGrammars));
}
