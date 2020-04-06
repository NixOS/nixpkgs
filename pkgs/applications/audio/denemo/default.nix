{ stdenv, fetchurl, pkgconfig
, libjack2, gettext, intltool, guile_2_0, lilypond
, glib, libxml2, librsvg, libsndfile, aubio
, gtk3, gtksourceview, evince, fluidsynth, rubberband
, portaudio, portmidi, fftw, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "denemo";
  version = "2.3.0";

  src = fetchurl {
    url = "https://ftp.gnu.org/gnu/denemo/denemo-${version}.tar.gz";
    sha256 = "1blkcl3slbsq9jlhwcf2m9v9g38a0sjfhh9advgi2qr1gxri08by";
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
    pkgconfig
  ];

  meta = with stdenv.lib; {
    description = "Music notation and composition software used with lilypond";
    homepage = http://denemo.org;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.olynch ];
  };
}
