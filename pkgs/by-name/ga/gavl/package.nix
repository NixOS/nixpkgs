{
  autoreconfHook,
  doxygen,
  fetchFromGitHub,
  gnutls,
  lib,
  libdrm,
  libGL,
  libGLU,
  libpng,
  nettle,
  pkg-config,
  stdenv,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gavl";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "bplaum";
    repo = "gavl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nvgBsUiSF6+voMzo5XRWHig2Iq8DD2hVV5hWodGxgQo=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    autoreconfHook
    doxygen
    pkg-config
  ];

  buildInputs = [
    gnutls
    libdrm
    libGL
    libGLU
    libpng
    nettle
    zlib
  ];

  meta = {
    description = "Low level library for handling uncompressed audio and video data";
    homepage = "https://github.com/bplaum/gavl";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      nick-linux
    ];
    platforms = lib.platforms.linux;
  };
})
