{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "defmt-print";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "knurling-rs";
    repo = "defmt";
    tag = "defmt-print-v${finalAttrs.version}";
    hash = "sha256-t6i7u4ET3QNo6rhxNhEhZmIpQGitq+baqwvR/Lp4wTs=";
  };

  cargoHash = "sha256-qOGPkTRrk+NPPoztsaYi5LZQ56xSdnChTLESLo1XCP8=";

  cargoBuildFlags = [
    "--bin"
    "defmt-print"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  # Fails with
  #
  # error: to run unit tests enable the `unstable-test` feature, e.g. `cargo t --features unstable-test`
  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
  };

  __structuredAttrs = true;

  meta = {
    description = "Utility for decoding and printing defmt encoded logs to stdout";
    mainProgram = "defmt-print";
    homepage = "https://defmt.ferrous-systems.com/";
    changelog = "https://github.com/knurling-rs/defmt/blob/main/CHANGELOG.md#defmt-print";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ rycee ];
    platforms = lib.platforms.linux;
  };
})
