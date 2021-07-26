{ lib
, stdenv
, fetchurl
, hamlib
, fltk14
, libjpeg
, libpng
, portaudio
, libsndfile
, libsamplerate
, libpulseaudio
, libXinerama
, gettext
, pkg-config
, alsa-lib
}:

stdenv.mkDerivation rec {
  pname = "fldigi";
  version = "4.1.18";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-PH/YSrOoS6RSWyUenVYSDa7mJqODFoSpdP2tR2+QJw0=";
  };

  buildInputs = [
    libXinerama
    gettext
    hamlib
    fltk14
    libjpeg
    libpng
    portaudio
    libsndfile
    libsamplerate
    libpulseaudio
    pkg-config
    alsa-lib
  ];

  meta = with lib; {
    description = "Digital modem program";
    homepage = "https://sourceforge.net/projects/fldigi/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ relrod ftrvxmtrx ];
    platforms = platforms.linux;
  };
}
