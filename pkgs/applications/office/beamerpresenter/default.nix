{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, wrapGAppsHook
, wrapQtAppsHook
, gst_all_1
, qtbase
, qtmultimedia
, qttools
, qtwayland
, zlib
# only required when using poppler
, poppler
# only required when using mupdf
, freetype
, gumbo
, jbig2dec
, mupdf
, openjpeg
# choose renderer: mupdf or poppler or both (not recommended)
, usePoppler ? false
, useMupdf ? true
}:

stdenv.mkDerivation rec {
  pname = "beamerpresenter";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "stiglers-eponym";
    repo = "BeamerPresenter";
    rev = "v${version}";
    sha256 = "16v263nnnipih3lxg95rmwz0ihnvpl4n1wlj9r6zavnspzlp9dvb";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook
    wrapQtAppsHook
  ];

  dontWrapGApps = true;

  buildInputs = [
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    zlib
    qtbase
    qtmultimedia
    qttools
    qtwayland
  ] ++ lib.optionals useMupdf [
    freetype
    gumbo
    jbig2dec
    mupdf
    openjpeg
  ] ++ lib.optionals usePoppler [
    poppler
  ];

  cmakeFlags = [
    "-DGIT_VERSION=OFF"
    "-DUSE_POPPLER=${lib.boolToCMakeString usePoppler}"
    "-DUSE_MUPDF=${lib.boolToCMakeString useMupdf}"
    "-DUSE_MUJS=OFF"
    "-DUSE_GUMBO=ON"
    "-DUSE_TRANSLATIONS=ON"
    "-DQT_VERSION_MAJOR=${lib.versions.major qtbase.version}"
  ];

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Modular multi screen pdf presentation viewer";
    homepage = "https://github.com/stiglers-eponym/BeamerPresenter";
    license = with licenses; [ agpl3 gpl3Plus ];
    platforms = platforms.all;
    maintainers = with maintainers; [ pacien dotlambda ];
  };
}
