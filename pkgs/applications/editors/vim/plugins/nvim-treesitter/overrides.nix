{
  lib,
  callPackage,
  tree-sitter,
  neovim,
  neovimUtils,
  runCommand,
  vimPlugins,
  tree-sitter-grammars,
}:

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
  # pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [ p.c p.java ... ])
  # or for all grammars:
  # pkgs.vimPlugins.nvim-treesitter.withAllGrammars
  withPlugins =
    f:
    self.nvim-treesitter.overrideAttrs {
      passthru.dependencies = map grammarToPlugin (f (tree-sitter.builtGrammars // builtGrammars));
    };

  withAllGrammars = withPlugins (_: allGrammars);
in

{
  postPatch = ''
    rm -r parser
  '';

  passthru = (super.nvim-treesitter.passthru or { }) // {
    inherit
      builtGrammars
      allGrammars
      grammarToPlugin
      withPlugins
      withAllGrammars
      ;

    grammarPlugins = lib.mapAttrs (_: grammarToPlugin) generatedDerivations;

    tests = {
      check-queries =
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

      tree-sitter-queries-are-present-for-custom-grammars =
        let
          pluginsToCheck =
            builtins.map (grammar: grammarToPlugin grammar)
              # true is here because there is `recurseForDerivations = true`
              (lib.remove true (lib.attrValues tree-sitter-grammars));
        in
        runCommand "nvim-treesitter-test-queries-are-present-for-custom-grammars" { CI = true; } ''
          function check_grammar {
            EXPECTED_FILES="$2/parser/$1.so `ls $2/queries/$1/*.scm`"

            echo
            echo expected files for $1:
            echo $EXPECTED_FILES

            # the derivation has only symlinks, and `find` doesn't count them as files
            # so we cannot use `-type f`
            for file in `find $2 -not -type d`; do
              echo checking $file
              # see https://stackoverflow.com/a/8063284
              if ! echo "$EXPECTED_FILES" | grep -wqF "$file"; then
                echo $file is unexpected, exiting
                exit 1
              fi
            done
          }

          ${lib.concatLines (lib.forEach pluginsToCheck (g: "check_grammar \"${g.grammarName}\" \"${g}\""))}
          touch $out
        '';

      no-queries-for-official-grammars =
        let
          pluginsToCheck =
            # true is here because there is `recurseForDerivations = true`
            (lib.remove true (lib.attrValues vimPlugins.nvim-treesitter-parsers));
        in
        runCommand "nvim-treesitter-test-no-queries-for-official-grammars" { CI = true; } ''
          touch $out

          function check_grammar {
            echo checking $1...
            if [ -d $2/queries ]; then
              echo Queries dir exists in $1
              echo This is unexpected, see https://github.com/NixOS/nixpkgs/pull/344849#issuecomment-2381447839
              exit 1
            fi
          }

          ${lib.concatLines (lib.forEach pluginsToCheck (g: "check_grammar \"${g.grammarName}\" \"${g}\""))}
        '';
    };
  };

  meta =
    with lib;
    (super.nvim-treesitter.meta or { })
    // {
      license = licenses.asl20;
      maintainers = with maintainers; [ figsoda ];
    };
  nvimRequireCheck = "nvim-treesitter";
}
