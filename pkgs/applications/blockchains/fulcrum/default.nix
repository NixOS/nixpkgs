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
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "cculianu";
    repo = "Fulcrum";
    rev = "v${version}";
    sha256 = "sha256-iHVrJySNdbZ9RXP7QgsDy2o2U/EISAp1/9NFpcEOGeI=";
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
