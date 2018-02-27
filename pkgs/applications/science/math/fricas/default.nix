{ stdenv, fetchurl, sbcl, libX11, libXpm, libICE, libSM, libXt, libXau, libXdmcp }:

let
  version = "1.3.2";
  name = "fricas-" + version;
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url    = "http://sourceforge.net/projects/fricas/files/fricas/${version}/${name}-full.tar.bz2";
    sha256 = "17a3vfvsn2idydqslf5r6z3sk6a5bdgj6z1n3dmnwmpkc4z152vr";
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
