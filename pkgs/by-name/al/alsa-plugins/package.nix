{
  stdenv,
  fetchurl,
  lib,
  pkg-config,
  alsa-lib,
  libogg,
  libpulseaudio ? null,
  libjack2 ? null,
}:

stdenv.mkDerivation rec {
  pname = "alsa-plugins";
  version = "1.2.7.1";

  src = fetchurl {
    url = "mirror://alsa/plugins/${pname}-${version}.tar.bz2";
    hash = "sha256-jDN4FJVLt8FnRWczpgRhQqKTHxLsy6PsKkrmGKNDJRE=";
  };

  nativeBuildInputs = [ pkg-config ];

  # ToDo: a52, etc.?
  buildInputs =
    [
      alsa-lib
      libogg
    ]
    ++ lib.optional (libpulseaudio != null) libpulseaudio
    ++ lib.optional (libjack2 != null) libjack2;

  meta = with lib; {
    description = "Various plugins for ALSA";
    homepage = "http://alsa-project.org/";
    license = licenses.lgpl21;
    maintainers = [ maintainers.marcweber ];
    platforms = platforms.linux;
  };
}
