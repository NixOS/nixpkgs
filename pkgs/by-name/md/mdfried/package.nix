{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  chafa,
  glib,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdfried";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "benjajaja";
    repo = "mdfried";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zJSh5g1FkR/nqk2qj22Xo8qIOjwyF346PM4KOUOCBBo=";
  };

  cargoHash = "sha256-2wwaEKknnxX6QuE+6udHL2GTOuPpS1oqRI+b3aP0e1I=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    chafa
    glib
  ];

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Markdown viewer TUI for the terminal, with big text and image rendering";
    homepage = "https://github.com/benjajaja/mdfried";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ benjajaja ];
    platforms = lib.platforms.unix;
    mainProgram = "mdfried";
  };
})
