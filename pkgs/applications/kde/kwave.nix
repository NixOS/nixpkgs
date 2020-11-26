{ mkDerivation, lib, extra-cmake-modules, kdoctools, qtmultimedia, kcompletion, kconfig, kcrash, kiconthemes, kio, audiofile, libsamplerate
, alsaLib, libpulseaudio, flac, id3lib, libogg, libmad, libopus, libvorbis, fftw, librsvg }:

mkDerivation {
  name = "kwave";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/multimedia/org.kde.kwave";
    description = "A simple media player";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    alsaLib
    audiofile
    kcrash
    kdoctools
    qtmultimedia
    kcompletion
    kconfig
    kiconthemes
    kio
    libpulseaudio
    libsamplerate
    flac
    fftw
    id3lib
    libogg
    libmad
    libopus
    libvorbis
    librsvg
  ];
}
