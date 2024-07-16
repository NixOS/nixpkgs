{ lib, stdenv, fetchFromGitHub, libjack2, libsndfile, xorg, freetype
, libxkbcommon, cairo, glib, zenity, flac, libogg, libvorbis, libopus, cmake
, pango, pkg-config, catch2
}:

stdenv.mkDerivation rec {
  pname = "sfizz";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "sfztools";
    repo = pname;
    rev = version;
    hash = "sha256-/G9tvJ4AcBSTmo44xDDKf6et1nSn/FV5m27ztDu10kI=";
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
  nativeBuildInputs = [ cmake pkg-config ];

  # Fix missing include
  patches = [./gcc13.patch];

  postPatch = ''
    cp ${catch2}/include/catch2/catch.hpp tests/catch2/catch.hpp

    substituteInPlace plugins/editor/external/vstgui4/vstgui/lib/platform/linux/x11fileselector.cpp \
      --replace 'zenitypath = "zenity"' 'zenitypath = "${zenity}/bin/zenity"'
    substituteInPlace plugins/editor/src/editor/NativeHelpers.cpp \
      --replace '/usr/bin/zenity' '${zenity}/bin/zenity'
  '';

  cmakeFlags = [ "-DSFIZZ_TESTS=ON" ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/sfztools/sfizz";
    description = "SFZ jack client and LV2 plugin";
    license = licenses.bsd2;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.all;
    badPlatforms = platforms.darwin;
  };
}
