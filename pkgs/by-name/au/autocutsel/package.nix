{
  lib,
  stdenv,
  fetchurl,
  libx11,
  libxaw,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.10.1";
  pname = "autocutsel";

  src = fetchurl {
    url = "https://github.com/sigmike/autocutsel/releases/download/${finalAttrs.version}/autocutsel-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-8X4G1C90lENtSyb0vgtrDaOUgcBADJZ3jkuQW2NB6xc=";
  };

  buildInputs = [
    libx11
    libxaw
  ];
  installPhase = ''
    mkdir -p $out/bin
    cp autocutsel $out/bin/
  '';

  meta = {
    homepage = "https://www.nongnu.org/autocutsel/";
    description = "Tracks changes in the server's cutbuffer and CLIPBOARD selection";
    license = lib.licenses.gpl2Plus;
    platforms = with lib.platforms; all;
    mainProgram = "autocutsel";
  };
})
