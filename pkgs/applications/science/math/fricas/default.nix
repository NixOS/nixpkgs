{ stdenv, fetchurl, sbcl, libX11, libXpm, libICE, libSM, libXt, libXau, libXdmcp }:

let
  version = "1.3.1";
  name = "fricas-" + version;
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url    = "http://sourceforge.net/projects/fricas/files/fricas/${version}/${name}-full.tar.bz2";
    sha256 = "0c2wgj1c3mh5f8msx1ckxpnhm0dyq7dqf1wk6aiyysh8xn57cjkx";
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
