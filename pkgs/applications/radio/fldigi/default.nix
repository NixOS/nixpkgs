{ lib, stdenv, fetchurl, hamlib, fltk14, libjpeg, libpng, portaudio, libsndfile,
  libsamplerate, libpulseaudio, libXinerama, gettext, pkg-config, alsaLib }:

stdenv.mkDerivation rec {
  version = "4.1.17";
  pname = "fldigi";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1gzff60sn3h05279f9mdi1rkdws52m28shcil16911lvlq6ki13m";
  };

  buildInputs = [ libXinerama gettext hamlib fltk14 libjpeg libpng portaudio
                  libsndfile libsamplerate libpulseaudio pkg-config alsaLib ];

  meta = {
    description = "Digital modem program";
    homepage = "https://sourceforge.net/projects/fldigi/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ relrod ftrvxmtrx ];
    platforms = lib.platforms.linux;
  };
}
