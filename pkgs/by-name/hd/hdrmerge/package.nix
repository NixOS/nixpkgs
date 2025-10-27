{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libsForQt5,
  libraw,
  exiv2,
  zlib,
  alglib,
  pkg-config,
  makeDesktopItem,
  copyDesktopItems,
}:

stdenv.mkDerivation rec {
  pname = "hdrmerge";
  version = "0.5.0-unstable-2025-04-26";
  src = fetchFromGitHub {
    owner = "jcelaya";
    repo = "hdrmerge";
    rev = "3bbe43771ba15b899151721bc14aa57e86b60f2f";
    hash = "sha256-4FIGchwROXe8qLRBaYih2k9zDll2YoYGDj06SrIqK9Q=";
  };

  # Disable find_package(ALGLIB REQUIRED) in the CMake file by providing a empty
  # FindALGLIB.cmake, and provide ALGLIB_INCLUDES and ALGLIB_LIBRARIES ourselves
  preConfigure = ''
    touch cmake/FindALGLIB.cmake
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.wrapQtAppsHook
    copyDesktopItems
  ];

  buildInputs = [
    libsForQt5.qtbase
    libraw
    exiv2
    zlib
    alglib
  ];

  cmakeFlags = [
    (lib.cmakeFeature "ALGLIB_INCLUDES" "${alglib}/include/alglib")
    (lib.cmakeFeature "ALGLIB_LIBRARIES" "alglib3")
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "HDRMerge";
      genericName = "HDR raw image merge";
      desktopName = "HDRMerge";
      comment = meta.description;
      icon = "hdrmerge";
      exec = "hdrmerge %F";
      categories = [ "Graphics" ];
      mimeTypes = [
        "image/x-dcraw"
        "image/x-adobe-dng"
      ];
      terminal = false;
    })
  ];

  postInstall = ''
    install -Dm444 ../data/images/icon.png $out/share/icons/hicolor/128x128/apps/hdrmerge.png
  '';

  meta = with lib; {
    homepage = "https://github.com/jcelaya/hdrmerge";
    description = "Combines two or more raw images into an HDR";
    mainProgram = "hdrmerge";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.paperdigits ];
  };
}
