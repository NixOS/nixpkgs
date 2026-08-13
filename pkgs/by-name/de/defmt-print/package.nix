{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "defmt-print";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "knurling-rs";
    repo = "defmt";
    tag = "defmt-print-v${finalAttrs.version}";
    hash = "sha256-owG78NHFy7A+fZnnnY1GplAXvDyc++WO9t8dAGyQP6s=";
  };

  cargoHash = "sha256-hgPX5HkVfSK4FHCnFFYuG4KdzjUrbta6LQa+8rK8TuA=";

  cargoBuildFlags = [
    "--bin"
    "defmt-print"
  ];

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
