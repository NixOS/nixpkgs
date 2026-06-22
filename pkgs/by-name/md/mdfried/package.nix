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
  version = "0.22.2";

  src = fetchFromGitHub {
    owner = "benjajaja";
    repo = "mdfried";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HRtuqnD6erRC1Xx+3NSbaFgqRHzurj1xbOJNGykGIpU=";
  };

  cargoHash = "sha256-jnByeBBL13DavExG2pVN7vNRr+UXGkxRY0a4MkwzRe0=";

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
