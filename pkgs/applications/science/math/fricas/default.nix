{ stdenv, fetchurl, sbcl, libX11, libXpm, libICE, libSM, libXt, libXau, libXdmcp }:

let
  version = "1.3.4";
  name = "fricas-" + version;
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url    = "mirror://sourceforge/fricas/files/fricas/${version}/${name}-full.tar.bz2";
    sha256 = "156k9az1623y5808j845c56z2nvvdrm48dzg1v0ivpplyl7vp57x";
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
