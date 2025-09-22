{
  lib,
  stdenv,
  fetchsvn,
  pkg-config,
  which,
  autoconf,
  automake,
  libtool,
  hexdump,
  libao,
  zlib,
  curl,
}:

stdenv.mkDerivation {
  pname = "sc68";
  version = "unstable-2022-11-24";

  src = fetchsvn {
    url = "svn://svn.code.sf.net/p/sc68/code/";
    rev = "695";
    sha256 = "sha256-RO3Yhjalu49BUM0fYOZtI2l6KbuUuw03whRxlKneabo=";
  };

  preConfigure = "tools/svn-bootstrap.sh";

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoconf
    automake
    hexdump
    libtool
    pkg-config
    which
  ];

  buildInputs = [
    curl
    libao
    zlib
  ];

  meta = with lib; {
    description = "Atari ST and Amiga music player";
    homepage = "http://sc68.atari.org/project.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.all;
  };
}
