{
  lib,
  stdenv,
  fetchurl,
  SDL,
  SDL_image,
  SDL_ttf,
  installShellFiles,
  fontconfig,
  libpng,
  libtiff,
  lua5,
  pkg-config,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "grafx2";
  version = "2.8.3091";

  outputs = [
    "out"
    "man"
  ];

  src = fetchurl {
    name = "grafx2-${finalAttrs.version}.tar.gz";
    url = "https://pulkomandy.tk/projects/GrafX2/downloads/65";
    hash = "sha256-KdY7GUhQp/Q7t/ktLPGxI66ZHy2gDAffn2yB5pmcJCM=";
  };

  postPatch = ''
    substituteInPlace misc/unix/grafx2.desktop \
      --replace "Exec=grafx2" "Exec=grafx2-sdl"
  '';

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

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

  strictDeps = false; # Why??

  makeFlags = [ "-C src" ];
  installFlags = [
    "-C src"
    "PREFIX=$(out)"
  ];

  postInstall = ''
    installManPage misc/unix/grafx2.1
  '';

  meta = {
    homepage = "http://grafx2.eu/";
    description = "Ultimate 256-color painting program";
    longDescription = ''
      GrafX2 is a bitmap paint program inspired by the Amiga programs ​Deluxe
      Paint and Brilliance. Specialized in 256-color drawing, it includes a very
      large number of tools and effects that make it particularly suitable for
      pixel art, game graphics, and generally any detailed graphics painted with
      a mouse.

      The program is mostly developed on Haiku, Linux and Windows, but is also
      portable on many other platforms.
    '';
    license = with lib.licenses; [ gpl2Plus ];
    mainProgram = "grafx2-sdl";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
