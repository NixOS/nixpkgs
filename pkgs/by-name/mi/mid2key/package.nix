{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  libX11,
  libXi,
  libXtst,
  xorgproto,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mid2key";
  version = "1";

  src = fetchFromGitHub {
    owner = "dnschneid";
    repo = "mid2key";
    rev = "r${finalAttrs.version}";
    sha256 = "Zo0mqdBJ1JKD9ZCA8te3f5opyYslFncYcx9iuXq2B9g=";
  };

  buildInputs = [
    alsa-lib
    libX11
    libXi
    libXtst
    xorgproto
  ];

  buildPhase = "make";

  installPhase = "mkdir -p $out/bin && mv mid2key $out/bin";

  meta = {
    homepage = "http://code.google.com/p/mid2key/";
    description = "Simple tool which maps midi notes to simulated keystrokes";
    license = lib.licenses.gpl3;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "mid2key";
  };
})
