{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, ncurses
, enableSdl2 ? true
, SDL2
, SDL2_image
, SDL2_sound
, SDL2_mixer
, SDL2_ttf
}:

stdenv.mkDerivation rec {
  pname = "narsil";
  version = "1.3.0-49-gc042b573a";

  src = fetchFromGitHub {
    owner = "NickMcConnell";
    repo = "NarSil";
    rev = version;
    hash = "sha256-lVGG4mppsnDmjMFO8YWsLEJEhI3T+QO3z/pCebe0Ai8=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ncurses ]
    ++ lib.optionals enableSdl2 [
    SDL2
    SDL2_image
    SDL2_sound
    SDL2_mixer
    SDL2_ttf
  ];

  enableParallelBuilding = true;

  configureFlags = lib.optional enableSdl2 "--enable-sdl2";

  installFlags = [ "bindir=$(out)/bin" ];

  meta = with lib; {
    homepage = "https://github.com/NickMcConnell/NarSil/";
    description = "Unofficial rewrite of Sil, a roguelike influenced by Angband";
    mainProgram = "narsil";
    longDescription = ''
      NarSil attempts to be an almost-faithful recreation of Sil 1.3.0,
      but based on the codebase of modern Angband.
    '';
    maintainers = [ maintainers.nanotwerp ];
    license = licenses.gpl2;
  };
}
