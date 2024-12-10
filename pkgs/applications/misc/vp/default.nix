{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  SDL,
  SDL_image,
}:

stdenv.mkDerivation rec {
  pname = "vp";
  version = "1.8";

  src = fetchFromGitHub {
    owner = "erikg";
    repo = "vp";
    rev = "v${version}";
    sha256 = "08q6xrxsyj6vj0sz59nix9isqz84gw3x9hym63lz6v8fpacvykdq";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    SDL
    SDL_image
  ];

  env.NIX_CFLAGS_COMPILE = "-I${SDL}/include/SDL -I${SDL_image}/include/SDL";

  meta = with lib; {
    homepage = "https://brlcad.org/~erik/";
    description = "SDL based picture viewer/slideshow";
    platforms = platforms.unix;
    license = licenses.gpl3;
    maintainers = [ maintainers.vrthra ];
    mainProgram = "vp";
  };
}
