{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fortitude";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "PlasmaFAIR";
    repo = "fortitude";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vUfqZhNJ/YIwc5zaC4B6J0+40KeI1XCzt127PzuZ67Q=";
  };

  cargoHash = "sha256-GATbGxCiMsd36XX8EAORB928KbEhyISw60C16/AiBV4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libgit2 ];

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
