{ lib
, stdenv
, fetchurl
, cmake
, extra-cmake-modules
, qttools
, wrapQtAppsHook
, exiv2
, graphicsmagick
, kimageformats
, libarchive
, libraw
, mpv
, poppler
, pugixml
, qtbase
, qtdeclarative
, qtgraphicaleffects
, qtmultimedia
, qtquickcontrols
, qtquickcontrols2
}:

stdenv.mkDerivation rec {
  pname = "photoqt";
  version = "3.4";

  src = fetchurl {
    url = "https://photoqt.org/pkgs/photoqt-${version}.tar.gz";
    hash = "sha256-kVf9+zI9rtEMmS0N4qrN673T/1fnqfcV3hQPnMXMLas=";
  };

  # error: no member named 'setlocale' in namespace 'std'; did you mean simply 'setlocale'?
  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace cplusplus/main.cpp \
      --replace "std::setlocale" "setlocale"
  '';

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    exiv2
    graphicsmagick
    kimageformats
    libarchive
    libraw
    mpv
    poppler
    pugixml
    qtbase
    qtdeclarative
    qtgraphicaleffects
    qtmultimedia
    qtquickcontrols
    qtquickcontrols2
  ];

  cmakeFlags = [
    "-DDEVIL=OFF"
    "-DCHROMECAST=OFF"
    "-DFREEIMAGE=OFF"
    "-DIMAGEMAGICK=OFF"
  ];

  preConfigure = ''
    export MAGICK_LOCATION="${graphicsmagick}/include/GraphicsMagick"
  '';

  meta = {
    description = "Simple, yet powerful and good looking image viewer";
    homepage = "https://photoqt.org/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "photoqt";
    maintainers = with lib.maintainers; [ wegank ];
    platforms = lib.platforms.unix;
  };
}
