{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  openssl,
  git,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "codex";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "openai";
    repo = "codex";
    tag = "rust-v${finalAttrs.version}";
    hash = "sha256-EPK7FX7mP6+nhYMs22zjAclZ9067lOo+BoBYckdnq/E=";
  };

  sourceRoot = "${finalAttrs.src.name}/codex-rs";

  useFetchCargoVendor = true;
  cargoHash = "sha256-69bvdxHdFnWYvCH0PW+KMZI5HDuarFndNlf75Iw5Dno=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    openssl
  ];

  nativeCheckInputs = [
    git
  ];

  checkFlags = [
    "--skip=keeps_previous_response_id_between_tasks" # Requires network access
    "--skip=retries_on_early_close" # Requires network access
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd codex \
      --bash <($out/bin/codex completion bash) \
      --fish <($out/bin/codex completion fish) \
      --zsh <($out/bin/codex completion zsh)
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^rust-v(\\d+\\.\\d+\\.\\d+)$"
      ];
    };
  };

  meta = {
    description = "Lightweight coding agent that runs in your terminal";
    homepage = "https://github.com/openai/codex";
    changelog = "https://raw.githubusercontent.com/openai/codex/refs/tags/rust-v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "codex";
    maintainers = with lib.maintainers; [
      malo
      delafthi
    ];
    platforms = lib.platforms.unix;
  };
})
