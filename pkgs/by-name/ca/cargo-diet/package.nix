{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-diet";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "the-lean-crate";
    repo = "cargo-diet";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3fH4x83uSRuLwjTatBNicUODCb37HGuLBdTR34yXV8k=";
  };

  cargoHash = "sha256-3oz+q8Hxa/ZzmvlJzt/8xGlFWgWArbHAEVr7chNgl5M=";

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
