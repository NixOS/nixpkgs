{ lib, callPackage, tree-sitter, neovim, neovimUtils, runCommand }:

self: super:

let
  inherit (neovimUtils) grammarToPlugin;
  generatedGrammars = callPackage ./generated.nix {
    inherit (tree-sitter) buildGrammar;
  };

  generatedDerivations = lib.filterAttrs (_: lib.isDerivation) generatedGrammars;

  # add aliases so grammars from `tree-sitter` are overwritten in `withPlugins`
  # for example, for ocaml_interface, the following aliases will be added
  #   ocaml-interface
  #   tree-sitter-ocaml-interface
  #   tree-sitter-ocaml_interface
  builtGrammars = generatedGrammars // lib.concatMapAttrs
    (k: v:
      let
        replaced = lib.replaceStrings [ "_" ] [ "-" ] k;
      in
      {
        "tree-sitter-${k}" = v;
      } // lib.optionalAttrs (k != replaced) {
        ${replaced} = v;
        "tree-sitter-${replaced}" = v;
      })
    generatedDerivations;

  allGrammars = lib.attrValues generatedDerivations;

  # Usage:
  # pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [ p.c p.java ... ])
  # or for all grammars:
  # pkgs.vimPlugins.nvim-treesitter.withAllGrammars
  withPlugins =
    f: self.nvim-treesitter.overrideAttrs {
      passthru.dependencies =
        let
          grammars = map grammarToPlugin
            (f (tree-sitter.builtGrammars // builtGrammars));
          copyGrammar = grammar:
            let name = lib.last (lib.splitString "-" grammar.name); in
            "ln -sf ${grammar}/parser/${name}.so $out/parser/${name}.so";
        in
        [
          (runCommand "vimplugin-treesitter-grammars"
            { meta.platforms = lib.platforms.all; }
            ''
              mkdir -p $out/parser
              ${lib.concatMapStringsSep "\n" copyGrammar grammars}
            '')
        ];
    };

  withAllGrammars = withPlugins (_: allGrammars);
in

{
  postPatch = ''
    rm -r parser
  '';

  passthru = (super.nvim-treesitter.passthru or { }) // {
    inherit builtGrammars allGrammars grammarToPlugin withPlugins withAllGrammars;

    grammarPlugins = lib.mapAttrs (_: grammarToPlugin) generatedDerivations;

    tests.check-queries =
      let
        nvimWithAllGrammars = neovim.override {
          configure.packages.all.start = [ withAllGrammars ];
        };
      in
      runCommand "nvim-treesitter-check-queries"
        {
          nativeBuildInputs = [ nvimWithAllGrammars ];
          CI = true;
        }
        ''
          touch $out
          export HOME=$(mktemp -d)
          ln -s ${withAllGrammars}/CONTRIBUTING.md .

          nvim --headless "+luafile ${withAllGrammars}/scripts/check-queries.lua" | tee log

          if grep -q Warning log; then
            echo "Error: warnings were emitted by the check"
            exit 1
          fi
        '';
  };

  meta = with lib; (super.nvim-treesitter.meta or { }) // {
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
