{ lib, callPackage, tree-sitter, nodejs }:

self: super:

let
  generatedGrammars = callPackage ./generated.nix {
    buildGrammar = callPackage ../../../../../development/tools/parsing/tree-sitter/grammar.nix { };
  };

  generatedDerivations = lib.filterAttrs (_: lib.isDerivation) generatedGrammars;

  # add aliases so grammars from `tree-sitter` are overwritten in `withPlugins`
  # for example, for ocaml_interface, the following aliases will be added
  #   ocaml-interface
  #   tree-sitter-ocaml-interface
  #   tree-sitter-ocaml_interface
  builtGrammars = generatedGrammars // lib.listToAttrs
    (lib.concatLists (lib.mapAttrsToList
      (k: v:
        let
          replaced = lib.replaceStrings [ "_" ] [ "-" ] k;
        in
        map (lib.flip lib.nameValuePair v)
          ([ ("tree-sitter-${k}") ] ++ lib.optionals (k != replaced) [
            replaced
            "tree-sitter-${replaced}"
          ]))
      generatedDerivations));

  allGrammars = lib.attrValues generatedDerivations;

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

  meta.maintainers = with lib.maintainers; [ figsoda ];
}

