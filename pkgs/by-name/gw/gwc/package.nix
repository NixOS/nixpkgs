{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  alsa-lib,
  libpulseaudio,
  gtk2,
  hicolor-icon-theme,
  libsndfile,
  fftw,
}:

stdenv.mkDerivation rec {
  pname = "gwc";
  version = "0.22-06";

  src = fetchFromGitHub {
    owner = "AlisterH";
    repo = pname;
    rev = version;
    sha256 = "sha256-hRwy++gZiW/olIIeiVTpdIjPLIHgvgVUGEaUX9tpFbY=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    libpulseaudio
    gtk2
    hicolor-icon-theme
    libsndfile
    fftw
  ];

  enableParallelBuilding = false; # Fails to generate machine.h in time.

  meta = with lib; {
    description = "GUI application for removing noise (hiss, pops and clicks) from audio files";
    homepage = "https://github.com/AlisterH/gwc/";
    changelog = "https://github.com/AlisterH/gwc/blob/${version}/Changelog";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ magnetophon ];
    platforms = platforms.linux;
  };
}
