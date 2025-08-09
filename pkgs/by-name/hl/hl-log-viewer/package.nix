{
  lib,
  rustPlatform,
  installShellFiles,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hl-log-viewer";
  version = "0.31.1";

  src = fetchFromGitHub {
    owner = "pamburus";
    repo = "hl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rKvcJ7mPCuX+QGdDDeYIk+PtojFgIde5IA7mORmDekw=";
  };

  cargoHash = "sha256-YsDgLPr2V628QCDIOPcx2XQlaomicWZKZ24vXNgxRVE=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd hl \
      --bash <($out/bin/hl --shell-completions bash) \
      --fish <($out/bin/hl --shell-completions fish) \
      --zsh <($out/bin/hl --shell-completions zsh)
    $out/bin/hl --man-page >hl.1
    installManPage hl.1
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/hl";
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "JSON and logfmt log converter to human readable representation";
    homepage = "https://github.com/pamburus/hl";
    changelog = "https://github.com/pamburus/hl/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "hl";
    maintainers = with lib.maintainers; [ petrzjunior ];
  };
})
