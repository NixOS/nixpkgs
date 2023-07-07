{ lib
, stdenv
, fetchurl
, SDL
, SDL_image
, SDL_ttf
, fontconfig
, libpng
, libtiff
, lua5
, pkg-config
, zlib
}:

stdenv.mkDerivation rec {
  version = "2.8.3091";
  pname = "grafx2";

  src = fetchurl {
    url = "https://pulkomandy.tk/projects/GrafX2/downloads/65";
    name = "${pname}-${version}.tar.gz";
    hash = "sha256-KdY7GUhQp/Q7t/ktLPGxI66ZHy2gDAffn2yB5pmcJCM=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    SDL
    SDL_image
    SDL_ttf
    fontconfig
    libpng
    libtiff
    lua5
    zlib
  ];

  makeFlags = [ "-C src" ];
  installFlags = [ "-C src" "PREFIX=$(out)" ];

  meta = {
    description = "Bitmap paint program inspired by the Amiga programs Deluxe Paint and Brilliance";
    homepage = "http://pulkomandy.tk/projects/GrafX2";
    license = lib.licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = [];
    mainProgram = "grafx2-sdl";
  };
}
