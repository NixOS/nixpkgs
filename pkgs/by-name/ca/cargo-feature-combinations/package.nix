{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "cargo-feature-combinations";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "romnn";
    repo = "cargo-feature-combinations";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AUZS8HxgR97JQenjTqTUy+u7Qb1Kt+XKCpp+B51tkE8=";
  };

  cargoHash = "sha256-iHpQH4B6UKr++1lP1KPq/UNTUFY22W+WMUrjfwU1vbo=";

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
