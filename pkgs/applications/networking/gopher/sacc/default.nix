{ lib, stdenv, fetchurl, ncurses
, patches ? [] # allow users to easily override config.def.h
}:

stdenv.mkDerivation rec {
  pname = "sacc";
  version = "1.03";

  src = fetchurl {
    url = "ftp://bitreich.org/releases/sacc/sacc-${version}.tgz";
    sha512 = "sha512-vOjAGBM2+080JZv4C4b5dNRTTX45evWFEJfK1DRaWCYrHRCAe07QdEIrHhbaIxhSYfrBd3D1y75rmDnuPC4THA==";
  };

  inherit patches;

  buildInputs = [ ncurses ];

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
