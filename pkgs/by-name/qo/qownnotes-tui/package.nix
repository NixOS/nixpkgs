{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "qownnotes-tui";
  version = "0.8.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "qownnotes";
    repo = "qownnotes-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-62EXnkooEAzczrIBNj8G6i/SLBbjotMUtZ86rNbNe7o=";
  };

  cargoHash = "sha256-c4mZD7w2KSvWeYvAt+ISbCpPOuG1VwTS8xcOht3rdLM=";

  strictDeps = true;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd qownnotes-tui \
      --bash <($out/bin/qownnotes-tui --generate-completion bash) \
      --fish <($out/bin/qownnotes-tui --generate-completion fish) \
      --zsh <($out/bin/qownnotes-tui --generate-completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Keyboard-first terminal browser for QOwnNotes-compatible note folders";
    homepage = "https://github.com/qownnotes/qownnotes-tui";
    changelog = "https://github.com/qownnotes/qownnotes-tui/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ pbek ];
    mainProgram = "qownnotes-tui";
    platforms = lib.platforms.unix;
  };
})
