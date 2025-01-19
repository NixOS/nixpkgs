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

  meta = {
    description = "Various plugins for ALSA";
    homepage = "http://alsa-project.org/";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.marcweber ];
    platforms = lib.platforms.linux;
  };
}
