{ lib, stdenv
, fetchsvn
, pkg-config
, which
, autoconf
, automake
, libtool
, hexdump
, libao
, zlib
, curl
}:

stdenv.mkDerivation rec {
  pname = "sc68";
  version = "unstable-2020-05-18";

  src = fetchsvn {
    url = "svn://svn.code.sf.net/p/sc68/code/";
    rev = "693";
    sha256 = "0liz5yjwiy41y160ag83zz9s5l8mk72fscxgvjv9g5qf4gwffnfa";
  };

  preConfigure = "tools/svn-bootstrap.sh";

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkg-config which autoconf automake libtool hexdump ];

  buildInputs = [ libao zlib curl ];

  meta = with lib; {
    description = "Atari ST and Amiga music player";
    homepage = "http://sc68.atari.org/project.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.all;
  };
}
