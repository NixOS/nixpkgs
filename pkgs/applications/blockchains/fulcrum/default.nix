{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  qmake,
  python3,
  qtbase,
  rocksdb_7_10,
  zeromq,
}:

stdenv.mkDerivation rec {
  pname = "fulcrum";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "cculianu";
    repo = "Fulcrum";
    rev = "v${version}";
    sha256 = "sha256-+hBc7jW1MVLVjYXNOV7QvFJJpZ5RzW5/c9NdqOXrsj0=";
  };

  nativeBuildInputs = [
    pkg-config
    qmake
  ];

  dontWrapQtApps = true; # no GUI

  buildInputs = [
    python3
    qtbase
    rocksdb_7_10
    zeromq
  ];

  meta = {
    description = "Fast & nimble SPV server for Bitcoin Cash & Bitcoin BTC";
    homepage = "https://github.com/cculianu/Fulcrum";
    maintainers = with lib.maintainers; [ prusnak ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
}
