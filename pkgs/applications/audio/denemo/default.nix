{ stdenv, fetchurl, pkgconfig
, libjack2, gettext, intltool, guile_2_0, lilypond
, glib, libxml2, librsvg, libsndfile, aubio
, gtk3, gtksourceview, evince, fluidsynth, rubberband
, portaudio, portmidi, fftw, makeWrapper }:

stdenv.mkDerivation rec {
  name = "denemo-${version}";
  version = "2.2.0";

  src = fetchurl {
    url = "https://ftp.gnu.org/gnu/denemo/denemo-${version}.tar.gz";
    sha256 = "18zcs4xmfj4vpzi15dj7k5bjzzzlr3sjf9xhrrgy4samrrdpqzfh";
  };

  buildInputs = [
    libjack2 gettext guile_2_0 lilypond pkgconfig glib libxml2 librsvg libsndfile
    aubio gtk3 gtksourceview evince fluidsynth rubberband portaudio fftw portmidi
    makeWrapper
  ];

  postInstall = ''
    wrapProgram $out/bin/denemo --prefix PATH : ${lilypond}/bin
  '';

  nativeBuildInputs = [
    intltool
  ];

  meta = with stdenv.lib; {
    description = "Music notation and composition software used with lilypond";
    homepage = http://denemo.org;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.olynch ];
  };
}
