{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "codex";
  version = "0.0.2506060849";

  src = fetchFromGitHub {
    owner = "openai";
    repo = "codex";
    tag = "rust-v${finalAttrs.version}";
    hash = "sha256-ZEbcqI3DtV6jZx/wgLqJs4O0sDfHppMwVnfDmE5dXw4=";
  };

  sourceRoot = "${finalAttrs.src.name}/codex-rs";

  useFetchCargoVendor = true;
  cargoHash = "sha256-GBlwoXY5vUjxJx0M3/eiywIxnAVchXACIhNfNCNRZ1k=";

  nativeBuildInputs = [
    pkg-config
    openssl
  ];

  checkFlags = [
    "--skip=keeps_previous_response_id_between_tasks" # Requires network access
    "--skip=retries_on_early_close" # Requires network access
  ];

  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^rust-v(\\d+\\.\\d+\\.\\d+)$"
      ];
    };
  };

  meta = {
    description = "OpenAI Codex command‑line interface rust implementation";
    license = lib.licenses.asl20;
    homepage = "https://github.com/openai/codex";
    changelog = "https://raw.githubusercontent.com/openai/codex/refs/tags/rust-v${finalAttrs.version}/CHANGELOG.md";
    mainProgram = "codex";
    maintainers = with lib.maintainers; [
      malo
      delafthi
    ];
    platforms = lib.platforms.unix;
  };
})
