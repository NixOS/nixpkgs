{ lib
, stdenv
, fetchFromGitHub
, glib
, SDL2
, libGL
, pkg-config
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "sopwith";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "fragglet";
    repo = "sdl-sopwith";
    rev = "refs/tags/sdl-sopwith-${version}";
    hash = "sha256-7/xTg41NYxzeGNyt/ClbM/uHMTAE87wn6vc9Ai6P+30=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    glib
    SDL2
    libGL
  ];

  meta = with lib; {
    homepage = "https://github.com/fragglet/sdl-sopwith";
    description = "Classic biplane shoot ‘em-up game.";
    license = licenses.gpl2Plus;
    mainProgram = "sopwith";
    maintainers = with maintainers; [ evilbulgarian ];
    platforms = platforms.unix;
  };
}
