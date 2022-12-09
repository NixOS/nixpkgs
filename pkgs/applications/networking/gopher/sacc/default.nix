{ lib, stdenv, fetchurl, ncurses, libressl
, patches ? [] # allow users to easily override config.def.h
}:

stdenv.mkDerivation rec {
  pname = "sacc";
  version = "1.06";

  src = fetchurl {
    url = "ftp://bitreich.org/releases/sacc/sacc-${version}.tar.gz";
    sha512 = "7a895e432e1d28b7d9b2bb2a5326ca32350876a2c80d39dc6c19e75347d72a4847f1aa4ff11f07e8a9adea14ea71b84d70890dcc170ff6ce0b779e1d6586b4fa";
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
