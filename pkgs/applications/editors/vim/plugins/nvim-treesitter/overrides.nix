{ lib, callPackage, tree-sitter, neovim, runCommand }:

self: super:

let
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
    f: self.nvim-treesitter.overrideAttrs (_: {
      passthru.dependencies = map
        (grammar:
          let
            name = lib.pipe grammar [
              lib.getName

              # added in buildGrammar
              (lib.removeSuffix "-grammar")

              # grammars from tree-sitter.builtGrammars
              (lib.removePrefix "tree-sitter-")
              (lib.replaceStrings [ "-" ] [ "_" ])
            ];
          in

          runCommand "nvim-treesitter-${name}-grammar" { } ''
            mkdir -p $out/parser
            ln -s ${grammar}/parser $out/parser/${name}.so
          ''
        )
        (f (tree-sitter.builtGrammars // builtGrammars));
    });

  withAllGrammars = withPlugins (_: allGrammars);
in

{
  postPatch = ''
    rm -r parser
  '';

  passthru = {
    inherit builtGrammars allGrammars withPlugins withAllGrammars;

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
