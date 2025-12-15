{
  lib,
  stdenv,
  fetchurl,
  SDL,
  SDL_image,
  SDL_mixer,
  SDL_net,
}:

stdenv.mkDerivation rec {
  pname = "njam";
  version = "1.25";

  src = fetchurl {
    url = "mirror://sourceforge/njam/njam-${version}-src.tar.gz";
    sha256 = "0ysvqw017xkvddj957pdfmbmji7qi20nyr7f0zxvcvm6c7d3cc7s";
  };

  preBuild = ''
    rm src/*.o
  '';

  buildInputs = [
    SDL
    SDL_image
    SDL_mixer
    SDL_net
  ];

  hardeningDisable = [ "format" ];

  patches = [ ./logfile.patch ];

  meta = {
    homepage = "https://trackballs.sourceforge.net/";
    description = "Cross-platform pacman-like game";
    mainProgram = "njam";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
