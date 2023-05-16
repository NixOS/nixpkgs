{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, qmake
, python3
, qtbase
<<<<<<< HEAD
, rocksdb_7_10
=======
, rocksdb
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, zeromq
}:

stdenv.mkDerivation rec {
  pname = "fulcrum";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "cculianu";
    repo = "Fulcrum";
    rev = "v${version}";
    sha256 = "sha256-guvOs/HsSuj5QOMTzmKxMaC8iUyTkVgEpp8pQ63aIIQ=";
  };

  nativeBuildInputs = [ pkg-config qmake ];

  dontWrapQtApps = true; # no GUI

<<<<<<< HEAD
  buildInputs = [ python3 qtbase rocksdb_7_10 zeromq ];
=======
  buildInputs = [ python3 qtbase rocksdb zeromq ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Fast & nimble SPV server for Bitcoin Cash & Bitcoin BTC";
    homepage = "https://github.com/cculianu/Fulcrum";
    maintainers = with maintainers; [ prusnak ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
