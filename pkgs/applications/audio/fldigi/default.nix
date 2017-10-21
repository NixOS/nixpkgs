{ stdenv, fetchurl, hamlib, fltk13, libjpeg, libpng, portaudio, libsndfile,
  libsamplerate, libpulseaudio, libXinerama, gettext, pkgconfig, alsaLib }:

stdenv.mkDerivation rec {
  version = "3.23.15";
  pname = "fldigi";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${name}.tar.gz";
    sha256 = "1nxafk99fr6yb09cq3vdpzjcd85mnjwwl8rzccx21kla1ysihl5m";
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
