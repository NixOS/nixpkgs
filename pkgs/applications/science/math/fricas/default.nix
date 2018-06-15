{ stdenv, fetchurl, sbcl, libX11, libXpm, libICE, libSM, libXt, libXau, libXdmcp }:

let
  version = "1.3.3";
  name = "fricas-" + version;
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url    = "http://sourceforge.net/projects/fricas/files/fricas/${version}/${name}-full.tar.bz2";
    sha256 = "1avp9mbl5yn192c7kz5c2d18k33hay9lwii363b0v5hj3qgq2hhl";
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
