{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
  gettext,
  ncurses,
  libsamplerate,
}:

stdenv.mkDerivation rec {
  pname = "alsa-oss";
  version = "1.1.8";

  src = fetchurl {
    url = "mirror://alsa/oss-lib/${pname}-${version}.tar.bz2";
    sha256 = "13nn6n6wpr2sj1hyqx4r9nb9bwxnhnzw8r2f08p8v13yjbswxbb4";
  };

  buildInputs = [
    alsa-lib
    ncurses
    libsamplerate
  ];
  nativeBuildInputs = [ gettext ];

  configureFlags = [ "--disable-xmlto" ];

  installFlags = [ "ASOUND_STATE_DIR=$(TMPDIR)/dummy" ];

  meta = with lib; {
    homepage = "http://www.alsa-project.org/";
    description = "ALSA, the Advanced Linux Sound Architecture alsa-oss emulation";
    mainProgram = "aoss";

    longDescription = ''
      The Advanced Linux Sound Architecture (ALSA) provides audio and
      MIDI functionality to the Linux-based operating system.
    '';

    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
