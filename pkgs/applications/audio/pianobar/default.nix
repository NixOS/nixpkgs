{ fetchurl, stdenv, pkgconfig, libao, readline, json_c, libgcrypt, gnutls, libav }:

stdenv.mkDerivation rec {
  name = "pianobar-2014.09.28";

  src = fetchurl {
    url = "http://6xq.net/projects/pianobar/${name}.tar.bz2";
    sha256 = "6bd10218ad5d68c4c761e02c729627d2581b4a6db559190e7e52dc5df177e68f";
  };

  buildInputs = [
    pkgconfig libao json_c libgcrypt gnutls libav
  ];

  makeFlags="PREFIX=$(out)";

  CC = "gcc";
  CFLAGS = "-std=c99";

  configurePhase = "export CC=${CC}";

  meta = with stdenv.lib; {
    description = "A console front-end for Pandora.com";
    homepage = "http://6xq.net/projects/pianobar/";
    platforms = platforms.linux;
    license = licenses.mit; # expat version
    maintainers = with maintainers; [ eduarrrd ];
  };
}
