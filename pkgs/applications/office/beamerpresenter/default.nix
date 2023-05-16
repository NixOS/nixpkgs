{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, wrapGAppsHook
, wrapQtAppsHook
, gst_all_1
, qtbase
<<<<<<< HEAD
, qtsvg
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
, useExternalRenderer ? false
}:

stdenv.mkDerivation rec {
  pname = "beamerpresenter";
<<<<<<< HEAD
  version = "0.2.4";
=======
  version = "0.2.3-1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "stiglers-eponym";
    repo = "BeamerPresenter";
<<<<<<< HEAD
    rev = "v${version}";
    hash = "sha256-UQbyzkFjrIDPcrE6yGuOWsXNjz8jWyJEWiQwHmf91/8=";
=======
    rev = "dd41a00b3c6c8b881fa62945165c965634df66f0";
    sha256 = "11yj1zl8hdnqbynkbyzg8kwyx1jl8c87x8f8qyllpk0s6cg304d0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    qtsvg
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    qtmultimedia
    qttools
  ] ++ lib.optionals stdenv.isLinux [
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
    "-DUSE_POPPLER=${if usePoppler then "ON" else "OFF"}"
    "-DUSE_MUPDF=${if useMupdf then "ON" else "OFF"}"
    "-DUSE_QTPDF=OFF"
<<<<<<< HEAD
    "-DLINK_MUPDF_THIRD=ON"
    "-DUSE_EXTERNAL_RENDERER=${if useExternalRenderer then "ON" else "OFF"}"
    "-DLINK_MUJS=OFF"
    "-DLINK_GUMBO=ON"
=======
    "-DUSE_MUPDF_THIRD=ON"
    "-DUSE_EXTERNAL_RENDERER=${if useExternalRenderer then "ON" else "OFF"}"
    "-DUSE_MUJS=OFF"
    "-DUSE_GUMBO=ON"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
