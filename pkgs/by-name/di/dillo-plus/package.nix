{
  lib,
  stdenv,
  fetchFromGitHub,
  fltk,
  giflib,
  libjpeg,
  libpng,
  libXdmcp,
  openssl,
  pkg-config,
  wget,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dillo-plus";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "crossbowerbt";
    repo = "dillo-plus";
    rev = "v${finalAttrs.version}";
    hash = "sha256-NLerc1GXTdzuGVshXn7faK4vOu7wDVMiQNTljOF7OhA=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    fltk
    giflib
    libjpeg
    libpng
    libXdmcp
    openssl
  ];

  strictDeps = true;

  makeFlags = [
    "PREFIX=$(out)"
    "DOWNLOADER_TOOL=${lib.getExe wget}"
    "INSTALL=install"
  ];

  meta = {
    description = "Lightweight web browser based on Dillo but with many improvements, such as: support for http, https, gemini, gopher, epub, reader mode and more";
    homepage = "https://github.com/crossbowerbt/dillo-plus";
    changelog = "https://github.com/crossbowerbt/dillo-plus/blob/main/ChangeLog";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fgaz ];
    mainProgram = "dillo";
    platforms = lib.platforms.all;
  };
})
