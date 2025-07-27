{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  openssl,
  versionCheckHook,
  stdenv,
  installShellFiles,
  installShellCompletions ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  git,
  makeWrapper,
  python3,
  xdg-utils,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "codex";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "openai";
    repo = "codex";
    tag = "rust-v${finalAttrs.version}";
    hash = "sha256-ukQG6Ugc4lvJEdPmorNEdVh8XrgjuOO8x/8F+9jcw3U=";
  };

  sourceRoot = "${finalAttrs.src.name}/codex-rs";

  useFetchCargoVendor = true;
  cargoHash = "sha256-YZHmMRwJgZTPHyoB4GXlt6H2Igw1wh/4vMYt7+3Nz1Y=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    makeWrapper
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

    # Failing tests (broken upstream in v0.10.0 as tests hardcode version 0.0.0, remove these skips when fixed)
    "--skip=test_patch_approval_triggers_elicitation"
    "--skip=test_codex_tool_passes_base_instructions"
    "--skip=test_shell_command_approval_triggers_elicitation"
    "--skip=test_shell_command_interruption"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  postInstall = lib.optionalString installShellCompletions ''
    installShellCompletion --cmd codex \
      --bash <($out/bin/codex completion bash) \
      --fish <($out/bin/codex completion fish) \
      --zsh <($out/bin/codex completion zsh)
  '';

  postFixup = ''
    wrapProgram $out/bin/codex \
      --prefix PATH : ${
        lib.makeBinPath [
          python3
          xdg-utils
        ]
      }
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
