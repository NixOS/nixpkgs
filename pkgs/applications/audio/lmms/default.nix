{ stdenv, fetchFromGitHub, cmake, pkgconfig, alsaLib ? null, fftwFloat, fltk13
, fluidsynth_1 ? null, lame ? null, libgig ? null, libjack2 ? null, libpulseaudio ? null
, libsamplerate, libsoundio ? null, libsndfile, libvorbis ? null, portaudio ? null
, qtbase, qtx11extras, qttools, SDL ? null, mkDerivation }:

mkDerivation rec {
  pname = "lmms";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "LMMS";
    repo = "lmms";
    rev = "v${version}";
    sha256 = "08k2nfj0rw9mahr7pr90n79wviqmjmflrgcljc6y3x30v84wbp26";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake qttools pkgconfig ];

  buildInputs = [
    alsaLib
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
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "DAW similar to FL Studio (music production software)";
    homepage = https://lmms.io;
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ goibhniu yegortimoshenko ];
  };
}
