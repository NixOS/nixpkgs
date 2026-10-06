{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  expat,
  freetype,
  glib,
  imagemagick,
  libjpeg,
  libpng,
  libxml2,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libwmf";
  version = "0.2.16";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "caolanm";
    repo = "libwmf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cQY0DFG+S35G7vblbBxWMTWFp8WqnpNSvjohQSLzijU=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    zlib
    imagemagick
    libpng
    glib
    freetype
    libjpeg
    libxml2
    expat
  ];
  enableParallelBuilding = true;

  meta = {
    changelog = "https://github.com/caolanm/libwmf/blob/${finalAttrs.src.tag}/ChangeLog";
    description = "WMF library from wvWare";
    homepage = "https://wvware.sourceforge.net/libwmf.html";
    downloadPage = "https://github.com/caolanm/libwmf/releases";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
