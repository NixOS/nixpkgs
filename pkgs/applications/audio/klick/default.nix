{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, scons
, rubberband
, boost
, libjack2
, liblo
, libsamplerate
, libsndfile
}:

stdenv.mkDerivation rec {
  pname = "klick";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "Allfifthstuning";
    repo = "klick";
    rev = version;
    hash = "sha256-jHyeVCmyy9ipbVaF7GSW19DOVpU9EQJoLcGq9uos+eY=";
  };

  nativeBuildInputs = [
    pkg-config
    rubberband
    scons
  ];
  buildInputs = [ libsamplerate libsndfile liblo libjack2 boost ];
  prefixKey = "PREFIX=";

  meta = {
    homepage = "https://das.nasophon.de/klick/";
    description = "Advanced command-line metronome for JACK";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
