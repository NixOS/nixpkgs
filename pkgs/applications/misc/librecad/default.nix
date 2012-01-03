{ stdenv, fetchurl, qt4}:

stdenv.mkDerivation {
  name = "librecad-1.0.0";

  src = fetchurl {
    url = https://github.com/LibreCAD/LibreCAD/tarball/v1.0.0;
    name = "librecad-1.0.0.tar.gz";
    sha256 = "0s1ikyvy98zz1vw3xf5la73n3sykib6292cmhh2z738ggwigicc9";
  };

  patchPhase = ''
    sed -i -e s,/bin/bash,`type -P bash`, scripts/postprocess-unix.sh
  '';

  configurePhase = "qmake PREFIX=$out";

  # It builds, but it does not install
  installPhase = "exit 1";

  buildInputs = [ qt4 ];

  meta = {
    description = "A 2D CAD package based upon Qt";
    homepage = http://librecad.org;
    license = "GPLv2";
  };
}
