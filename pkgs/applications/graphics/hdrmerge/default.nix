{ lib
, mkDerivation
, fetchpatch
, fetchFromGitHub
, cmake
, extra-cmake-modules
, qtbase
, wrapQtAppsHook
, libraw
, exiv2
, zlib
, alglib
, pkg-config
, makeDesktopItem
, copyDesktopItems
}:

mkDerivation rec {
  pname = "hdrmerge";
  version = "unstable-2020-11-12";
  src = fetchFromGitHub {
    owner = "jcelaya";
    repo = "hdrmerge";
    rev = "f5a2538cffe3e27bd9bea5d6a199fa211d05e6da";
    sha256 = "1bzf9wawbdvdbv57hnrmh0gpjfi5hamgf2nwh2yzd4sh1ssfa8jz";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
    copyDesktopItems
  ];

  buildInputs = [ qtbase libraw exiv2 zlib alglib ];

  cmakeFlags = [
    "-DALGLIB_DIR:PATH=${alglib}"
  ];

  patches = [
    (fetchpatch {
      # patch FindAlglib.cmake to respect ALGLIB_DIR
      # see https://github.com/jcelaya/hdrmerge/pull/213
      name = "patch-hdrmerge-CMake.patch";
      url = "https://github.com/mkroehnert/hdrmerge/commit/472b2dfe7d54856158aea3d5412a02d0bab1da4c.patch";
      sha256 = "0jc713ajr4w08pfbi6bva442prj878nxp1fpl9112i3xj34x9sdi";
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
      mimeTypes = [ "image/x-dcraw" "image/x-adobe-dng" ];
      terminal = false;
    })
  ];

  postInstall = ''
    install -Dm444 ../data/images/icon.png $out/share/icons/hicolor/128x128/apps/hdrmerge.png
  '';

  meta = with lib; {
    homepage = "https://github.com/jcelaya/hdrmerge";
    description = "Combines two or more raw images into an HDR";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.paperdigits ];
  };
}
