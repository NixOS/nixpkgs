{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fortitude";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "PlasmaFAIR";
    repo = "fortitude";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tJDvXmc0y5Gpk7uvk7mRq3b0MwkhVTx77bXik0Rfop8=";
  };

  cargoHash = "sha256-kZsFDZGg89O3WCC9AyBXsOzzPVz8PPfOQG8t/eEXt34=";

  meta = {
    description = "Fortran linter written in Rust inspired by Ruff";
    homepage = "https://fortitude.readthedocs.io/en/stable/";
    downloadPage = "https://github.com/PlasmaFAIR/fortitude";
    changelog = "https://github.com/PlasmaFAIR/fortitude/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "fortitude";
    maintainers = with lib.maintainers; [ loicreynier ];
    platforms = with lib.platforms; windows ++ darwin ++ linux;
  };
})
