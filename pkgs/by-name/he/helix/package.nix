{
  lib,
  fetchFromGitHub,
  rustPlatform,
  git,
  tree-sitter,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "helix";
  version = "25.01.1";

  src = fetchFromGitHub {
    owner = "helix-editor";
    repo = "helix";
    tag = finalAttrs.version;
    hash = "sha256-wGfX2YcD9Hyqi7sQ8FSqUbN8/Rhftp01YyHoTWYPL8U=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-JZwURUMUnwc3tzAsN7NJCE8106c/4VgZtHHA3e/BsXs=";

  nativeBuildInputs = [
    git
    installShellFiles
  ];

  env = {
    HELIX_DEFAULT_RUNTIME = placeholder "out" + "/lib/runtime";
    HELIX_DISABLE_AUTO_GRAMMAR_BUILD = 1;
  };

  postInstall = ''
    mkdir -p $out/lib
    cp -r runtime $out/lib
    ln -s ${tree-sitter.withPlugins (_: tree-sitter.allGrammars)}/* $out/lib/runtime/grammars/

    installShellCompletion contrib/completion/hx.{bash,fish,zsh}
    mkdir -p $out/share/{applications,icons/hicolor/256x256/apps}
    cp contrib/Helix.desktop $out/share/applications
    cp contrib/helix.png $out/share/icons/hicolor/256x256/apps
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/hx";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Post-modern modal text editor";
    homepage = "https://helix-editor.com";
    changelog = "https://github.com/helix-editor/helix/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    mainProgram = "hx";
    maintainers = with lib.maintainers; [
      danth
      yusdacra
      zowoq
    ];
  };
})
