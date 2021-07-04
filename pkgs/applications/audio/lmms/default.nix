{ lib, fetchFromGitHub, cmake, pkg-config, alsa-lib, fftwFloat, fltk13
, fluidsynth_1, lame, libgig, libjack2, libpulseaudio
, libsamplerate, libsoundio, libsndfile, libvorbis, portaudio
, qtbase, qtx11extras, qttools, SDL, mkDerivation }:

mkDerivation rec {
  pname = "lmms";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "LMMS";
    repo = "lmms";
    rev = "v${version}";
    sha256 = "006hwv1pbh3y5whsxkjk20hsbgwkzr4dawz43afq1gil69y7xpda";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake qttools pkg-config ];

  buildInputs = [
    alsa-lib
    fftwFloat
    fltk13
    fluidsynth_1
    lame
    libgig
    libjack2
    libpulseaudio
    libsamplerate
    libsndfile
    libsoundio
    libvorbis
    portaudio
    qtbase
    qtx11extras
    SDL # TODO: switch to SDL2 in the next version
  ];

  cmakeFlags = [ "-DWANT_QT5=ON" ];

  meta = with lib; {
    description = "DAW similar to FL Studio (music production software)";
    homepage = "https://lmms.io";
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ goibhniu yegortimoshenko ];
  };
}
