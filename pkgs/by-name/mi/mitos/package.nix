{
  lib,
  runCommand,
  symlinkJoin,
  makeBinaryWrapper,
  stdenv,
  helix,
  mitos-unwrapped,
  tree-sitter,
  writers,
  pkgs,
  lockedGrammars ? lib.importJSON ./grammars.json,
  grammarsOverlay ? null,
}:

let
  defaultGrammarsOverlay = lib.composeManyExtensions [
    (
      final: prev:
      # perl is already fixed in the revision mitos pins
      lib.filterAttrs (k: _: k != "tree-sitter-perl") (helix.defaultGrammarsOverlay final prev)
    )
    (
      final: prev:
      # not packaged in nixpkgs yet, built straight from grammars.json
      lib.mapAttrs' (
        language: locked:
        lib.nameValuePair "tree-sitter-${language}" (
          tree-sitter.buildGrammar {
            inherit language;
            version = lib.sources.shortRev locked.nurl.args.rev;
            src = pkgs.${locked.nurl.fetcher} locked.nurl.args;
            location = locked.subpath;
          }
        )
      ) (lib.filterAttrs (name: _: !(prev ? "tree-sitter-${name}")) lockedGrammars)
      // {
        # already fixed in the revision mitos pins
        tree-sitter-tlaplus = prev.tree-sitter-tlaplus.overrideAttrs { dontPatch = true; };
      }
      # bindings/swift has case-colliding dirs that merge on Darwin
      //
        lib.mapAttrs'
          (
            language: hash:
            lib.nameValuePair "tree-sitter-${language}" (
              prev."tree-sitter-${language}".overrideAttrs {
                src = pkgs.${lockedGrammars.${language}.nurl.fetcher} (
                  lockedGrammars.${language}.nurl.args
                  // {
                    inherit hash;
                    postFetch = "rm -rf $out/bindings/swift";
                  }
                );
              }
            )
          )
          {
            gdscript = "sha256-hwI+Pohl3hPsNt2nXWMsvbAPvAqQBkJA4jPDmyi9sfA=";
            rpmspec = "sha256-BtQLFMo7ILRfwWN5/ow/GiTrZNOyGljlNosoRDCc8xM=";
          }
    )
  ];

  # helix's grammar builds, pinned to mitos' revisions
  grammars =
    (helix.override {
      inherit lockedGrammars;
      grammarsOverlay = lib.defaultTo defaultGrammarsOverlay grammarsOverlay;
    }).passthru.tree-sitter-grammars;

  # mitos loads grammars/<exact languages.toml name>, but nixpkgs' names mix
  # `-` and `_`; match on the `-` form and link each one under its real name,
  # failing on any grammar mitos uses that we didn't build
  linkGrammars = writers.writePython3Bin "mitos-link-grammars" { } ''
    import os
    import sys
    import tomllib

    # args: output dir, library extension, languages.toml, then one
    # <language>==<store path> per built grammar
    out, ext, languages_toml, *grammars = sys.argv[1:]

    # grammars mitos wants, minus the ones it opts out of
    with open(languages_toml, "rb") as f:
        config = tomllib.load(f)
    excluded = config.get("use-grammars", {}).get("except", [])

    # index built grammars by their `-` name, the only form both sides share
    built = {}
    for entry in grammars:
        language, path = entry.split("==", 1)
        key = language.replace("_", "-")
        # fail on duplicates: two grammars with the same `-` name
        # (e.g. foo_bar and foo-bar) would silently overwrite each other
        if key in built:
            sys.exit(f"two grammars normalize to {key}")
        built[key] = path

    # link every wanted grammar under its exact languages.toml name
    grammars_dir = os.path.join(out, "grammars")
    os.makedirs(grammars_dir)
    for grammar in config["grammar"]:
        name = grammar["name"]
        if name in excluded:
            continue
        path = built.get(name.replace("_", "-"))
        if path is None:
            sys.exit(f"grammar {name} from languages.toml was not built")
        os.symlink(path + "/parser", os.path.join(grammars_dir, name + ext))
  '';

  # mitos expects .dylib on Darwin.
  grammarsRuntime =
    runCommand "mitos-grammars"
      {
        ext = stdenv.hostPlatform.extensions.sharedLibrary;
      }
      ''
        ${lib.getExe linkGrammars} $out $ext ${mitos-unwrapped.src}/languages.toml ${
          lib.concatMapAttrsStringSep " " (_: grammar: "${grammar.language}==${grammar}") grammars
        }
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
    wrapProgram $out/bin/ms --set-default MITOS_RUNTIME "${grammarsRuntime}"
  '';

  passthru = {
    runtime = grammarsRuntime;
    tree-sitter-grammars = grammars;
    inherit defaultGrammarsOverlay;
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
