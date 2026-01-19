{
  lib,
  stdenv,
  fetchgit,
  pkg-config,
  libjack2,
  gettext,
  intltool,
  guile,
  lilypond,
  glib,
  libxml2,
  librsvg,
  libsndfile,
  aubio,
  gtk3,
  gtksourceview,
  evince,
  fluidsynth,
  rubberband,
  autoreconfHook,
  gtk-doc,
  portaudio,
  portmidi,
  fftw,
  wrapGAppsHook3,
}:

stdenv.mkDerivation {
  pname = "denemo";
  version = "2.6.43";

  src = fetchgit {
    url = "https://git.savannah.gnu.org/git/denemo.git";
    rev = "b04ead1d3efeee036357cf36898b838a96ec5332";
    hash = "sha256-XMFbPk70JqUHWBPEK8rjr70iMs49RNyaaCUGnYlLf2E=";
  };

  buildInputs = [
    libjack2
    guile
    lilypond
    glib
    libxml2
    librsvg
    libsndfile
    aubio
    gtk3
    gtksourceview
    evince
    fluidsynth
    rubberband
    portaudio
    fftw
    portmidi
  ];

  # error by default in GCC 14
  NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lilypond}/bin"
    )
  '';

  nativeBuildInputs = [
    autoreconfHook
    gtk-doc
    wrapGAppsHook3
    intltool
    gettext
    pkg-config
  ];

  meta = {
    description = "Music notation and composition software used with lilypond";
    homepage = "http://denemo.org";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.olynch ];
  };
}
