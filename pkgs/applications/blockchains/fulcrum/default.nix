{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, qmake
, python3
, qtbase
, rocksdb
, zeromq
}:

stdenv.mkDerivation rec {
  pname = "fulcrum";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "cculianu";
    repo = "Fulcrum";
    rev = "v${version}";
    sha256 = "sha256-HAA5YRShLzxVP9aIP1RdDH09cZqjiZhZOxxc2EVGvx8=";
  };

  nativeBuildInputs = [ pkg-config qmake ];

  dontWrapQtApps = true; # no GUI

  buildInputs = [ python3 qtbase rocksdb zeromq ];

  meta = with lib; {
    description = "Fast & nimble SPV server for Bitcoin Cash & Bitcoin BTC";
    homepage = "https://github.com/cculianu/Fulcrum";
    maintainers = with maintainers; [ prusnak ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
