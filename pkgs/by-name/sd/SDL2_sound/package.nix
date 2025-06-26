{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  SDL2,
}:

stdenv.mkDerivation rec {
  pname = "SDL2_sound";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "icculus";
    repo = "SDL_sound";
    rev = "v${version}";
    hash = "sha256-5t2ELm8d8IX+cIJqGl/8sffwXGj5Cm0kZI6+bmjvvPg=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DSDLSOUND_DECODER_MIDI=1" ];

  buildInputs = [ SDL2 ];

  meta = with lib; {
    description = "SDL2 sound library";
    mainProgram = "playsound";
    platforms = platforms.unix;
    license = licenses.zlib;
    teams = [ lib.teams.sdl ];
    homepage = "https://www.icculus.org/SDL_sound/";
  };
}
