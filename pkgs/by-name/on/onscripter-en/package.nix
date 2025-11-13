{
  SDL,
  SDL_image,
  SDL_mixer,
  SDL_ttf,
  fetchFromGitHub,
  freetype,
  lib,
  libjpeg,
  libogg,
  libpng,
  libvorbis,
  pkg-config,
  smpeg,
  stdenv,
  libx11,
}:

stdenv.mkDerivation {
  pname = "onscripter-en";
  version = "2025-06-08";

  src = fetchFromGitHub {
    owner = "Galladite27";
    repo = "ONScripter-EN";
    tag = "2025-06-08";
    hash = "sha256-yP4ZzNvh2jUZ5NAWYFhgxxfZ+3SOMj2x/rQjw66yr8s=";
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
    libpng
    libogg
    libvorbis
    libx11
  ];

  strictDeps = true;

  meta = {
    homepage = "https://github.com/Galladite27/ONScripter-EN";
    description = "Visual novel scripting engine, with support for English and Japanese.";
    license = lib.licenses.gpl2Plus;
    mainProgram = "onscripter-en";
    maintainers = with lib.maintainers; [
      Freikugel
    ];
    platforms = lib.platforms.linux;
  };
}
