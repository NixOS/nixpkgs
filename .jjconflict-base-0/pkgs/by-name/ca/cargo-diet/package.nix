{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-diet";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "the-lean-crate";
    repo = "cargo-diet";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3xUuMO5Z4ukC+olWNcURqkYEWbSQ73L5i9B/QGDXCgQ=";
  };

  cargoHash = "sha256-SUgH/FV+ezyG/5Bns2pwkCsvuCUihmuKGrtH2mjbcNU=";

  meta = {
    description = "Help computing optimal include directives for your Cargo.toml manifest";
    mainProgram = "cargo-diet";
    homepage = "https://github.com/the-lean-crate/cargo-diet";
    changelog = "https://github.com/the-lean-crate/cargo-diet/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
})
