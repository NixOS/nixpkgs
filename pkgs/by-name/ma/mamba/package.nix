{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  xxd,
  cairo,
  fluidsynth,
  libX11,
  libjack2,
  alsa-lib,
  liblo,
  libsigcxx,
  libsmf,
}:

stdenv.mkDerivation rec {
  pname = "mamba";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "brummer10";
    repo = "Mamba";
    tag = "v${version}";
    hash = "sha256-S1+nGnB1LHIUgYves0qtWh+QXYKjtKWICpOo38b3zbY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    xxd
  ];
  buildInputs = [
    cairo
    fluidsynth
    libX11
    libjack2
    alsa-lib
    liblo
    libsigcxx
    libsmf
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/brummer10/Mamba";
    description = "Virtual MIDI keyboard for Jack Audio Connection Kit";
    license = licenses.bsd0;
    maintainers = with maintainers; [
      magnetophon
      orivej
    ];
    platforms = platforms.linux;
  };
}
