{
  lib,
  stdenv,
  rustPlatform,
  installShellFiles,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hl-log-viewer";
  version = "0.35.3";

  src = fetchFromGitHub {
    owner = "pamburus";
    repo = "hl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eEILIQ24QG2zAafex9dGQxQyXB6W8QVgqST3nL9hsI0=";
  };

  cargoHash = "sha256-KPI5rDDbc9WY/S1axMPPCN7ltkwg8W+9Zwm4EiNBZ+k=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd hl \
      --bash <($out/bin/hl --shell-completions bash) \
      --fish <($out/bin/hl --shell-completions fish) \
      --zsh <($out/bin/hl --shell-completions zsh)
    $out/bin/hl --man-page >hl.1
    installManPage hl.1
  '';

  checkFlags = [
    # test broken on zero-width TTY, see https://github.com/pamburus/hl/issues/1140
    "--skip=help::tests::test_formatter_new"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/hl";

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
