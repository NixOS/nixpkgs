{ fetchurl, stdenv, pkgconfig, libao, json_c, libgcrypt, ffmpeg_3, curl }:

stdenv.mkDerivation rec {
  name = "pianobar-2020.04.05";

  src = fetchurl {
    url = "http://6xq.net/projects/pianobar/${name}.tar.bz2";
    sha256 = "1034f9ilj9xjw12d6n4vadhl5jzrx0jv8gq1w0rg9hfc55mkn5vc";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    libao json_c libgcrypt ffmpeg_3 curl
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  CC = "gcc";
  CFLAGS = "-std=c99";

  meta = with stdenv.lib; {
    description = "A console front-end for Pandora.com";
    homepage = "https://6xq.net/pianobar/";
    platforms = platforms.unix;
    license = licenses.mit; # expat version
  };
}
