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

stdenv.mkDerivation (finalAttrs: {
  pname = "sopwith";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "fragglet";
    repo = "sdl-sopwith";
    tag = "sdl-sopwith-${finalAttrs.version}";
    hash = "sha256-pSxNW1WVe3Zq8m+cRJr1zeDx+8SUuav+lvM4PTYpRxo=";
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

  # Keep high scores per-user instead of installing a system-wide file into /var/games
  configureFlags = [ "--with-hiscores-path=" ];

  meta = {
    homepage = "https://github.com/fragglet/sdl-sopwith";
    description = "Classic biplane shoot ‘em-up game";
    license = lib.licenses.gpl2Plus;
    mainProgram = "sopwith";
    maintainers = with lib.maintainers; [ evilbulgarian ];
    platforms = lib.platforms.unix;
  };
})
