{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-arc";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "seflue";
    repo = "cargo-arc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b6l9KIDM0V0DDXM5Q79w2ZAHg0nWnlphUdnJyzv3M4Q=";
  };

  cargoHash = "sha256-NNI1H96sMbGzxkXtvFIXxtPB6XNoPB2Ns4czmG+NGiE=";

  checkFlags = [
    # Tries to create temp dir
    "--skip=test_analyze_not_git_repo"
    # Tries to read from dir $CARGO_MANIFEST_DIR
    "--skip=test_analyze_empty_history"
    "--skip=test_analyze_real_repo"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate a collapsible arc diagram of your Cargo workspace as SVG";
    homepage = "https://github.com/seflue/cargo-arc";
    changelog = "https://github.com/seflue/cargo-arc/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      kpbaks
      matthiasbeyer
    ];
    mainProgram = "cargo-arc";
  };
})
