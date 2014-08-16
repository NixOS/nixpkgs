{ stdenv, fetchurl, qt4, muparser, which}:

stdenv.mkDerivation {
  name = "librecad-1.0.4";

  src = fetchurl {
    url = https://github.com/LibreCAD/LibreCAD/tarball/v1.0.4;
    name = "librecad-1.0.4.tar.gz";
    sha256 = "00nzbijw7pn1zkj4256da501xcm6rkcvycpa79y6dr2p6c43yc6m";
  };

  patchPhase = ''
    sed -i -e s,/bin/bash,`type -P bash`, scripts/postprocess-unix.sh
    sed -i -e s,/usr/share,$out/share, src/lib/engine/rs_system.cpp
  '';

  configurePhase = "qmake PREFIX=$out";

  installPhase = ''
    mkdir -p $out/bin $out/share
    cp -R unix/librecad $out/bin
    cp -R unix/resources $out/share/librecad
  '';

  buildInputs = [ qt4 muparser which ];

  meta = {
    description = "A 2D CAD package based upon Qt";
    homepage = http://librecad.org;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
