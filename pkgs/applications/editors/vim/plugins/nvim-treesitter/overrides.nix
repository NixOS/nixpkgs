{ lib, callPackage, tree-sitter, nodejs }:

self: super:

let
  builtGrammars = callPackage ./generated.nix {
    buildGrammar = callPackage ../../../../../development/tools/parsing/tree-sitter/grammar.nix { };
  };

  allGrammars = lib.filter lib.isDerivation (lib.attrValues builtGrammars);

  # Usage:
  # pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [ p.c p.java ... ])
  # or for all grammars:
  # pkgs.vimPlugins.nvim-treesitter.withAllGrammars
  withPlugins =
    grammarFn: self.nvim-treesitter.overrideAttrs (_: {
      postPatch =
        let
          grammars = tree-sitter.withPlugins (ps: grammarFn (ps // builtGrammars));
        in
        ''
          rm -r parser
          ln -s ${grammars} parser
        '';
    });
in

{
  passthru = {
    inherit builtGrammars allGrammars withPlugins;

    tests.builtGrammars = lib.recurseIntoAttrs builtGrammars;

    withAllGrammars = withPlugins (_: allGrammars);
  };
}

