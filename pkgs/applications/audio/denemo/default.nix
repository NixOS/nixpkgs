{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
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

stdenv.mkDerivation rec {
  pname = "denemo";
  version = "2.6.0";

  src = fetchurl {
    url = "https://ftp.gnu.org/gnu/denemo/denemo-${version}.tar.gz";
    sha256 = "sha256-S+WXDGmEf5fx+HYnXJdE5QNOfJg7EqEEX7IMI2SUtV0=";
  };

  patches = [
    (fetchpatch {
      name = "allow-guile-3.patch";
      url = "https://git.savannah.gnu.org/cgit/denemo.git/patch/?id=9de1c65e56a021925af532bb55336b0ce86d3084";
      postFetch = ''
        substituteInPlace $out \
          --replace "2.6.8" "2.6.0" \
          --replace "2.6.9" "2.6.0"
      '';
      hash = "sha256-Jj33k/KgvZgKG43MuLgjb4A2KNkm/z9ytzGKcXMAOI4=";
    })
  ];

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

  meta = with lib; {
    description = "Music notation and composition software used with lilypond";
    homepage = "http://denemo.org";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.olynch ];
  };
}
