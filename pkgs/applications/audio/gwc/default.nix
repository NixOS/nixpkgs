{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, alsaLib
, libpulseaudio
, gtk2
, hicolor-icon-theme
, libsndfile
, fftw
}:

stdenv.mkDerivation rec {
  pname = "gwc";
  version = "0.22-04";

  src = fetchFromGitHub {
    owner = "AlisterH";
    repo = pname;
    rev = version;
    sha256 = "0xvfra32dchnnyf9kj5s5xmqhln8jdrc9f0040hjr2dsb58y206p";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    alsaLib
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
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ magnetophon ];
    platforms = platforms.linux;
  };
}
