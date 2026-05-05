{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  chafa,
  glib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdfried";
  version = "0.19.7";

  src = fetchFromGitHub {
    owner = "benjajaja";
    repo = "mdfried";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gCmKlbPO5ZVK3SqX40KlSGfef9ZniCsznkQU78A4H7o=";
  };

  cargoHash = "sha256-kPm78L/uS4mYBw9UWHo6a6a5ntUuCYZ81plMr44bwd8=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    chafa
    glib
  ];

  doCheck = true;

  meta = {
    description = "Markdown viewer TUI for the terminal, with big text and image rendering";
    homepage = "https://github.com/benjajaja/mdfried";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ benjajaja ];
    platforms = lib.platforms.unix;
    mainProgram = "mdfried";
  };
})
