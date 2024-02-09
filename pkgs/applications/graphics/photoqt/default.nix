{ lib
, stdenv
, fetchurl
, cmake
, extra-cmake-modules
, qttools
, wrapQtAppsHook
, exiv2
, graphicsmagick
, libarchive
, libraw
, mpv
, poppler
, pugixml
, qtbase
, qtcharts
, qtdeclarative
, qtimageformats
, qtlocation
, qtmultimedia
, qtpositioning
, qtsvg
, qtwayland
}:

stdenv.mkDerivation rec {
  pname = "photoqt";
  version = "4.2";

  src = fetchurl {
    url = "https://photoqt.org/pkgs/photoqt-${version}.tar.gz";
    hash = "sha256-OUqsyvmv6ccJDzcWAeS1OOmK2eXOCEgGktz6GEUzoA8=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    exiv2
    graphicsmagick
    libarchive
    libraw
    mpv
    poppler
    pugixml
    qtbase
    qtcharts
    qtdeclarative
    qtimageformats
    qtlocation
    qtmultimedia
    qtpositioning
    qtsvg
  ] ++ lib.optionals stdenv.isLinux [
    qtwayland
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

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv $out/bin/photoqt.app $out/Applications
    makeWrapper $out/{Applications/photoqt.app/Contents/MacOS,bin}/photoqt
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
