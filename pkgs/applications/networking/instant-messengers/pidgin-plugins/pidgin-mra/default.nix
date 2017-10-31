{ stdenv, fetchgit, pkgconfig, pidgin } :

let
  version = "54b2992";
in
stdenv.mkDerivation rec {
  name = "pidgin-mra-${version}";

  src = fetchgit {
    url = "https://github.com/dreadatour/pidgin-mra";
    rev = "${version}";
    sha256 = "1adq57g11kw7bfpivyvfk3nlpjkc8raiw4bzn3gn4nx3m0wl99vw";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ pidgin ];

  preConfigure = ''
    sed -i 's|-I/usr/include/libpurple|$(shell pkg-config --cflags purple)|' Makefile
    export DESTDIR=$out
    export LIBDIR=/lib
    export DATADIR=/share
  '';

  meta = {
    homepage = https://github.com/dreadatour/pidgin-mra;
    description = "Mail.ru Agent plugin for Pidgin / libpurple";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
