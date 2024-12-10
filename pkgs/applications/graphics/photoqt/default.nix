{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qttools,
  wrapQtAppsHook,
  exiv2,
  graphicsmagick,
  libarchive,
  libraw,
  mpv,
  poppler,
  pugixml,
  qtbase,
  qtcharts,
  qtdeclarative,
  qtimageformats,
  qtlocation,
  qtmultimedia,
  qtpositioning,
  qtsvg,
  zxing-cpp,
  qtwayland,
}:

stdenv.mkDerivation rec {
  pname = "photoqt";
  version = "4.5";

  src = fetchurl {
    url = "https://photoqt.org/pkgs/photoqt-${version}.tar.gz";
    hash = "sha256-QFziMNRhiM4LaNJ8RkJ0iCq/8J82wn0F594qJeSN3Lw=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qttools
    wrapQtAppsHook
  ];

  buildInputs =
    [
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
      zxing-cpp
    ]
    ++ lib.optionals stdenv.isLinux [
      qtwayland
    ];

  cmakeFlags = [
    (lib.cmakeBool "DEVIL" false)
    (lib.cmakeBool "CHROMECAST" false)
    (lib.cmakeBool "FREEIMAGE" false)
    (lib.cmakeBool "IMAGEMAGICK" false)
  ];

  env.MAGICK_LOCATION = "${graphicsmagick}/include/GraphicsMagick";

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
