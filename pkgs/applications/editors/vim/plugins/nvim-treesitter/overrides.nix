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
  #   pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [ p.c p.java ... ])
  # or for all grammars:
  #   pkgs.vimPlugins.nvim-treesitter.withAllGrammars
  # you can also filter out plugins (e.g. if there are duplicates):
  #   pkgs.vimPlugins.nvim-treesitter.withAllGrammars.filterOutGrammars (e: e.meta.name == "c-grammar-0.0.0+rev=deca017")
  # or use `e.name`, which contains `vimplugin-treesitter-grammar-c` (no version and rev)
  # function provided to `filterOutGrammars` is passed to `lib.filter`
  withPlugins =
    f: self.nvim-treesitter.overrideAttrs {
      passthru = let
        grammars = map grammarToPlugin
          (f (tree-sitter.builtGrammars // builtGrammars));

        filterDuplicateGrammars = lib.lists.foldl' (
          res: new-el:
            if lib.lists.any (old-el:
              # `meta.name` contains something like `c-grammar-0.0.0+rev=be23d2c`
              # while `name` contains `vimplugin-treesitter-grammar-c`
              if new-el.meta.name == old-el.meta.name
              then true
              else if new-el.name == old-el.name
                then builtins.trace ''
                  error: found duplicate grammars (${new-el.meta.name} and ${old-el.meta.name}). use '.filterOutGrammars' to filter out duplicates
                  example: 'vimPlugins.nvim-treesitter.withAllGrammars.filterOutGrammars (e: e.meta.name == "${new-el.meta.name}")'
                '' false
                else false
            ) res
            then res
            else res ++ [ new-el ]
        ) [ ];

        copyGrammar = grammar:
          let name = lib.last (lib.splitString "-" grammar.name); in
          "ln -s ${grammar}/parser/${name}.so $out/parser/${name}.so";

        collateGrammars = grammars:
          [
            (runCommand "vimplugin-treesitter-grammars"
              { meta.platforms = lib.platforms.all; }
              ''
                mkdir -p $out/parser
                ${lib.concatMapStringsSep "\n" copyGrammar (filterDuplicateGrammars grammars)}
              '')
          ];
      in {
        dependencies = collateGrammars grammars;

        filterOutPlugins = filter: self.nvim-treesitter.overrideAttrs {
          passthru.dependencies = collateGrammars (lib.filter filter grammars);
        };
      };
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
