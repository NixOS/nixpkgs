{ fetchurl, stdenv, pkgconfig, libao, faad2, libmad, readline, json_c, libgcrypt, gnutls }:

stdenv.mkDerivation rec {
  name = "pianobar-2013.05.19";

  src = fetchurl {
    url = "http://6xq.net/projects/pianobar/${name}.tar.bz2";
    sha256 = "cf88e82663d2b0aa4d73e761506eac4f3e7bc789b57d92377acd994d785e1046";
  };

  buildInputs = [
    pkgconfig libao faad2 libmad json_c libgcrypt gnutls
  ];

  makeFlags="PREFIX=$(out)";

  CC = "gcc";
  CFLAGS = "-std=c99";

  meta = {
    description = "A console front-end for Pandora.com";
    homepage = "http://6xq.net/projects/pianobar/";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.mit; # expat version
  };
}
