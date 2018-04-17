{ stdenv, lib, fetchFromGitHub, cmake, extra-cmake-modules, pkgconfig, qmake
, libpthreadstubs, libxcb, libXdmcp, qtsvg, qttools, qtwebengine, qtx11extras, kwallet, openssl }:

stdenv.mkDerivation rec {
  name = "falkon-${version}";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner  = "KDE";
    repo   = "falkon";
    rev    = "v${version}";
    sha256 = "148idxvx32iwg18m3b7s22awcijnbrywz9r8gnfrq6gpwr0m2jna";
  };

  preConfigure = ''
    export NONBLOCK_JS_DIALOGS=true
    export KDE_INTEGRATION=true
    export GNOME_INTEGRATION=false
    export FALKON_PREFIX=$out
  '';

  buildInputs = [
    libpthreadstubs libxcb libXdmcp
    kwallet
    qtsvg qtwebengine qtx11extras
  ];

  nativeBuildInputs = [ cmake extra-cmake-modules pkgconfig qmake qttools ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "QtWebEngine based cross-platform web browser";
    homepage    = https://community.kde.org/Incubator/Projects/Falkon;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = platforms.unix;
  };
}
