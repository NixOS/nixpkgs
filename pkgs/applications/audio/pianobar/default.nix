{ fetchurl, stdenv, pkgconfig, libao, json_c, libgcrypt, ffmpeg, curl }:

stdenv.mkDerivation rec {
  name = "pianobar-2019.02.14";

  src = fetchurl {
    url = "http://6xq.net/projects/pianobar/${name}.tar.bz2";
    sha256 = "07z21vmlqpmvb3294r384iqbx972rwcx6chrdlkfv4hlnc9h7gf0";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    libao json_c libgcrypt ffmpeg curl
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
