{ lib, stdenv, fetchurl, ncurses, libressl
, patches ? [] # allow users to easily override config.def.h
}:

stdenv.mkDerivation rec {
  pname = "sacc";
  version = "1.04";

  src = fetchurl {
    url = "ftp://bitreich.org/releases/sacc/sacc-${version}.tgz";
    sha512 = "1rjxs77a5k2mgpwr2ln1czn64fmss9yw59g0k60r25c2ny2la6ddfcl5zclawcikk346na6m96jrfwssmka0axr2spwpl61wm0lijnk";
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
