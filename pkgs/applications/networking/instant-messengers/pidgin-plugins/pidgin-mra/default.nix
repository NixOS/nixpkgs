{ stdenv, fetchgit, pkgconfig, pidgin } :

let
  version = "54b2992";
in
stdenv.mkDerivation rec {
  name = "pidgin-mra-${version}";

  src = fetchgit {
    url = "https://github.com/dreadatour/pidgin-mra";
    rev = "${version}";
    sha256 = "1nhfx9gi5lhh2xjr9rw600bb53ly2nwiqq422vc0f297qkm1q9y0";
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
  };
}
