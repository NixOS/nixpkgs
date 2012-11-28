{ stdenv, fetchurl, qt4, muparser, which}:

stdenv.mkDerivation {
  name = "librecad-1.0.2";

  src = fetchurl {
    url = https://github.com/LibreCAD/LibreCAD/tarball/v1.0.2;
    name = "librecad-1.0.2.tar.gz";
    sha256 = "13ee7e401e4f5fbc68c2e017b7189bec788038f4f6e77f559861ceb8cfb1907d";
  };

  patchPhase = ''
    sed -i -e s,/bin/bash,`type -P bash`, scripts/postprocess-unix.sh
    sed -i -e s,/usr/share,$out/share, src/lib/engine/rs_system.cpp
  '';

  configurePhase = "qmake PREFIX=$out";

  installPhase = ''
    ensureDir $out/bin $out/share
    cp -R unix/librecad $out/bin
    cp -R unix/resources $out/share/librecad
  '';

  buildInputs = [ qt4 muparser which ];

  meta = {
    description = "A 2D CAD package based upon Qt";
    homepage = http://librecad.org;
    license = "GPLv2";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
