{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdfried";
  version = "0.12.4";

  src = fetchFromGitHub {
    owner = "benjajaja";
    repo = "mdfried";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V4mSMBvezkIp7+95W3DiGYIFiNPC3g535j3gnske3eU=";
  };

  cargoHash = "sha256-xAoe6IeI9VBnofC/yuOAbKjsWyHV5AG4KwmyptQzRsQ=";

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
