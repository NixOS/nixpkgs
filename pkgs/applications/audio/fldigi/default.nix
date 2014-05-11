{ stdenv, fetchurl, hamlib, fltk13, libjpeg, libpng, portaudio, libsndfile,
  libsamplerate, pulseaudio, libXinerama, gettext, pkgconfig, alsaLib }:

stdenv.mkDerivation rec {
  version = "3.21.82";
  name = "fldigi";

  src = fetchurl {
    url = "http://www.w1hkj.com/downloads/${name}/${name}-${version}.tar.gz";
    sha256 = "1q2fc1zm9kfsjir4g6fh95vmjdq984iyxfcs6q4gjqy1znhqcyqs";
  };

  buildInputs = [ libXinerama gettext hamlib fltk13 libjpeg libpng portaudio
                  libsndfile libsamplerate pulseaudio pkgconfig alsaLib ];

  meta = {
    description = "Digital modem program";
    homepage = http://www.w1hkj.com/Fldigi.html;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ relrod ];
    platforms = stdenv.lib.platforms.linux;
  };
}
