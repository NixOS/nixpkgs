{
  lib,
  stdenv,
  fetchFromGitHub,
  libjack2,
  libsndfile,
  xorg,
  freetype,
  libxkbcommon,
  cairo,
  glib,
  zenity,
  flac,
  libogg,
  libvorbis,
  libopus,
  cmake,
  pango,
  pkg-config,
  catch2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sfizz";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "sfztools";
    repo = "sfizz";
    tag = finalAttrs.version;
    hash = "sha256-347olgxCyCRmKX0jxgBkYkoBuy9TMbsQgWOIoMppUAo=";
    fetchSubmodules = true;
  };

  buildInputs = [
    libjack2
    libsndfile
    flac
    libogg
    libvorbis
    libopus
    xorg.libX11
    xorg.libxcb
    xorg.libXau
    xorg.libXdmcp
    xorg.xcbutil
    xorg.xcbutilcursor
    xorg.xcbutilrenderutil
    xorg.xcbutilkeysyms
    xorg.xcbutilimage
    libxkbcommon
    cairo
    glib
    zenity
    freetype
    pango
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    (lib.cmakeBool "SFIZZ_TESTS" true)
  ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/sfztools/sfizz";
    description = "SFZ jack client and LV2 plugin";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ magnetophon ];
    platforms = lib.platforms.linux;
  };
})
