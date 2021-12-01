{ lib, stdenv, fetchgit, pkg-config, pidgin } :

let
  version = "54b2992";
in
stdenv.mkDerivation {
  pname = "pidgin-mra";
  inherit version;

  src = fetchgit {
    url = "https://github.com/dreadatour/pidgin-mra";
    rev = version;
    sha256 = "1adq57g11kw7bfpivyvfk3nlpjkc8raiw4bzn3gn4nx3m0wl99vw";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pidgin ];

  postPatch = ''
    sed -i 's|-I/usr/include/libpurple|$(shell pkg-config --cflags purple)|' Makefile
  '';

  makeFlags = [
    "DESTDIR=/"
    "LIBDIR=${placeholder "out"}/lib"
    "DATADIR=${placeholder "out"}/share"
  ];

  meta = {
    homepage = "https://github.com/dreadatour/pidgin-mra";
    description = "Mail.ru Agent plugin for Pidgin / libpurple";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
