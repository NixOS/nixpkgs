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
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "benjajaja";
    repo = "mdfried";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Wio+YkucU7HgXzA0BswShVNS6z7r2upJxCLc1jQ+8bM";
  };

  cargoHash = "sha256-i1PqonM06y04HTRA05winvhz4IKUEThlUkFLnrqeHqA";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    chafa
    glib
  ];

  doCheck = true;

  checkFlags = [
    "--skip=tests::duplicate_image"
    "--skip=tests::parse"
    "--skip=tests::reload_add_image"
    "--skip=tests::reload_move_image"
  ];

  meta = {
    description = "Markdown viewer TUI for the terminal, with big text and image rendering";
    homepage = "https://github.com/benjajaja/mdfried";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ benjajaja ];
    platforms = lib.platforms.unix;
    mainProgram = "mdfried";
  };
})
