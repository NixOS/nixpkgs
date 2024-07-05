{ lib, fetchFromGitHub, fetchpatch, cmake, pkg-config, alsa-lib ? null, carla ? null, fftwFloat, fltk13
, fluidsynth ? null, lame ? null, libgig ? null, libjack2 ? null, libpulseaudio ? null
, libsamplerate, libsoundio ? null, libsndfile, libvorbis ? null, portaudio ? null
, qtbase, qtx11extras, qttools, SDL ? null, mkDerivation }:

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
    carla
    alsa-lib
    fftwFloat
    fltk13
    fluidsynth
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

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/archlinux/svntogit-community/cf64acc45e3264c6923885867e2dbf8b7586a36b/trunk/lmms-carla-export.patch";
      sha256 = "sha256-wlSewo93DYBN2PvrcV58dC9kpoo9Y587eCeya5OX+j4=";
    })
  ];

  cmakeFlags = [ "-DWANT_QT5=ON" ];

  meta = with lib; {
    description = "DAW similar to FL Studio (music production software)";
    mainProgram = "lmms";
    homepage = "https://lmms.io";
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ goibhniu yana ];
  };
}
