{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  glib,
  gtk2,
  libgnomeui,
  libXv,
  libraw1394,
  libdc1394,
  SDL,
  automake,
  GConf,
}:

stdenv.mkDerivation rec {
  pname = "coriander";
  version = "2.0.1";

  src = fetchurl {
    url = "http://damien.douxchamps.net/ieee1394/coriander/archives/coriander-${version}.tar.gz";
    sha256 = "0l6hpfgy5r4yardilmdrggsnn1fbfww516sk5a90g1740cd435x5";
  };

  # Workaround build failure on -fno-common toolchains:
  #   ld: subtitles.o:src/coriander.h:110: multiple definition of
  #     `main_window'; main.o:src/coriander.h:110: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  preConfigure = ''
    cp ${automake}/share/automake-*/mkinstalldirs .
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    glib
    gtk2
    libgnomeui
    libXv
    libraw1394
    libdc1394
    SDL
    GConf
  ];

  meta = {
    homepage = "https://damien.douxchamps.net/ieee1394/coriander/";
    description = "GUI for controlling a Digital Camera through the IEEE1394 bus";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ viric ];
    platforms = with lib.platforms; linux;
    mainProgram = "coriander";
  };
}
