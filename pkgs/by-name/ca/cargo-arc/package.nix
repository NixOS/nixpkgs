{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-arc";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "seflue";
    repo = "cargo-arc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tAES0CP7kGS9RYDsXqiVc/Q8q/APci5m55kTjpIAXNg=";
  };

  cargoHash = "sha256-kqFHu1+BYQQZKCr1WVAWoTzuwkPNfxY34jhtffN9MVE=";

  checkFlags = [
    # Tries to create temp dir
    "--skip=test_analyze_not_git_repo"
    # Tries to read from dir $CARGO_MANIFEST_DIR
    "--skip=test_analyze_empty_history"
    "--skip=test_analyze_real_repo"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Tries to read /proc/1/mem
    "--skip=test_load_io_error"
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
