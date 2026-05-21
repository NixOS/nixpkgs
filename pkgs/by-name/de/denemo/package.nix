{
  lib,
  stdenv,
  fetchgit,
  fetchDebianPatch,
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

stdenv.mkDerivation (finalAttrs: {
  pname = "denemo";
  version = "2.6.49";

  src = fetchgit {
    url = "https://git.savannah.gnu.org/git/denemo.git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TUdaGOChqwK3fAmdaP9Lg2FGrEWF0yjwqsRXK7h/83Y=";
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
  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  patches = [
    (fetchDebianPatch {
      pname = "denemo";
      version = "2.6.49";
      debianRevision = "0.2";
      patch = "0002-Prevent-incompatible-pointer-types.patch";
      hash = "sha256-l1eXjQieH5ySqwaTJAE8lUq/FsB//cl02Wgt0TRQBMo=";
    })
    (fetchDebianPatch {
      pname = "denemo";
      version = "2.6.49";
      debianRevision = "0.2";
      patch = "0013-Fix-FTBFS-with-GCC-14.patch";
      hash = "sha256-H3hRmAPazYRkwQI97vNR9kpV0lYpIiAXyMfrnJl+lNo=";
    })
    (fetchDebianPatch {
      pname = "denemo";
      version = "2.6.49";
      debianRevision = "0.2";
      patch = "0014-Fix-FTBFS-with-GCC-15.patch";
      hash = "sha256-UG/YZWp+twJdvqiXR4NfB3knm04lAyICh5/LHN2pm54=";
    })
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

  meta = {
    description = "Music notation and composition software used with lilypond";
    homepage = "http://denemo.org";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.olynch ];
  };
})
