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
  version = "0.22.4";

  src = fetchFromGitHub {
    owner = "benjajaja";
    repo = "mdfried";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Zcn1C8mXwljJ3HtYgYBPyU9cVHvoNBUn7qjqx45wMhE=";
  };

  cargoHash = "sha256-Nt+oBl2HX/H/7j62VjaHrY29gpd2vouevBJO0W3AYAk=";

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
