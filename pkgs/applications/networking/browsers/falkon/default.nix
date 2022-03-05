{ stdenv, mkDerivation, lib, fetchFromGitHub, fetchpatch
, cmake, extra-cmake-modules, pkg-config, qmake
, libpthreadstubs, libxcb, libXdmcp
, qtsvg, qttools, qtwebengine, qtx11extras
, qtwayland, wrapQtAppsHook
, kwallet
}:

mkDerivation rec {
  pname = "falkon";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner  = "KDE";
    repo   = "falkon";
    rev    = "v${version}";
    sha256 = "sha256-esi9YWd1PtQpDBhI1NtWEjZIoMoNUpAF+kQad67mLzE=";
  };

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
