{ stdenv, buildPackages
, fetchurl, pkgconfig, ncurses, gzip
, sslSupport ? true, openssl ? null
, buildPlatform, hostPlatform
}:

assert sslSupport -> openssl != null;

stdenv.mkDerivation rec {
  name = "lynx-${version}";
  version = "2.8.9dev.11";

  src = fetchurl {
    url = "http://invisible-mirror.net/archives/lynx/tarballs/lynx${version}.tar.bz2";
    sha256 = "1cqm1i7d209brkrpzaqqf2x951ra3l67dw8x9yg10vz7rpr9441a";
  };

  configureFlags = [ "--enable-widec" ] ++ stdenv.lib.optional sslSupport "--with-ssl";

  nativeBuildInputs = stdenv.lib.optional sslSupport pkgconfig
    ++ stdenv.lib.optional (hostPlatform != buildPlatform) buildPackages.stdenv.cc;

  buildInputs = [ ncurses gzip ] ++ stdenv.lib.optional sslSupport openssl.dev;

  meta = with stdenv.lib; {
    homepage = http://lynx.isc.org/;
    description = "A text-mode web browser";
    platforms = platforms.unix;
  };
}
