{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-arc";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "seflue";
    repo = "cargo-arc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Jf23dACQW2LbfINWq98wNf1rwqueM4bPFFwQIdDT+3Y=";
  };

  cargoHash = "sha256-kKAL5ZgOZOt7Lmu2Epe7B9/FrayGAUguUcb9HPi3gj0=";

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
