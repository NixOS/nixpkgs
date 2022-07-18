{ lib, stdenv, fetchurl, sbcl, libX11, libXpm, libICE, libSM, libXt, libXau, libXdmcp }:

stdenv.mkDerivation rec {
  pname = "fricas";
  version = "1.3.7";

  src = fetchurl {
    url = "mirror://sourceforge/fricas/fricas/${version}/fricas-${version}-full.tar.bz2";
    sha256 = "sha256-cOqMvSe3ef/ZeVy5cj/VU/aTRtxgfxZfRbE4lWE5TU4=";
  };

  buildInputs = [ sbcl libX11 libXpm libICE libSM libXt libXau libXdmcp ];

  dontStrip = true;

  meta = {
    homepage = "http://fricas.sourceforge.net/";
    description = "An advanced computer algebra system";
    license = lib.licenses.bsd3;

    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.sprock ];
  };
}
