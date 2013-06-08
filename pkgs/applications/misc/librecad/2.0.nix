{ stdenv, fetchurl, qt4, muparser, which, boost}:

stdenv.mkDerivation {
  name = "librecad-2.0.0beta1";

  src = fetchurl {
    url = https://github.com/LibreCAD/LibreCAD/tarball/2.0.0beta1;
    name = "librecad-2.0.0beta1.tar.gz";
    sha256 = "8bf969b79be115f3b3ff72cc030a4c21fe93164dd0cb19ddfb78a7d66b8bc770";
  };

  patchPhase = ''
    sed -i -e s,/bin/bash,`type -P bash`, scripts/postprocess-unix.sh
    sed -i -e s,/usr/share,$out/share, librecad/src/lib/engine/rs_system.cpp
  '';

  configurePhase = ''
    qmake librecad.pro PREFIX=$out MUPARSER_DIR=${muparser} BOOST_DIR=${boost}
  '';

  installPhase = ''
    ensureDir $out/bin $out/share
    cp -R unix/librecad $out/bin
    cp -R unix/resources $out/share/librecad
  '';

  buildInputs = [ qt4 muparser which boost ];

  enableParallelBuilding = true;

  meta = {
    description = "A 2D CAD package based upon Qt";
    homepage = http://librecad.org;
    license = "GPLv2";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
