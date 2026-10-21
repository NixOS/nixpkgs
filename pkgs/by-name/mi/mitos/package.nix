{
  lib,
  runCommand,
  symlinkJoin,
  makeBinaryWrapper,
  stdenv,
  helix,
  mitos-unwrapped,
  removeReferencesTo,
  tree-sitter,
  python3,
  pkgs,
}:

let
  lockedGrammars = lib.importJSON ./grammars.json;

  # helix's grammar builds, pinned to mitos' revisions
  grammars =
    let
      helixGrammars = (helix.override { inherit lockedGrammars; }).passthru.tree-sitter-grammars;

      # not packaged in nixpkgs yet, built straight from grammars.json
      extraGrammars = lib.mapAttrs' (
        language: locked:
        lib.nameValuePair "tree-sitter-${language}" (
          tree-sitter.buildGrammar {
            inherit language;
            version = lib.sources.shortRev locked.nurl.args.rev;
            src = pkgs.${locked.nurl.fetcher} locked.nurl.args;
            location = locked.subpath;
          }
        )
      ) (lib.filterAttrs (name: _: !(helixGrammars ? "tree-sitter-${name}")) lockedGrammars);
    in
    extraGrammars
    // helixGrammars
    // {
      # already fixed in the revisions mitos pins
      tree-sitter-perl = helixGrammars.tree-sitter-perl.overrideAttrs { postPatch = ""; };
      tree-sitter-tlaplus = helixGrammars.tree-sitter-tlaplus.overrideAttrs { dontPatch = true; };
    };

  # mitos expects .dylib on Darwin.
  grammarsRuntime =
    runCommand "mitos-grammars"
      {
        nativeBuildInputs = [ python3 ];
        ext = stdenv.hostPlatform.extensions.sharedLibrary;
      }
      ''
        # nixpkgs' grammar names mix `-` and `_`; install with `-` only first
        ${lib.concatMapAttrsStringSep "\n" (
          _: grammar:
          let
            file = "$out/grammars/${lib.replaceStrings [ "_" ] [ "-" ] grammar.language}$ext";
          in
          ''
            install -D ${grammar}/parser ${file}
            ${lib.getExe removeReferencesTo} -t ${grammar} ${file}
          ''
        ) grammars}

        # mitos loads grammars/<exact languages.toml name>, so rename to that
        # and fail on any grammar it uses that we didn't build
        python3 -c '
        import os, sys, tomllib
        ext = os.environ["ext"]
        config = tomllib.load(open(sys.argv[1], "rb"))
        excluded = config.get("use-grammars", {}).get("except", [])
        os.chdir(os.environ["out"] + "/grammars")
        for grammar in config["grammar"]:
            name = grammar["name"]
            if name in excluded:
                continue
            built = name.replace("_", "-") + ext
            if not os.path.exists(built):
                sys.exit(f"grammar {name} from languages.toml was not built")
            os.rename(built, name + ext)
        ' ${mitos-unwrapped.src}/languages.toml
      '';
in

symlinkJoin {
  pname = "mitos";
  inherit (mitos-unwrapped) version;

  __structuredAttrs = true;
  strictDeps = true;

  paths = [ mitos-unwrapped ];
  nativeBuildInputs = [ makeBinaryWrapper ];

  postBuild = ''
    wrapProgram $out/bin/ms --set MITOS_RUNTIME "${grammarsRuntime}"
  '';

  passthru = {
    runtime = grammarsRuntime;
    tree-sitter-grammars = grammars;
    updateScript = [
      helix.passthru.updateSh
      "mitos"
    ];
  };

  meta = {
    inherit (mitos-unwrapped.meta)
      description
      homepage
      changelog
      license
      mainProgram
      maintainers
      ;
  };
}
