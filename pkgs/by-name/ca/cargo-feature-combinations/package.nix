{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "cargo-feature-combinations";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "romnn";
    repo = "cargo-feature-combinations";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UvKEXWBT2W4wsjlKUTeyF2A8NIqLnfpjQRKJpCqszp8=";
  };

  cargoHash = "sha256-wDd7910GjQwSPk44HwF9LhqNlgUwAEC9D2J0essIT1o=";

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
