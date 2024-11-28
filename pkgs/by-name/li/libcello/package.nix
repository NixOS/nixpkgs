{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libcello";
  version = "2.1.0";

  src = fetchurl {
    url = "https://libcello.org/static/libCello-${version}.tar.gz";
    sha256 = "0a1b2x5ni07vd9ridnl7zv7h2s32070wsphjy94qr066b99gdb29";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://libcello.org/";
    description = "Higher level programming in C";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.MostAwesomeDude ];
    platforms = lib.platforms.unix;
  };
}
