{
  lib,
  stdenv,
  fetchurl,
  fftwSinglePrec,
  freetype,
  SDL,
  SDL_ttf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quantumminigolf";
  version = "1.1.1";

  src = fetchurl {
    url = "mirror://sourceforge/project/quantumminigolf/quantumminigolf/${finalAttrs.version}/quantumminigolf-${finalAttrs.version}.src.tar.gz";
    sha256 = "sha256-Y3LUGk6pAuNGVOYkc0WYDbgJFtwJJn+aLRHmCKY7W5k=";
  };

  buildInputs = [
    fftwSinglePrec
    freetype
    SDL
    SDL_ttf
  ];

  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${lib.getDev SDL}/include/SDL -I${SDL_ttf}/include/SDL"

    sed -re 's@"(gfx|fonts|tracks)/@"'"$out"'/share/quantumminigolf/\1/@g' -i *.cpp
  '';

  installPhase = ''
    mkdir -p "$out"/{share/doc,share/quantumminigolf,bin}
    cp README THANKS LICENSE "$out/share/doc"
    cp -r fonts gfx tracks "$out/share/quantumminigolf"
    cp quantumminigolf "$out/bin"
  '';

  meta = {
    description = "Quantum mechanics-based minigolf-like game";
    mainProgram = "quantumminigolf";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.linux;
    # never built on aarch64-linux since first introduction in nixpkgs
    broken = stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64;
  };
})
