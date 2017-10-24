{ stdenv, lib, fetchFromGitHub, cmake, extra-cmake-modules, pkgconfig, qmake
, libpthreadstubs, libxcb, libXdmcp, qtsvg, qttools, qtwebengine, qtx11extras, kwallet, openssl }:

stdenv.mkDerivation rec {
  # Last qupvilla release is 2.1.2 so we add the .1 although it isn't actually a
  # release but it is basically 2.1.2 with the falkon name
  name = "falkon-${version}.1";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner  = "KDE";
    repo   = "falkon";
    rev    = "eecaf2e9d6b572a7f7d2e6dc324e3d79b61c31db";
    sha256 = "01r5aw10jd0qz7xvad0cqzjbnsj7vwblh54wbq4x1m6xbkp6xcgy";
  };

  preConfigure = ''
    export NONBLOCK_JS_DIALOGS=true
    export KDE_INTEGRATION=true
    export GNOME_INTEGRATION=false
    export FALKON_PREFIX=$out
  '';

  dontUseCmakeConfigure = true;

  buildInputs = [
    libpthreadstubs libxcb libXdmcp
    kwallet
    qtsvg qtwebengine qtx11extras
  ];

  nativeBuildInputs = [ cmake extra-cmake-modules pkgconfig qmake qttools ];

  # on 2.1.2: RCC: Error in 'autoscroll.qrc': Cannot find file 'locale/ar_SA.qm'
  enableParallelBuilding = false;

  meta = with stdenv.lib; {
    description = "QtWebEngine based cross-platform web browser";
    homepage    = https://community.kde.org/Incubator/Projects/Falkon;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = platforms.unix;
  };
}
