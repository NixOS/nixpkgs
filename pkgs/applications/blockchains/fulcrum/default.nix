{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, qmake
, python3
, qtbase
, rocksdb_7_10
, zeromq
}:

stdenv.mkDerivation rec {
  pname = "fulcrum";
  version = "1.9.8";

  src = fetchFromGitHub {
    owner = "cculianu";
    repo = "Fulcrum";
    rev = "v${version}";
    sha256 = "sha256-cWrhALYIjhOCKi/uPXD8Ty0wuN4WQq+8o97M6CtW+YE=";
  };

  nativeBuildInputs = [ pkg-config qmake ];

  dontWrapQtApps = true; # no GUI

  buildInputs = [ python3 qtbase rocksdb_7_10 zeromq ];

  meta = with lib; {
    description = "Fast & nimble SPV server for Bitcoin Cash & Bitcoin BTC";
    homepage = "https://github.com/cculianu/Fulcrum";
    maintainers = with maintainers; [ prusnak ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
