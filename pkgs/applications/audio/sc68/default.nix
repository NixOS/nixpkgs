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
  version = "unstable-2021-08-23";

  src = fetchsvn {
    url = "svn://svn.code.sf.net/p/sc68/code/";
    rev = "694";
    sha256 = "1yycnr4ndzfhbmki41c30zskwyizpb9wb8sf0gxcprllmbq6a421";
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
