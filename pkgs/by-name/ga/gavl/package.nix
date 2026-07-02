{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  nettle,
  gnutls,
  libpng,
  libdrm,
  libva,
  libGL,
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

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    nettle
    gnutls
    libpng
    libdrm
    libva
    libGL
  ];

  configureFlags = [
    "--without-doxygen"
    "--with-cpuflags=none"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  makeFlags = [ "LDFLAGS=-lm" ];

  meta = {
    description = "Gmerlin Audio Video Library";
    homepage = "https://github.com/bplaum/gavl";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ tbutter ];
  };
})
