{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  exiv2,
  graphicsmagick,
  libarchive,
  libraw,
  mpv,
  pugixml,
  qt6,
  qt6Packages,
  zxing-cpp,
}:

stdenv.mkDerivation rec {
  pname = "photoqt";
  version = "4.9.2";

  src = fetchurl {
    url = "https://photoqt.org/pkgs/photoqt-${version}.tar.gz";
    hash = "sha256-kPhxWekecE57wY45qLy/EnfmjFLn0cEmZ+4qWHGbL4U=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    exiv2
    graphicsmagick
    libarchive
    libraw
    pugixml
    qt6.qtbase
    qt6.qtcharts
    qt6.qtdeclarative
    qt6.qtimageformats
    qt6.qtlocation
    qt6.qtmultimedia
    qt6.qtpositioning
    qt6.qtsvg
    qt6Packages.poppler
    zxing-cpp
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    mpv
    qt6.qtwayland
  ];

  cmakeFlags = [
    (lib.cmakeBool "DEVIL" false)
    (lib.cmakeBool "CHROMECAST" false)
    (lib.cmakeBool "FREEIMAGE" false)
    (lib.cmakeBool "IMAGEMAGICK" false)
    (lib.cmakeBool "VIDEO_MPV" (!stdenv.hostPlatform.isDarwin))
  ];

  env.MAGICK_LOCATION = "${graphicsmagick}/include/GraphicsMagick";

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
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
