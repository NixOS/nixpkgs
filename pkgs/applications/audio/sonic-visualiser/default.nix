# TODO add plugins having various licenses, see http://www.vamp-plugins.org/download.html

{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
  bzip2,
  fftw,
  libjack2,
  libX11,
  liblo,
  libmad,
  lrdf,
  libsamplerate,
  libsndfile,
  pkg-config,
  libpulseaudio,
  qtbase,
  qtsvg,
  redland,
  rubberband,
  serd,
  sord,
  vamp-plugin-sdk,
  fftwFloat,
  capnproto,
  liboggz,
  libfishsound,
  libid3tag,
  opusfile,
  wrapQtAppsHook,
  meson,
  ninja,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "sonic-visualiser";
  version = "4.5.1";

  src = fetchurl {
    url = "https://code.soundsoftware.ac.uk/attachments/download/2841/${pname}-${version}.tar.gz";
    sha256 = "1sgg4m3035a03ldipgysz7zqfa9pqaqa4j024gyvvcwh4ml8iasr";
  };

  nativeBuildInputs = [
    meson
    ninja
    cmake
    pkg-config
    wrapQtAppsHook
  ];
  buildInputs = [
    libsndfile
    qtbase
    qtsvg
    fftw
    fftwFloat
    bzip2
    lrdf
    rubberband
    libsamplerate
    vamp-plugin-sdk
    alsa-lib
    redland
    serd
    sord
    # optional
    libjack2
    # portaudio
    libpulseaudio
    libmad
    libfishsound
    liblo
    libX11
    capnproto
    liboggz
    libid3tag
    opusfile
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "View and analyse contents of music audio files";
    homepage = "https://www.sonicvisualiser.org/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.marcweber ];
    platforms = platforms.linux;
  };
}
