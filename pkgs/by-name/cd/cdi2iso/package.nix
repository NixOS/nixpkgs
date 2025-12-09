{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "cdi2iso";
  version = "0.1";

  src = fetchurl {
    url = "mirror://sourceforge/cdi2iso.berlios/${pname}-${version}-src.tar.gz";
    sha256 = "0fj2fxhpr26z649m0ph71378c41ljflpyk89g87x8r1mc4rbq3kh";
  };

  postPatch = ''
    substituteInPlace Makefile --replace "gcc" "${stdenv.cc.targetPrefix}cc"
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp cdi2iso $out/bin
  '';

  meta = with lib; {
    description = "Very simple utility for converting DiscJuggler images to the standard ISO-9660 format";
    homepage = "https://sourceforge.net/projects/cdi2iso.berlios";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    mainProgram = "cdi2iso";
  };
}
