{
  lib,
  callPackage,
  symlinkJoin,
  vimUtils,
  tree-sitter,
  neovim,
  neovimUtils,
  runCommand,
  vimPlugins,
  writableTmpDirAsHomeHook,
}:

self: super:

let
  inherit (neovimUtils) grammarToPlugin;

  buildQueries =
    {
      language,
      requires ? [ ],
    }:
    vimUtils.toVimPlugin (
      runCommand "nvim-treesitter-queries-${language}"
        {
          passthru = {
            inherit language requires;
            isTreesitterQuery = true;
          };
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

  queriesWithDeps = lib.mapAttrs (
    lang: query:
    let
      requires = query.requires or [ ];
      dependencies = map (req: queries.${req}) requires;
    in
    if dependencies != [ ] then
      query.overrideAttrs (old: {
        passthru = old.passthru or { } // {
          inherit dependencies;
        };
      })
    else
      query
  ) queries;

  parsersWithQueries = lib.mapAttrs (
    lang: parser:
    if lib.hasAttr lang queriesWithDeps then
      parser.overrideAttrs (old: {
        passthru = old.passthru or { } // {
          associatedQuery = queriesWithDeps.${lang};
        };
      })
    else
      parser
  ) parsers;

  parsersWithMeta = lib.mapAttrs (
    lang: parser:
    let
      requires = parser.requires or [ ];
      dependencies = map (req: grammarToPlugin parsersWithQueries.${req}) requires;
    in
    if dependencies != [ ] then
      parser.overrideAttrs (old: {
        passthru = old.passthru or { } // {
          inherit dependencies;
        };
      })
    else
      parser
  ) parsersWithQueries;

  # add aliases so grammars from `tree-sitter` are overwritten in `withPlugins`
  # for example, for ocaml_interface, the following aliases will be added
  #   ocaml-interface
  #   tree-sitter-ocaml-interface
  #   tree-sitter-ocaml_interface
  builtGrammars =
    parsersWithMeta
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
    ) parsersWithMeta;

  allGrammars = lib.attrValues parsersWithMeta;

  # Usage:
  # pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [ p.c p.java ... ])
  # or for all grammars:
  # pkgs.vimPlugins.nvim-treesitter.withAllGrammars
  withPlugins =
    f:
    let
      selectedGrammars = f (tree-sitter.builtGrammars // builtGrammars);

      grammarPlugins = map grammarToPlugin selectedGrammars;

      queryPlugins = lib.pipe selectedGrammars [
        (map (g: g.associatedQuery or null))
        (lib.filter (q: q != null))
      ];
    in
    self.nvim-treesitter.overrideAttrs {
      passthru.dependencies = grammarPlugins ++ queryPlugins;
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
      ;

    queries = queriesWithDeps;
    parsers = grammarPlugins;

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

            nvim --headless -l "${withAllGrammars}/scripts/check-queries.lua" | tee log

            if grep -q Warning log; then
              echo "WARNING: warnings were emitted by the check"
              echo "Check if they were expected warnings!"
            fi
          '';

      no-queries-for-official-grammars =
        let
          pluginsToCheck = lib.filter lib.isDerivation (lib.attrValues vimPlugins.nvim-treesitter.parsers);
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

  meta = super.nvim-treesitter.meta or { } // {
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ figsoda ];
  };
}
