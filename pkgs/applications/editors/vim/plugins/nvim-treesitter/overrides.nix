{
  lib,
  callPackage,
<<<<<<< HEAD
  symlinkJoin,
  vimUtils,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  tree-sitter,
  neovim,
  neovimUtils,
  runCommand,
  vimPlugins,
<<<<<<< HEAD
=======
  tree-sitter-grammars,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  writableTmpDirAsHomeHook,
}:

self: super:

let
  inherit (neovimUtils) grammarToPlugin;

<<<<<<< HEAD
  buildQueries =
    { language }:
    vimUtils.toVimPlugin (
      runCommand "nvim-treesitter-queries-${language}"
        {
          passthru = { inherit language; };
          meta.description = "Queries for ${language} from nvim-treesitter";
        }
        ''
          mkdir -p "$out/queries"
          if [ -d "${super.nvim-treesitter.src}/runtime/queries/${language}" ]; then
            ln -s "${super.nvim-treesitter.src}/runtime/queries/${language}" "$out/queries/${language}"
          else
            echo "Error: there are no queries for ${language}."
            exit 1
          fi
        ''
    );

  generated = callPackage ./generated.nix {
    inherit (tree-sitter) buildGrammar;
    inherit buildQueries;
  };

  inherit (generated) parsers queries;

  parsersWithMeta = lib.mapAttrs (
    lang: parser:
    if lib.hasAttr lang queries then
      parser.overrideAttrs (old: {
        passthru = (old.passthru or { }) // {
          associatedQuery = queries.${lang};
        };
      })
    else
      parser
  ) parsers;
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # add aliases so grammars from `tree-sitter` are overwritten in `withPlugins`
  # for example, for ocaml_interface, the following aliases will be added
  #   ocaml-interface
  #   tree-sitter-ocaml-interface
  #   tree-sitter-ocaml_interface
  builtGrammars =
<<<<<<< HEAD
    parsersWithMeta
=======
    generatedGrammars
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    ) parsersWithMeta;

  allGrammars = lib.attrValues parsersWithMeta;
=======
    ) generatedDerivations;

  allGrammars = lib.attrValues generatedDerivations;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # Usage:
  # pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [ p.c p.java ... ])
  # or for all grammars:
  # pkgs.vimPlugins.nvim-treesitter.withAllGrammars
  withPlugins =
    f:
<<<<<<< HEAD
    let
      selectedGrammars = f (tree-sitter.builtGrammars // builtGrammars);

      grammarPlugins = map grammarToPlugin selectedGrammars;

      queryPlugins = lib.pipe selectedGrammars [
        (map (g: g.passthru.associatedQuery or null))
        (lib.filter (q: q != null))
      ];
    in
    self.nvim-treesitter.overrideAttrs {
      passthru.dependencies = [
        (symlinkJoin {
          name = "nvim-treesitter-grammars";
          paths = grammarPlugins ++ queryPlugins;
        })
      ];
    };

  withAllGrammars = withPlugins (_: allGrammars);
  grammarPlugins = lib.mapAttrs (_: grammarToPlugin) parsersWithMeta;
in
{
  nvimSkipModules = [ "nvim-treesitter._meta.parsers" ];

  passthru = super.nvim-treesitter.passthru or { } // {
    inherit
      buildQueries
      builtGrammars
      allGrammars
      grammarPlugins
      grammarToPlugin
      withPlugins
      withAllGrammars
      queries
      ;

    parsers = grammarPlugins;
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    tests = {
      check-queries =
        let
          nvimWithAllGrammars = neovim.override {
            configure.packages.all.start = [ withAllGrammars ];
          };
        in
        runCommand "nvim-treesitter-check-queries"
          {
            nativeBuildInputs = [
              nvimWithAllGrammars
              writableTmpDirAsHomeHook
            ];
            CI = true;
          }
          ''
            touch $out
            ln -s ${withAllGrammars}/CONTRIBUTING.md .
            export ALLOWED_INSTALLATION_FAILURES=ipkg,norg,verilog

<<<<<<< HEAD
            nvim --headless -l "${withAllGrammars}/scripts/check-queries.lua" | tee log
=======
            nvim --headless "+luafile ${withAllGrammars}/scripts/check-queries.lua" | tee log
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

            if grep -q Warning log; then
              echo "WARNING: warnings were emitted by the check"
              echo "Check if they were expected warnings!"
            fi
          '';

<<<<<<< HEAD
      no-queries-for-official-grammars =
        let
          pluginsToCheck = lib.filter lib.isDerivation (lib.attrValues vimPlugins.nvim-treesitter.parsers);
=======
      tree-sitter-queries-are-present-for-custom-grammars =
        let
          pluginsToCheck =
            map (grammar: grammarToPlugin grammar)
              # non-derivations are here because there is a `recurseForDerivations = true`
              (lib.filter lib.isDerivation (lib.attrValues tree-sitter-grammars));
        in
        runCommand "nvim-treesitter-test-queries-are-present-for-custom-grammars" { CI = true; } ''
          touch "$out"

          function check_grammar {
            local grammar_name="$1"
            local grammar_path="$2"

            local grammar_queries=$(find -L "$grammar_path/queries/$grammar_name" -name '*.scm')
            local EXPECTED_FILES="$grammar_path/parser/$grammar_name.so $grammar_queries"

            echo ""
            echo "expected files for $grammar_name:"
            echo "$EXPECTED_FILES"

            # the derivation has only symlinks, and `find` doesn't count them as files
            # so we cannot use `-type f`, thus we use `-not -type d`
            for file in $(find -L $2 -not -type d); do
              echo "checking $file"
              # see https://stackoverflow.com/a/8063284
              if ! echo "$EXPECTED_FILES" | grep -wqF "$file"; then
                echo "$file is unexpected, exiting"
                exit 1
              fi
            done
          }

          ${lib.concatLines (lib.forEach pluginsToCheck (g: "check_grammar \"${g.grammarName}\" \"${g}\""))}
        '';

      no-queries-for-official-grammars =
        let
          pluginsToCheck = lib.filter lib.isDerivation (lib.attrValues vimPlugins.nvim-treesitter-parsers);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
        in
        runCommand "nvim-treesitter-test-no-queries-for-official-grammars" { CI = true; } ''
          touch "$out"

          function check_grammar {
            local grammar_name="$1"
            local grammar_path="$2"

            echo "checking $1..."
            if [ -d "$grammar_path/queries" ]; then
              echo "Queries directory exists in $grammar_name"
              echo "This is unexpected, see https://github.com/NixOS/nixpkgs/pull/344849#issuecomment-2381447839"
              exit 1
            fi
          }

          ${lib.concatLines (lib.forEach pluginsToCheck (g: "check_grammar \"${g.grammarName}\" \"${g}\""))}
        '';
    };
  };

<<<<<<< HEAD
  meta = super.nvim-treesitter.meta or { } // {
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
=======
  meta =
    with lib;
    (super.nvim-treesitter.meta or { })
    // {
      license = licenses.asl20;
      maintainers = [ ];
    };
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}
