{ stdenv, fetchFromGitHub, wrapGAppsHook, gtk2, boost, gnome2, scons,
mjpegtools, libdvdread, dvdauthor, gettext, dvdplusrwtools, libxmlxx, ffmpeg,
enca, pkgconfig }:

stdenv.mkDerivation rec {
  name = "bombono-${version}";
  version = "1.2.4";
  src = fetchFromGitHub {
    owner = "muravjov";
    repo = "bombono-dvd";
    rev = version;
    sha256 = "1lz1vik6abn1i1pvxhm55c9g47nxxv755wb2ijszwswwrwgvq5b9";
  };

  nativeBuildInputs = [ wrapGAppsHook scons pkgconfig gettext ];

  buildInputs = [
    gtk2 gnome2.gtkmm mjpegtools libdvdread dvdauthor boost dvdplusrwtools
    libxmlxx ffmpeg enca
    ];

  buildPhase = ''
    scons PREFIX=$out
    '';

  installPhase = ''
    scons install
    '';

  meta = {
    description = "a DVD authoring program for personal computers";
    homepage = "http://www.bombono.org/";
    license = stdenv.lib.licenses.gpl2;
  };
}
