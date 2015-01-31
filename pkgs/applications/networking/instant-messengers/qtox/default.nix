{ stdenv, fetchFromGitHub, pkgconfig, libtoxcore, qt5, openalSoft, opencv
, libsodium, libXScrnSaver }:

let

  filteraudio = stdenv.mkDerivation rec {
    name = "filter_audio-20150128";

    src = fetchFromGitHub {
      owner = "irungentoo";
      repo = "filter_audio";
      rev = "76428a6cda";
      sha256 = "0c4wp9a7dzbj9ykfkbsxrkkyy0nz7vyr5map3z7q8bmv9pjylbk9";
    };

    doCheck = false;

    makeFlags = "PREFIX=$(out)";
  };

in stdenv.mkDerivation rec {
  name = "qtox-dev-20150130";

  src = fetchFromGitHub {
    owner = "tux3";
    repo = "qTox";
    rev = "7574569b3d";
    sha256 = "0a7zkhl4w2r5ifzs7vwws2lpplp6q5c4jllyf4ld64njgiz6jzip";
  };

  buildInputs = [ pkgconfig libtoxcore qt5 openalSoft opencv libsodium filteraudio libXScrnSaver ];

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
