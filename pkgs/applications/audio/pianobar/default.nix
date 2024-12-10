{
  fetchurl,
  lib,
  stdenv,
  pkg-config,
  libao,
  json_c,
  libgcrypt,
  ffmpeg,
  curl,
}:

stdenv.mkDerivation rec {
  pname = "pianobar";
  version = "2022.04.01";

  src = fetchurl {
    url = "https://6xq.net/projects/pianobar/${pname}-${version}.tar.bz2";
    sha256 = "sha256-FnCyiGWouCpXu23+p/FuL6QUXS81SRC7FzgLMsm5R2M=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libao
    json_c
    libgcrypt
    ffmpeg
    curl
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  CC = "gcc";
  CFLAGS = "-std=c99";

  meta = with lib; {
    description = "A console front-end for Pandora.com";
    homepage = "https://6xq.net/pianobar/";
    platforms = platforms.unix;
    license = licenses.mit; # expat version
    mainProgram = "pianobar";
  };
}
