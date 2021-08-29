{ stdenv, mkDerivation, lib, fetchFromGitHub, fetchpatch
, cmake, extra-cmake-modules, pkg-config, qmake
, libpthreadstubs, libxcb, libXdmcp
, qtsvg, qttools, qtwebengine, qtx11extras
, qtwayland, wrapQtAppsHook
, kwallet
}:

mkDerivation rec {
  pname = "falkon";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner  = "KDE";
    repo   = "falkon";
    rev    = "v${version}";
    sha256 = "1w64slh9wpcfi4v7ds9wci1zvwh0dh787ndpi6hd4kmdgnswvsw7";
  };

  patches = [
    # fixes build with qt5 5.14
    (fetchpatch {
      url = "https://github.com/KDE/falkon/commit/bbde5c6955c43bc744ed2c4024598495de908f2a.diff";
      sha256 = "0f7qcddvvdnij3di0acg7jwvwfwyd0xizlav4wccclbj8x7qp5ld";
    })
  ];

  preConfigure = ''
    export NONBLOCK_JS_DIALOGS=true
    export KDE_INTEGRATION=true
    export GNOME_INTEGRATION=false
    export FALKON_PREFIX=$out
  '';

  buildInputs = [
    libpthreadstubs libxcb libXdmcp
    qtsvg qttools qtwebengine qtx11extras
    kwallet
  ] ++ lib.optionals stdenv.isLinux [ qtwayland ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    qmake
    qttools
    wrapQtAppsHook
  ];

  meta = with lib; {
    description = "QtWebEngine based cross-platform web browser";
    homepage    = "https://community.kde.org/Incubator/Projects/Falkon";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = platforms.unix;
  };
}
