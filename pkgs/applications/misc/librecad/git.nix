{ stdenv, fetchgit, qt5, muparser, which, boost, pkgconfig }:

let
  # master as of 2019-07-28
  rev = "10d502db66527ea64a2a012add2e57059e2409f0";
in
stdenv.mkDerivation rec {
  name = "librecad-git-${rev}";

  src = fetchgit {
    url = https://github.com/LibreCAD/LibreCAD;
    inherit rev;
    sha256 = "0172xgrnr7q3xlnjvq6rxyby9bjbc3vp9g2bgdvw3dsq3fqxyii3";
  };

  patchPhase = ''
    sed -i -e s,/bin/bash,`type -P bash`, scripts/postprocess-unix.sh
    sed -i -e s,/usr/share,$out/share, librecad/src/lib/engine/rs_system.cpp
  '';

  qmakeFlags = [ "MUPARSER_DIR=${muparser}" "BOOST_DIR=${boost.dev}" ];

  installPhase = ''
    install -m 555 -D unix/librecad $out/bin/librecad
    install -m 444 -D desktop/librecad.desktop $out/share/applications/librecad.desktop
    install -m 444 -D desktop/librecad.sharedmimeinfo $out/share/mime/packages/librecad.xml
    install -m 444 -D desktop/graphics_icons_and_splash/Icon\ LibreCAD/Icon_Librecad.svg \
      $out/share/icons/hicolor/scalable/apps/librecad.svg
    cp -R unix/resources $out/share/librecad
  '';

  buildInputs = [ qt5.qtbase qt5.qtsvg muparser which boost ];
  nativeBuildInputs = [ pkgconfig qt5.qmake ];

  enableParallelBuilding = true;

  meta = {
    description = "A 2D CAD package based upon Qt";
    homepage = https://librecad.org;
    repositories.git = git://github.com/LibreCAD/LibreCAD.git;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
