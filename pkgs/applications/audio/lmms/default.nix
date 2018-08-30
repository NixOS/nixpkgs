{ stdenv, fetchFromGitHub, cmake, pkgconfig, alsaLib ? null, fftwFloat, fltk13
, fluidsynth ? null, lame ? null, libgig ? null, libjack2 ? null, libpulseaudio ? null
, libsamplerate, libsoundio ? null, libsndfile, libvorbis ? null, portaudio ? null
, qtbase, qtx11extras, qttools, SDL ? null }:

stdenv.mkDerivation rec {
  name = "lmms-${version}";
  version = "1.2.0-rc6";

  src = fetchFromGitHub {
    owner = "LMMS";
    repo = "lmms";
    rev = "v${version}";
    sha256 = "1pqir5srfrknfd8nmbz565ymq18ffw8d8k9pbmzggaxvlcr12b25";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake qttools pkgconfig ];

  buildInputs = [
    alsaLib
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

  cmakeFlags = [ "-DWANT_QT5=ON" ];
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "DAW similar to FL Studio (music production software)";
    homepage = https://lmms.io;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ goibhniu yegortimoshenko ];
  };
}
