{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  scons,
  rubberband,
  boost,
  libjack2,
  liblo,
  libsamplerate,
  libsndfile,
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
    scons
  ];
  buildInputs = [
    rubberband
    libsamplerate
    libsndfile
    liblo
    libjack2
    boost
  ];

  preBuild = ''
    substituteInPlace SConstruct \
      --replace-fail 'pkg-config' "${stdenv.cc.targetPrefix}pkg-config"
  '';

  prefixKey = "PREFIX=";

  meta = with lib; {
    homepage = "https://das.nasophon.de/klick/";
    description = "Advanced command-line metronome for JACK";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    mainProgram = "klick";
  };
}
