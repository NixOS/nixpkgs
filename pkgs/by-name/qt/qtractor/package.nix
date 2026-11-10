{
  lib,
  alsa-lib,
  aubio,
  cmake,
  dssi,
  fetchurl,
  flac,
  gtk3,
  libjack2,
  ladspa-header,
  ladspaPlugins,
  liblo,
  libmad,
  libsamplerate,
  libsndfile,
  libtool,
  libvorbis,
  lilv,
  lv2,
  opusfile,
  pkg-config,
  qt6,
  rubberband,
  serd,
  stdenv,
  sord,
  sratom,
  suil,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qtractor";
  version = "1.6.4";

  src = fetchurl {
    url = "mirror://sourceforge/qtractor/qtractor-${finalAttrs.version}.tar.gz";
    hash = "sha256-rXjiDytSXb+aSZZVASSkzGvqvkxaCFduBSQWUXEKku8=";
  };

  nativeBuildInputs = [
    cmake
    libtool
    pkg-config
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  # Qt's GTK3 file chooser uses GSettings. GTK3's GSettings schemas
  # are installed below share/gsettings-schemas, which is not otherwise
  # exposed to the wrapped Qt application.
  qtWrapperArgs = [
    "--suffix"
    "XDG_DATA_DIRS"
    ":"
    "${gtk3}/share/gsettings-schemas/${gtk3.name}"
  ];

  buildInputs = [
    alsa-lib
    aubio
    dssi
    flac
    libjack2
    ladspa-header
    ladspaPlugins
    liblo
    libmad
    libsamplerate
    libsndfile
    libtool
    libvorbis
    lilv
    lv2
    opusfile
    qt6.qtbase
    qt6.qtsvg
    rubberband
    serd
    sord
    sratom
    suil
  ];

  meta = {
    description = "Audio/MIDI multi-track sequencer";
    homepage = "https://qtractor.sourceforge.io";
    changelog = "https://github.com/rncbc/qtractor/blob/v${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl2Plus;
    mainProgram = "qtractor";
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
