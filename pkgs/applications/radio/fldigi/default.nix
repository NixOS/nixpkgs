{ lib, stdenv, fetchurl, hamlib, fltk14, libjpeg, libpng, portaudio, libsndfile,
  libsamplerate, libpulseaudio, libXinerama, gettext, pkg-config, alsa-lib }:

stdenv.mkDerivation rec {
  version = "4.1.18";
  pname = "fldigi";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-PH/YSrOoS6RSWyUenVYSDa7mJqODFoSpdP2tR2+QJw0=";
  };

  buildInputs = [ libXinerama gettext hamlib fltk14 libjpeg libpng portaudio
                  libsndfile libsamplerate libpulseaudio pkg-config alsa-lib ];

  meta = {
    description = "Digital modem program";
    homepage = "https://sourceforge.net/projects/fldigi/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ relrod ftrvxmtrx ];
    platforms = lib.platforms.linux;
  };
}
