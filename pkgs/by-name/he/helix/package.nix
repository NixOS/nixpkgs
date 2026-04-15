{
  lib,
  rustPlatform,
  fetchFromGitHub,
  runCommand,
  installShellFiles,
  makeBinaryWrapper,
  mdbook,
  symlinkJoin,
  removeReferencesTo,
  versionCheckHook,
  pkgs,
  tree-sitter,
  lockedGrammars ? lib.importJSON ./grammars.json,
  grammarsOverlay ? (
    final: prev: {
      tree-sitter-beancount = prev.tree-sitter-beancount.override {
        excludeBrokenTreeSitterJson = false;
      };
      tree-sitter-dart = prev.tree-sitter-dart.overrideAttrs {
        patches = [ ];
      };
      tree-sitter-glimmer = prev.tree-sitter-glimmer.override {
        excludeBrokenTreeSitterJson = false;
      };
      tree-sitter-janet-simple = prev.tree-sitter-janet-simple.override {
        excludeBrokenTreeSitterJson = false;
      };
      tree-sitter-latex = prev.tree-sitter-latex.override {
        generate = false;
      };
      tree-sitter-qmljs = prev.tree-sitter-qmljs.overrideAttrs {
        dontCheckForBrokenSymlinks = true;
      };
      tree-sitter-sql = prev.tree-sitter-sql.override {
        generate = false;
      };
      tree-sitter-tlaplus = prev.tree-sitter-tlaplus.overrideAttrs {
        patches = [ ];
      };
    }
  ),
}:

let
  helix-unwrapped = rustPlatform.buildRustPackage (
    finalAttrs:
    let
      defaultRuntimeDir = runCommand "helix-default-runtime" { } ''
        cp -r --no-preserve=mode ${finalAttrs.src}/runtime $out
        rm -rf $out/grammars $out/queries
      '';
    in
    {
      pname = "helix-unwrapped";
      version = "25.07.1";

      outputs = [
        "out"
        "doc"
      ];

      src = fetchFromGitHub {
        owner = "helix-editor";
        repo = "helix";
        tag = finalAttrs.version;
        hash = "sha256-RFSzGAcB0mMg/02ykYfTWXzQjLFu2CJ4BkS5HZ/6pBo=";
      };

      cargoHash = "sha256-Mf0nrgMk1MlZkSyUN6mlM5lmTcrOHn3xBNzmVGtApEU=";

      patches = [
        # Support mdbook 0.5.x: escape HTML tags in command descriptions
        ./mdbook-0.5-support.patch
      ];

      postPatch = ''
        # mdbook 0.5 uses asset hashing for CSS/JS files
        # Remove custom theme to use default mdbook theme with correct asset references
        rm -f book/theme/index.hbs
      '';

      nativeBuildInputs = [
        installShellFiles
        mdbook
      ];

      env = {
        # disable fetching and building of tree-sitter grammars in the helix-term build.rs
        HELIX_DISABLE_AUTO_GRAMMAR_BUILD = "1";
        HELIX_DEFAULT_RUNTIME = defaultRuntimeDir;
      };

      postBuild = ''
        mdbook build book -d ../book-html
      '';

      postInstall = ''
        installShellCompletion contrib/completion/hx.{bash,fish,zsh}
        mkdir -p $out/share/{applications,icons/hicolor/256x256/apps}
        cp contrib/Helix.desktop $out/share/applications/Helix.desktop
        cp contrib/helix.png $out/share/icons/hicolor/256x256/apps/helix.png
        mkdir -p $doc/share/doc
        cp -r ../book-html $doc/share/doc/$name
      '';

      nativeInstallCheckInputs = [
        versionCheckHook
      ];
      versionCheckProgram = "${placeholder "out"}/bin/hx";
      doInstallCheck = true;

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
  );

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

  lockedGrammarsCount = lib.length (lib.attrNames lockedGrammars);
  actualGrammarsCount = lib.length (
    lib.attrNames (lib.filterAttrs (_: lib.isDerivation) tree-sitter-grammars)
  );

  wrap =
    grammars:
    let
      # Dynamic libraries for the grammars always use the `.so` extension, also on Darwin (should use `.dylib`)
      # See here: https://github.com/helix-editor/helix/pull/14982
      # Switch to `stdenv.hostPlatform.extensions.sharedLibrary` once the fix above reaches the next release
      grammarsFarm = runCommand "helix-grammars" { } (
        lib.concatMapStringsSep "\n" (grammar: ''
          install -D ${grammar}/parser $out/${grammar.language}.so
          ${lib.getExe removeReferencesTo} -t ${grammar} $out/${grammar.language}.so
        '') grammars
      );

      runtimeDir = runCommand "helix-runtime" { } ''
        mkdir -p $out
        ln -s ${grammarsFarm} $out/grammars
        cp -r --no-preserve=mode ${helix-unwrapped.src}/runtime/queries $out
      '';
    in
    symlinkJoin {
      pname = "helix";
      inherit (helix-unwrapped) version;

      paths = [ helix-unwrapped ];
      nativeBuildInputs = [ makeBinaryWrapper ];

      postBuild = ''
        wrapProgram $out/bin/hx --set HELIX_RUNTIME "${runtimeDir}"
      '';

      passthru = {
        runtime = runtimeDir;
        inherit helix-unwrapped;
      };

      meta = {
        inherit (helix-unwrapped.meta)
          description
          homepage
          changelog
          license
          mainProgram
          maintainers
          ;
      };
    };

  allGrammars = lib.attrValues (lib.filterAttrs (_: lib.isDerivation) tree-sitter-grammars);
in

assert lockedGrammarsCount == actualGrammarsCount;

(wrap allGrammars).overrideAttrs (prev: {
  passthru = (prev.passthru or { }) // {
    updateScript = ./update.sh;
    inherit tree-sitter-grammars;
    withGrammars = selector: wrap (selector tree-sitter-grammars);
  };
})
