{
  lib,
  callPackage,
  tree-sitter,
  neovim,
  neovimUtils,
  runCommand,
  vimPlugins,
  tree-sitter-grammars,
  writableTmpDirAsHomeHook,
}:

self: super:

let
  inherit (neovimUtils) grammarToPlugin;

  overrides = prev: {
  };

  generatedGrammars =
    let
      generated = callPackage ./generated.nix {
        inherit (tree-sitter) buildGrammar;
      };
    in
    lib.overrideExisting generated (overrides generated);

  generatedDerivations = lib.filterAttrs (_: lib.isDerivation) generatedGrammars;

  # add aliases so grammars from `tree-sitter` are overwritten in `withPlugins`
  # for example, for ocaml_interface, the following aliases will be added
  #   ocaml-interface
  #   tree-sitter-ocaml-interface
  #   tree-sitter-ocaml_interface
  builtGrammars =
    generatedGrammars
    // lib.concatMapAttrs (
      k: v:
      let
        replaced = lib.replaceStrings [ "_" ] [ "-" ] k;
      in
      {
        "tree-sitter-${k}" = v;
      }
      // lib.optionalAttrs (k != replaced) {
        ${replaced} = v;
        "tree-sitter-${replaced}" = v;
      }
    ) generatedDerivations;

  allGrammars = lib.attrValues generatedDerivations;

  # Usage:
  # pkgs.vimPlugins.nvim-treesitter-legacy.withPlugins (p: [ p.c p.java ... ])
  # or for all grammars:
  # pkgs.vimPlugins.nvim-treesitter-legacy.withAllGrammars
  withPlugins =
    f:
    self.nvim-treesitter-legacy.overrideAttrs {
      passthru.dependencies = map grammarToPlugin (f (tree-sitter.builtGrammars // builtGrammars));
    };

  withAllGrammars = withPlugins (_: allGrammars);
in

{
  postPatch = ''
    rm -r parser
  '';

  passthru = (super.nvim-treesitter-legacy.passthru or { }) // {
    inherit
      builtGrammars
      allGrammars
      grammarToPlugin
      withPlugins
      withAllGrammars
      ;

    grammarPlugins = lib.mapAttrs (_: grammarToPlugin) generatedDerivations;
    parsers = lib.recurseIntoAttrs vimPlugins.nvim-treesitter.grammarPlugins;
  };

  meta =

    (super.nvim-treesitter-legacy.meta or { }) // {
      license = lib.licenses.asl20;
      maintainers = [ ];
    };
}
