{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,

  pkg-config,

  aws-lc,
  dbus,
  zstd,

  installShellFiles,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nono";
  version = "0.82.0";

  __darwinAllowLocalNetworking = true; # required for tests

  src = fetchFromGitHub {
    owner = "nolabs-ai";
    repo = "nono";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ilU6U1CPLda1vLNqX48jek31Ql53s7CHEbuVcmD9Rd4=";
  };
  cargoHash = "sha256-7JQfdy1d4fUi5T10/5NY/LwyT2bpiyyTqBEuGTBEWPs=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    aws-lc
    dbus
    zstd
  ];

  # checks require new skips on every release and were at 100+ skipped when disabled
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd nono \
      --bash <($out/bin/nono completion bash) \
      --zsh <($out/bin/nono completion zsh) \
      --fish <($out/bin/nono completion fish) \
      --powershell <($out/bin/nono completion powershell)
  '';

  passthru.updateScript = nix-update-script { };
  meta = {
    description = "Secure, kernel-enforced sandbox for AI agents, MCP and LLM workloads";
    homepage = "https://github.com/nolabs-ai/nono";
    changelog = "https://github.com/nolabs-ai/nono/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jk
    ];
    mainProgram = "nono";
    # https://github.com/nolabs-ai/nono#platform-support
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
