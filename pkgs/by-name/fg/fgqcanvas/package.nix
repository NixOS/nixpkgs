{ fetchgit
, pkg-config
, stdenv
, lib
# Package dependencies
, qt5
}:

stdenv.mkDerivation rec {
  pname = "fgqcanvas";
  version = "0-unstable-2024-02-11";

  src = fetchgit {
    url = "https://git.code.sf.net/p/flightgear/flightgear";
    rev = "3168828949d6b42959ccee6c202b8895493edb2b";
    sha256 = "sha256-QiIMkrzaB/ljVf6c+RJNFWKLZa84cIjYPO5nxEFDqjg=";
  };

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
    qt5.qmake
    pkg-config
    qt5.qttools
  ];
  buildInputs = [
    qt5.qtwebsockets
  ];

  configurePhase = ''
    runHook preConfigure
    cd utils/fgqcanvas/
    mkdir -p build
    cd build
    qmake -makefile ../fgcanvas.pro CONFIG+="release" QMAKE_CXXFLAGS+=' -Wno-deprecated-copy -Wno-deprecated -Wno-deprecated-declarations'
    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv fgqcanvas $out/bin/
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://sourceforge.net/p/flightgear/flightgear/ci/next/tree/utils/fgqcanvas/README.md";
    description = "A Qt-based remote canvas application for FlightGear";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nayala ];
    mainProgram = "fgqcanvas";
  };
}
