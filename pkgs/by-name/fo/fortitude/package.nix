{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "fortitude";
  version = "0.7.5-unstable-2025-10-14";

  src = fetchFromGitHub {
    owner = "PlasmaFAIR";
    repo = "fortitude";
    rev = "ca65546d69947500eeb37a2bbc58151012ab40d9";
    hash = "sha256-PKOPQnVQbvqEoCPO9K3ofajbcId83uLbma6R9RiBzys=";
  };

  cargoHash = "sha256-hNAONXSy1uxm7AHvMHWNboL9NpQfvEOfTQivushp7S4=";

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
}
