{
  lib,
  stdenv,
  fetchurl,
  SDL,
  SDL_mixer,
  zlib,
}:

stdenv.mkDerivation {
  pname = "cuyo";
  version = "2.1.0";

  src = fetchurl {
    url = "https://download.savannah.gnu.org/releases/cuyo/cuyo-2.1.0.tar.gz";
    sha256 = "17yqv924x7yvwix7yz9jdhgyar8lzdhqvmpvv0any8rdkajhj23c";
  };

  buildInputs = [
    SDL
    SDL_mixer
    zlib
  ];

  meta = {
    homepage = "http://karimmi.de/cuyo";
    description = "Stacking blocks game, with different rules for each level";
    mainProgram = "cuyo";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };

}
