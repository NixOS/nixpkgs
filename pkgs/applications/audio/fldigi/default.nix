{ stdenv, fetchurl, hamlib, fltk13, libjpeg, libpng, portaudio, libsndfile,
  libsamplerate, libpulseaudio, libXinerama, gettext, pkgconfig, alsaLib }:

stdenv.mkDerivation rec {
  version = "3.23.07";
  pname = "fldigi";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${name}.tar.gz";
    sha256 = "0v78sk9bllxw640wxd4q2qy0h8z2j1d077nxhmpkjpf6mn6vwcda";
  };

  buildInputs = [ libXinerama gettext hamlib fltk13 libjpeg libpng portaudio
                  libsndfile libsamplerate libpulseaudio pkgconfig alsaLib ];

  meta = {
    description = "Digital modem program";
    homepage = http://sourceforge.net/projects/fldigi/;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ relrod ftrvxmtrx ];
    platforms = stdenv.lib.platforms.linux;
  };
}
