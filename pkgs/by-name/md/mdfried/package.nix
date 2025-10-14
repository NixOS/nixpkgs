{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdfried";
  version = "0.12.9";

  src = fetchFromGitHub {
    owner = "benjajaja";
    repo = "mdfried";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0vAPUmG11Qvds3g2iaH7umZpo4b2/Dtvcm6I8WfM8jw=";
  };

  cargoHash = "sha256-3jx4sIXETEsgTBcTTbedEv0BXoSejLe4oEaudhQIN6s=";

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
