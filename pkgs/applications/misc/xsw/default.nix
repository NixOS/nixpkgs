{ stdenv, lib, fetchFromGitHub, pkgconfig, SDL, SDL_image, SDL_ttf, SDL_gfx, flex, bison }:

let
  makeSDLFlags = map (p: "-I${lib.getDev p}/include/SDL");

in stdenv.mkDerivation rec {
  name = "xsw-${version}";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "andrenho";
    repo = "xsw";
    rev = version;
    sha256 = "092vp61ngd2vscsvyisi7dv6qrk5m1i81gg19hyfl5qvjq5p0p8g";
  };

  nativeBuildInputs = [ SDL SDL_image SDL_ttf SDL_gfx flex bison ];

  buildInputs = [ pkgconfig ];

  NIX_CFLAGS_COMPILE = makeSDLFlags [ SDL SDL_image SDL_ttf SDL_gfx ];

  patches = [
    ./parse.patch # Fixes compilation error by avoiding redundant definitions.
  ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "A slide show presentation tool";

    platforms = platforms.unix;
    license  = licenses.gpl3;
    maintainers = [ maintainers.vrthra ];
  };
}
