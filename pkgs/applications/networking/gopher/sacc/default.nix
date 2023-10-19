{ lib, stdenv, fetchurl, ncurses, libressl
, patches ? [] # allow users to easily override config.def.h
}:

stdenv.mkDerivation rec {
  pname = "sacc";
  version = "1.07";

  src = fetchurl {
    url = "ftp://bitreich.org/releases/sacc/sacc-${version}.tar.gz";
    hash = "sha256-LdEeZH+JWb7iEEzikAXaxG0N5GMPxjgTId4THLgdU2w=";
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
