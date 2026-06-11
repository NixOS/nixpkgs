{ pkgs, lib }:

let
  libExt = pkgs.stdenv.hostPlatform.extensions.sharedLibrary;
  grammarToAttrSet = drv: {
    name = "lib/lib${
      lib.strings.replaceStrings [ "_" ] [ "-" ] (
        lib.strings.removeSuffix "-grammar" (lib.strings.getName drv)
      )
    }${libExt}";
    path = "${drv}/parser";
  };

  grammarPackage = grammars: pkgs.linkFarm "emacs-treesit-grammars" (map grammarToAttrSet grammars);

  # Usage:
  # treesit-grammars.with-grammars (p: [ p.tree-sitter-bash p.tree-sitter-c ... ])
  with-grammars = fn: grammarPackage (fn pkgs.tree-sitter.builtGrammars);

  with-all-grammars = grammarPackage pkgs.tree-sitter.allGrammars;
in
{
  inherit with-grammars with-all-grammars;
}
