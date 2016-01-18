{ stdenv, fetchurl, cmake, makeWrapper, exiv2, graphicsmagick
, qtbase, qtdeclarative, qtmultimedia, qtquickcontrols, qttools
}:

let
  version = "1.3";
  qmlPath = stdenv.lib.makeSearchPath "lib/qt5/qml/" [
    qtquickcontrols
    qtdeclarative
    qtmultimedia
  ];
in
stdenv.mkDerivation rec {
  name = "photoqt-${version}";
  src = fetchurl {
    url = "http://photoqt.org/pkgs/photoqt-${version}.tar.gz";
    sha256 = "0j2kvxfb5pd9abciv161nkcsyam6n8kfqs8ymwj2mxiqflwbmfl1";
  };

  buildInputs = [
    cmake makeWrapper qtbase qtquickcontrols qttools exiv2 graphicsmagick
  ];

  preConfigure = ''
    export MAGICK_LOCATION="${graphicsmagick}/include/GraphicsMagick"
  '';

  postInstall = ''
    wrapProgram $out/bin/photoqt --set QML2_IMPORT_PATH "${qmlPath}"
  '';

  meta = {
    homepage = "http://photoqt.org/";
    description = "Simple, yet powerful and good looking image viewer";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.eduarrrd ];
  };
}
