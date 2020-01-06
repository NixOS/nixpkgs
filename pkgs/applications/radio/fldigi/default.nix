{ stdenv, fetchurl, hamlib, fltk13, libjpeg, libpng, portaudio, libsndfile,
  libsamplerate, libpulseaudio, libXinerama, gettext, pkgconfig, alsaLib }:

stdenv.mkDerivation rec {
  version = "4.1.08.51";
  pname = "fldigi";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0wki9d19q8rkjxcd3dz3k0a395gmbnji4fxlhw6dpcyqpfw88fcs";
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
