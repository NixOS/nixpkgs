{
  stdenv,
  fetchurl,
  lib,
  pkg-config,
  alsa-lib,
  ffmpeg,
  libjack2,
  libogg,
  libpulseaudio,
  speexdsp,
}:

stdenv.mkDerivation rec {
  pname = "alsa-plugins";
  version = "1.2.12";

  src = fetchurl {
    url = "mirror://alsa/plugins/alsa-plugins-${version}.tar.bz2";
    hash = "sha256-e9ioPTBOji2GoliV2Nyw7wJFqN8y4nGVnNvcavObZvI=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    alsa-lib
    ffmpeg
    libjack2
    libogg
    libpulseaudio
    speexdsp
  ];

  meta = with lib; {
    description = "Various plugins for ALSA";
    homepage = "http://alsa-project.org/";
    license = licenses.lgpl21;
    maintainers = [ maintainers.marcweber ];
    platforms = platforms.linux;
  };
}
