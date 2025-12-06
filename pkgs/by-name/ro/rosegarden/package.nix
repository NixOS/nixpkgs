{
  lib,
  stdenv,
  fetchurl,
  cmake,
  makedepend,
  perl,
  pkg-config,
  qt5,
  alsa-lib,
  dssi,
  fftwSinglePrec,
  flac,
  glib,
  ladspaH,
  ladspaPlugins,
  libjack2,
  liblo,
  libmpg123,
  libopus,
  libsamplerate,
  libsndfile,
  libsysprof-capture,
  libvorbis,
  lilv,
  lv2,
  lirc,
  lrdf,
  libogg,
}:

stdenv.mkDerivation rec {
  pname = "rosegarden";
  version = "25.12";

  src = fetchurl {
    url = "mirror://sourceforge/rosegarden/${pname}-${version}.tar.xz";
    sha256 = "sha256-lwvNTMM+Sn17PRzG2MCb/7ql8ApIe5ZcEvbo3KjK+m0=";
  };

  postPhase = ''
    substituteInPlace src/CMakeLists.txt --replace svnheader svnversion
  '';

  nativeBuildInputs = [
    cmake
    makedepend
    perl
    pkg-config
    qt5.qttools
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    dssi
    fftwSinglePrec
    flac
    glib
    ladspaH
    ladspaPlugins
    libjack2
    liblo
    libmpg123
    libogg
    libopus
    libsamplerate
    libsndfile
    libsysprof-capture
    libvorbis
    lilv
    lv2
    lirc
    lrdf
    qt5.qtbase
  ];

  cmakeFlags = [
    "-DLILV_INCLUDE_DIR=${lilv.dev}/include/lilv-0"
  ];

  meta = with lib; {
    homepage = "https://www.rosegardenmusic.com/";
    description = "Music composition and editing environment";
    mainProgram = "rosegarden";
    longDescription = ''
      Rosegarden is a music composition and editing environment based around
      a MIDI sequencer that features a rich understanding of music notation
      and includes basic support for digital audio.

      Rosegarden is an easy-to-learn, attractive application that runs on Linux,
      ideal for composers, musicians, music students, and small studio or home
      recording environments.
    '';
    maintainers = with maintainers; [ lebastr ];
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
  };
}
