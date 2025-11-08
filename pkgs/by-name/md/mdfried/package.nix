{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdfried";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "benjajaja";
    repo = "mdfried";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BMBV01VF0oubtFP6WHBiZqUAkxkhsxggPZ0255pONoA=";
  };

  cargoHash = "sha256-FJFdGhoV7Y9sy24DmqLiuwgOryodLjacobeT9jamEfk=";

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
