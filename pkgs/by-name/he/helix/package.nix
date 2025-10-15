{
  fetchFromGitHub,
  lib,
  rustPlatform,
  mdbook,
  gitMinimal,
  installShellFiles,
  versionCheckHook,
  callPackage,
  runCommand,
  removeReferencesTo,
}:

rustPlatform.buildRustPackage (
  finalAttrs:
  let
    # `callPackage` injects also `overrideAttrs` and `override` into the returned attribute set
    tree-sitter-grammars = lib.filterAttrs (_: lib.isDerivation) (callPackage ./grammars.nix { });

    grammarsFarm = runCommand "helix-grammars" { } (
      lib.concatMapAttrsStringSep "\n" (name: grammar: ''
        install -D ${grammar}/${name}.so $out/${name}.so
        ${lib.getExe removeReferencesTo} -t ${grammar} $out/${name}.so
      '') tree-sitter-grammars
    );

    runtimeDir = runCommand "helix-runtime" { } ''
      cp -r --no-preserve=mode ${finalAttrs.src}/runtime $out
      rm -r $out/grammars
      ln -s ${grammarsFarm} $out/grammars
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
    '';

    nativeInstallCheckInputs = [
      versionCheckHook
    ];
    versionCheckProgram = "${placeholder "out"}/bin/hx";
    versionCheckProgramArg = "--version";
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
