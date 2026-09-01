{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,

  expat,
  libcdio,
  libcdio-paranoia,
  libpulseaudio,
  smooth,
  uriparser,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "BoCA";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "enzo1982";
    repo = "boca";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-HIYUMFj5yiEC+liZLMXD9otPyoEb1sxHlECTYtYXc2I=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    expat
    libcdio
    libcdio-paranoia
    libpulseaudio
    smooth
    uriparser
    zlib
  ];

  makeFlags = [
    "prefix=$(out)"
  ];

  meta = {
    description = "Component library used by the fre:ac audio converter";
    license = lib.licenses.gpl2Plus;
    homepage = "https://github.com/enzo1982/boca";
    platforms = lib.platforms.linux;
  };
})
