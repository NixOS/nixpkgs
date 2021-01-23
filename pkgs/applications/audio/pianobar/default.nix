{ fetchurl, lib, stdenv, pkg-config, libao, json_c, libgcrypt, ffmpeg_3, curl }:

stdenv.mkDerivation rec {
  name = "pianobar-2020.11.28";

  src = fetchurl {
    url = "http://6xq.net/projects/pianobar/${name}.tar.bz2";
    sha256 = "1znlwybfpxsjqr1jmr8j0ci8wzmpzmk2yxb0qcx9w9a8nnbgnfv5";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libao json_c libgcrypt ffmpeg_3 curl
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  CC = "gcc";
  CFLAGS = "-std=c99";

  meta = with lib; {
    description = "A console front-end for Pandora.com";
    homepage = "https://6xq.net/pianobar/";
    platforms = platforms.unix;
    license = licenses.mit; # expat version
  };
}
