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
  version = "0.32.3";

  src = fetchFromGitHub {
    owner = "pamburus";
    repo = "hl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BYSVzLh/GGC5BK0Q2xyZ54AA6UUxmWNFj9mH8gGvLXQ=";
  };

  cargoHash = "sha256-F9C6OeU0lxVdollldL1PV/wTo5+3j+MGZg9lkJVVvFI=";

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
