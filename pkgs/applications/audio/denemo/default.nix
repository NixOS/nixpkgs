{ lib, stdenv, fetchurl, pkg-config
, libjack2, gettext, intltool, guile_2_0, lilypond
, glib, libxml2, librsvg, libsndfile, aubio
, gtk3, gtksourceview, evince, fluidsynth, rubberband
, portaudio, portmidi, fftw, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "denemo";
  version = "2.6.0";

  src = fetchurl {
    url = "https://ftp.gnu.org/gnu/denemo/denemo-${version}.tar.gz";
    sha256 = "sha256-S+WXDGmEf5fx+HYnXJdE5QNOfJg7EqEEX7IMI2SUtV0=";
  };

  buildInputs = [
    libjack2 guile_2_0 lilypond glib libxml2 librsvg libsndfile
    aubio gtk3 gtksourceview evince fluidsynth rubberband portaudio fftw portmidi
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lilypond}/bin"
    )
  '';

  nativeBuildInputs = [
    wrapGAppsHook
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
