{ fetchurl, stdenv, pkgconfig, libao, readline, json_c, libgcrypt, libav, curl }:

stdenv.mkDerivation rec {
  name = "pianobar-2016.06.02";

  src = fetchurl {
    url = "http://6xq.net/projects/pianobar/${name}.tar.bz2";
    sha256 = "0n9544bfsdp04xqcjm4nhfvp357dx0c3gpys0rjkq09nzv8b1vy6";
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
