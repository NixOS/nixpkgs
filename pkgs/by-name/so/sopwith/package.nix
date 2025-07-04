{
  lib,
  stdenv,
  fetchFromGitHub,
  glib,
  SDL2,
  libGL,
  pkg-config,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "sopwith";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "fragglet";
    repo = "sdl-sopwith";
    tag = "sdl-sopwith-${version}";
    hash = "sha256-s7npLid3GYZArQmctSwOu8zeC+mSfTiiiOaOEa9dcrg=";
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
    description = "Classic biplane shoot ‘em-up game";
    license = licenses.gpl2Plus;
    mainProgram = "sopwith";
    maintainers = with maintainers; [ evilbulgarian ];
    platforms = platforms.unix;
  };
}
