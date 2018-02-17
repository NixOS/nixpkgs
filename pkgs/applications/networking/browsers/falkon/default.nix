{ stdenv, lib, fetchFromGitHub, cmake, extra-cmake-modules, pkgconfig, qmake
, libpthreadstubs, libxcb, libXdmcp, qtsvg, qttools, qtwebengine, qtx11extras, kwallet, openssl }:

stdenv.mkDerivation rec {
  # KDE hasn't made a release of falkon yet so we just track git for now which is
  # based on the most recent release of qupzilla
  # This wip version is 2.1.99 so we add the .1
  name = "falkon-${version}.1";
  version = "2.1.99";

  src = fetchFromGitHub {
    owner  = "KDE";
    repo   = "falkon";
    rev    = "dd3c570c41b4b3d0ad17202b78bf14cf1ac56495";
    sha256 = "07d40cpckaprj74mr06k3mfriwb471bdmq60smls34y62ss55q9d";
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
