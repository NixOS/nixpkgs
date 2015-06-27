{ stdenv, fetchFromGitHub, pkgconfig, libtoxcore, qt5, openal, opencv
, libsodium, libXScrnSaver }:

let

  filteraudio = stdenv.mkDerivation rec {
    name = "filter_audio-20150516";

    src = fetchFromGitHub {
      owner = "irungentoo";
      repo = "filter_audio";
      rev = "612c5a102550c614e4c8f859e753ea64c0b7250c";
      sha256 = "0bmf8dxnr4vb6y36lvlwqd5x68r4cbsd625kbw3pypm5yqp0n5na";
    };

    doCheck = false;

    makeFlags = "PREFIX=$(out)";
  };

in stdenv.mkDerivation rec {
  name = "qtox-dev-20150519";

  src = fetchFromGitHub {
    owner = "tux3";
    repo = "qTox";
    rev = "a841224683116e75852d6d2ebc9a9f1dc70ec957";
    sha256 = "0bq6wdb8y9mxdvb1i77nck36jh2x5cf1rx8wkikgnapq0j911yss";
  };

  buildInputs =
    [
      libtoxcore openal opencv libsodium filteraudio
      qt5.base qt5.tools libXScrnSaver
    ];
  nativeBuildInputs = [ pkgconfig ];

  configurePhase = "qmake";

  installPhase = ''
    mkdir -p $out/bin
    cp qtox $out/bin
  '';

  meta = with stdenv.lib; {
    description = "QT Tox client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ viric jgeerds ];
    platforms = platforms.all;
  };
}
