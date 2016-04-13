{ fetchurl, stdenv, pkgconfig, libao, readline, json_c, libgcrypt, libav, curl }:

stdenv.mkDerivation rec {
  name = "pianobar-2015.11.22";

  src = fetchurl {
    url = "http://6xq.net/projects/pianobar/${name}.tar.bz2";
    sha256 = "0arjvs31d108l1mn2k2hxbpg3mxs47vqzxm0lzdpfcjvypkckyr3";
  };

  buildInputs = [
    pkgconfig libao json_c libgcrypt libav curl
  ];

  makeFlags="PREFIX=$(out)";

  CC = "gcc";
  CFLAGS = "-std=c99";

  meta = with stdenv.lib; {
    description = "A console front-end for Pandora.com";
    homepage = "http://6xq.net/projects/pianobar/";
    platforms = platforms.linux;
    license = licenses.mit; # expat version
    maintainers = with maintainers; [ eduarrrd ];
  };
}
