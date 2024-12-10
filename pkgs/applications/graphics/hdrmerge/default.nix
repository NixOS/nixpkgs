{
  lib,
  mkDerivation,
  fetchpatch,
  fetchFromGitHub,
  cmake,
  qtbase,
  wrapQtAppsHook,
  libraw,
  exiv2,
  zlib,
  alglib,
  pkg-config,
  makeDesktopItem,
  copyDesktopItems,
}:

mkDerivation rec {
  pname = "hdrmerge";
  version = "unstable-2023-01-04";
  src = fetchFromGitHub {
    owner = "jcelaya";
    repo = "hdrmerge";
    rev = "ca38b54f980564942a7f2b014a5f57a64c1d9019";
    hash = "sha256-DleYgpDXP0NvbmEURXnBfe3OYnT1CaQq+Mw93JQQprE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
    copyDesktopItems
  ];

  buildInputs = [
    qtbase
    libraw
    exiv2
    zlib
    alglib
  ];

  cmakeFlags = [
    "-DALGLIB_DIR:PATH=${alglib}"
  ];

  CXXFLAGS = [
    # GCC 13: error: 'uint32_t' does not name a type
    "-include cstdint"
  ];

  patches = [
    # https://github.com/jcelaya/hdrmerge/pull/222
    (fetchpatch {
      name = "exiv2-0.28.patch";
      url = "https://github.com/jcelaya/hdrmerge/commit/377d8e6f3c7cdd1a45b63bce2493ad177dde03fb.patch";
      hash = "sha256-lXHML6zGkVeWKvmY5ECoJL2xjmtZz77XJd5prpgJiZo=";
    })
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
