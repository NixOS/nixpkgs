{ stdenv, fetchurl, qt4, muparser, which, boost, pkgconfig }:

stdenv.mkDerivation rec {
  version = "2.0.8";
  name = "librecad-${version}";

  src = fetchurl {
    url = "https://github.com/LibreCAD/LibreCAD/tarball/${version}";
    name = name + ".tar.gz";
    sha256 = "110vn1rvzidg8k6ifz1zws2wsn4cd05xl5ha0hbff2ln7izy84zc";
  };

  patchPhase = ''
    sed -i -e s,/bin/bash,`type -P bash`, scripts/postprocess-unix.sh
    sed -i -e s,/usr/share,$out/share, librecad/src/lib/engine/rs_system.cpp
  '';

  configurePhase = ''
    qmake librecad.pro PREFIX=$out MUPARSER_DIR=${muparser} BOOST_DIR=${boost.dev}
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share
    cp -R unix/librecad $out/bin
    cp -R unix/resources $out/share/librecad
  '';

  buildInputs = [ qt4 muparser which boost ];
  nativeBuildInputs = [ pkgconfig ];

  enableParallelBuilding = true;

  meta = {
    description = "A 2D CAD package based upon Qt";
    homepage = http://librecad.org;
    repositories.git = git://github.com/LibreCAD/LibreCAD.git;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
