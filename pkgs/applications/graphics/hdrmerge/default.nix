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
  version = "0.5.0-unstable-2024-08-02";
  src = fetchFromGitHub {
    owner = "jcelaya";
    repo = "hdrmerge";
    rev = "e2a46f97498b321b232cc7f145461212677200f1";
    hash = "sha256-471gJtF9M36pAId9POG8ZIpNk9H/157EdHqXSAPlhN0=";
  };

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
    "-DALGLIB_DIR:PATH=${alglib}"
  ];

  CXXFLAGS = [
    # GCC 13: error: 'uint32_t' does not name a type
    "-include cstdint"
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
