{ lib, stdenv, fetchurl, sbcl, libX11, libXpm, libICE, libSM, libXt, libXau, libXdmcp }:

stdenv.mkDerivation rec {
  pname = "fricas";
  version = "1.3.8";

  src = fetchurl {
    url = "mirror://sourceforge/fricas/fricas/${version}/fricas-${version}-full.tar.bz2";
    sha256 = "sha256-amAGPLQo70nKATyZM7h3yX5mMUxCwOFwb/fTIWB5hUQ=";
  };

  buildInputs = [ sbcl libX11 libXpm libICE libSM libXt libXau libXdmcp ];

  dontStrip = true;

  meta = {
    homepage = "https://fricas.sourceforge.net/";
    description = "An advanced computer algebra system";
    license = lib.licenses.bsd3;

    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.sprock ];
  };
}
