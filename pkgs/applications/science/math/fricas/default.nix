{ stdenv, fetchurl, sbcl, libX11, libXpm, libICE, libSM, libXt, libXau, libXdmcp }:

stdenv.mkDerivation rec {
  name = "fricas-1.2.2";

  src = fetchurl {
    url    = "http://sourceforge.net/projects/fricas/files/fricas/1.2.2/${name}-full.tar.bz2";
    sha256 = "87db64a1fd4211f3b776793acea931b4271d2e7a28396414c7d7397d833defe1";
  };

  buildInputs = [ sbcl libX11 libXpm libICE libSM libXt libXau libXdmcp ];

  dontStrip = true;

  meta = {
    homepage = http://fricas.sourceforge.net/;
    description = "An advanced computer algebra system";
    license = stdenv.lib.licenses.bsd3;

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.sprock ];
  };
}
