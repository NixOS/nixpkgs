{
  lib,
  SDL,
  SDL_image,
  SDL_mixer,
  SDL_ttf,
  fetchFromGitHub,
  freetype,
  libjpeg,
  libogg,
  libpng,
  libvorbis,
  pkg-config,
  smpeg,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "onscripter-en";
  version = "20110930";

  # The website is not available now. Let's use a Museoa backup
  src = fetchFromGitHub {
    owner = "museoa";
    repo = "onscripter-en";
    rev = finalAttrs.version;
    hash = "sha256-Lc5ZlH2C4ER02NmQ6icfiqpzVQdVUnOmdywGjjjSYSg=";
  };

  nativeBuildInputs = [
    SDL
    pkg-config
    smpeg
  ];

  buildInputs = [
    SDL
    SDL_image
    SDL_mixer
    SDL_ttf
    freetype
    libjpeg
    libogg
    libpng
    libvorbis
    smpeg
  ];

  configureFlags = [ "--no-werror" ];

  strictDeps = true;

  preBuild = ''
    sed -i 's/.dll//g' Makefile
  '';

  meta = {
    homepage = "http://github.com/museoa/onscripter-en";
    description = "Japanese visual novel scripting engine";
    license = lib.licenses.gpl2Plus;
    mainProgram = "onscripter-en";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
    broken = stdenv.isDarwin;
  };
})
