{ stdenv, fetchurl, hamlib, fltk13, libjpeg, libpng, portaudio, libsndfile,
  libsamplerate, pulseaudio, libXinerama, gettext, pkgconfig, alsaLib }:

stdenv.mkDerivation rec {
  version = "3.22.02";
  pname = "fldigi";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://www.w1hkj.com/downloads/${pname}/${name}.tar.gz";
    sha256 = "1gry3r133j2x99h0ji56v6yjxzvbi0hb18p1lbkr9djzjvf591j3";
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
