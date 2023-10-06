{ lib, stdenv, fetchurl, ncurses, libressl
, patches ? [] # allow users to easily override config.def.h
}:

stdenv.mkDerivation rec {
  pname = "sacc";
  version = "1.06";

  src = fetchurl {
    url = "ftp://bitreich.org/releases/sacc/sacc-${version}.tar.gz";
    hash = "sha512-eoleQy4dKLfZsrsqUybKMjUIdqLIDTncbBnnU0fXKkhH8apP8R8H6Kmt6hTqcbhNcIkNzBcP9s4Ld54dZYa0+g==";
  };

  inherit patches;

  buildInputs = [ ncurses libressl ];

  CFLAGS = lib.optionals stdenv.isDarwin [
    "-D_DARWIN_C_SOURCE"
  ];

  postPatch = ''
    substituteInPlace config.mk \
      --replace curses ncurses \
      --replace "/usr/local" "$out"
    '';

  meta = with lib; {
    description = "A terminal gopher client";
    homepage = "gopher://bitreich.org/1/scm/sacc";
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
    platforms = platforms.unix;
  };
}
