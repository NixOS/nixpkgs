{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "cargo-feature-combinations";
  version = "0.0.54";

  src = fetchFromGitHub {
    owner = "romnn";
    repo = "cargo-feature-combinations";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SgVwgG7lNFrDMH1t9yvYTTm7pQth2hcEAjwMuRkC5Kg=";
  };

  cargoHash = "sha256-S0I2itkyAhZwk+S/k/Sr3bpENpIQNHSaJwVpA8rvQ+E=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cargo plugin to run commands against all combinations of features";
    homepage = "https://github.com/romnn/cargo-feature-combinations";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
      pinage404
    ];
    mainProgram = "cargo-feature-combinations";
  };
})
