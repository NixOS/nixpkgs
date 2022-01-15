{ lib, stdenv, fetchurl, ncurses, libressl
, patches ? [] # allow users to easily override config.def.h
}:

stdenv.mkDerivation rec {
  pname = "sacc";
  version = "1.05";

  src = fetchurl {
    url = "ftp://bitreich.org/releases/sacc/sacc-${version}.tar.gz";
    sha512 = "080vpacipdis396lrw3fxc1z7h2d0njm2zi63kvlk0n2m1disv97c968zx8dp76kfw1s03nvvr6v3vnpfkkywiz1idjc92s5rgcbsk1";
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
