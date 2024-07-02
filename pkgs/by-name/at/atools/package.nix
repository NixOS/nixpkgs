{ fetchFromGitHub
, pkg-config
, stdenv
, lib
# Package dependencies
, qt5
}:

stdenv.mkDerivation rec {
  pname = "atools";
  version = "4.0.6";

  src = fetchFromGitHub {
    owner = "albar965";
    repo = "atools";
    rev = "v${version}";
    sha256 = "sha256-ieL7cGqXNmGMyTf8tXCSmwQFwyHyy8NwGJ+3Zg92nmM=";
  };

  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/include
    mv libatools.a $out
    cp -r * $out/include/
  '';

  nativeBuildInputs = [
    qt5.qmake
    pkg-config
    qt5.qttools
  ];
  buildInputs = [
    qt5.qtwebengine
  ];

  meta = with lib; {
    homepage = "https://github.com/albar965/atools";
    description = "A static library extending Qt for exception handling,
a log4j like logging framework, Flight Simulator related utilities like BGL reader
and more";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nayala ];
  };
}
