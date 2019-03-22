{ stdenv, fetchurl, hamlib, fltk13, libjpeg, libpng, portaudio, libsndfile,
  libsamplerate, libpulseaudio, libXinerama, gettext, pkgconfig, alsaLib }:

stdenv.mkDerivation rec {
  version = "4.1.01";
  pname = "fldigi";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1pznq18rv8q7qflpnnk6wvbwfqvhvyx1a77jlp3kzjh19pjaqldy";
  };

  buildInputs = [ libXinerama gettext hamlib fltk13 libjpeg libpng portaudio
                  libsndfile libsamplerate libpulseaudio pkgconfig alsaLib ];

  meta = {
    description = "Digital modem program";
    homepage = https://sourceforge.net/projects/fldigi/;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ relrod ftrvxmtrx ];
    platforms = stdenv.lib.platforms.linux;
  };
}
