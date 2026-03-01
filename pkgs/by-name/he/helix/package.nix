{
  fetchFromGitHub,
  lib,
  rustPlatform,
  mdbook,
  gitMinimal,
  installShellFiles,
  versionCheckHook,
  runCommand,
  removeReferencesTo,
  pkgs,
  tree-sitter,
  lockedGrammars ? lib.importJSON ./grammars.json,
  grammarsOverlay ? (
    final: prev: {
      tree-sitter-sql = prev.tree-sitter-sql.override {
        generate = false;
      };
      tree-sitter-qmljs = prev.tree-sitter-qmljs.overrideAttrs {
        dontCheckForBrokenSymlinks = true;
      };
    }
  ),
}:

rustPlatform.buildRustPackage (
  finalAttrs:
  let
    lockedVersionsOverlay =
      final: prev:
      lib.mapAttrs (
        drvName: grammar:
        let
          lockedGrammar = lockedGrammars.${lib.removePrefix "tree-sitter-" drvName};
        in
        (prev.${drvName}.override {
          location = lockedGrammar.subpath;
        }).overrideAttrs
          {
            version = lib.sources.shortRev lockedGrammar.nurl.args.rev;
            src = (pkgs.${lockedGrammar.nurl.fetcher} lockedGrammar.nurl.args);
          }
      ) prev;

    tree-sitter-grammars =
      lib.filterAttrs (drvName: _: lib.hasAttr (lib.removePrefix "tree-sitter-" drvName) lockedGrammars)
        (
          tree-sitter.grammarsScope.overrideScope (
            lib.composeExtensions lockedVersionsOverlay grammarsOverlay
          )
        );

    # Dynamic libraries for the grammars always use the `.so` extension, also on Darwin (should use `.dylib`)
    # See here: https://github.com/helix-editor/helix/pull/14982
    # Switch to `stdenv.hostPlatform.extensions.sharedLibrary` once the fix above reaches the next release

    grammarsFarm = runCommand "helix-grammars" { } (
      lib.concatMapAttrsStringSep "\n" (_: grammar: ''
        install -D ${grammar}/parser $out/${grammar.language}.so
        ${lib.getExe removeReferencesTo} -t ${grammar} $out/${grammar.language}.so
      '') (lib.filterAttrs (_: lib.isDerivation) tree-sitter-grammars)
    );

    lockedGrammarsCount = lib.length (lib.attrNames lockedGrammars);

    runtimeDir = runCommand "helix-runtime" { } ''
      cp -r --no-preserve=mode ${finalAttrs.src}/runtime $out
      rm -r $out/grammars
      ln -s ${grammarsFarm} $out/grammars
      count=$(ls -1 "$out/grammars/" | wc -l)
      if [ "$count" -ne ${toString lockedGrammarsCount} ]; then
        echo "Expected ${toString lockedGrammarsCount} grammars, found $count"
        exit 1
      fi
    '';
  in
  {
    pname = "helix";
    version = "25.07.1";
    outputs = [
      "out"
      "doc"
    ];

    src = fetchFromGitHub {
      owner = "helix-editor";
      repo = "helix";
      tag = "${finalAttrs.version}";
      hash = "sha256-RFSzGAcB0mMg/02ykYfTWXzQjLFu2CJ4BkS5HZ/6pBo=";
    };

    patches = [
      # Support mdbook 0.5.x: escape HTML tags in command descriptions
      ./mdbook-0.5-support.patch
    ];

    postPatch = ''
      # mdbook 0.5 uses asset hashing for CSS/JS files
      # Remove custom theme to use default mdbook theme with correct asset references
      rm -f book/theme/index.hbs
    '';

    cargoHash = "sha256-Mf0nrgMk1MlZkSyUN6mlM5lmTcrOHn3xBNzmVGtApEU=";

    nativeBuildInputs = [
      gitMinimal
      installShellFiles
      mdbook
    ];

    env = {
      HELIX_DEFAULT_RUNTIME = runtimeDir;
      HELIX_DISABLE_AUTO_GRAMMAR_BUILD = "1";
    };

    postBuild = ''
      mdbook build book -d ../book-html
    '';

    postInstall = ''
      mkdir -p $out/lib $doc/share/doc
      installShellCompletion contrib/completion/hx.{bash,fish,zsh}
      mkdir -p $out/share/{applications,icons/hicolor/256x256/apps}
      cp contrib/Helix.desktop $out/share/applications/Helix.desktop
      cp contrib/helix.png $out/share/icons/hicolor/256x256/apps/helix.png
      cp -r ../book-html $doc/share/doc/$name
    '';

    nativeInstallCheckInputs = [
      versionCheckHook
    ];
    versionCheckProgram = "${placeholder "out"}/bin/hx";
    doInstallCheck = true;

    passthru = {
      updateScript = ./update.sh;
      runtime = runtimeDir;
      inherit tree-sitter-grammars;
    };

    meta = {
      description = "Post-modern modal text editor";
      homepage = "https://helix-editor.com";
      changelog = "https://github.com/helix-editor/helix/blob/${finalAttrs.version}/CHANGELOG.md";
      license = lib.licenses.mpl20;
      mainProgram = "hx";
      maintainers = with lib.maintainers; [
        aciceri
        danth
        yusdacra
      ];
    };
  }
)
