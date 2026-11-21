{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL,
  SDL_image,
  SDL_mixer,
  SDL_net,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gav";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "ctrl-z-bg";
    repo = "gav";
    tag = "v${finalAttrs.version}";
    hash = "sha256-79V5ILPndYu1xZ6YTUU/HtenE7pj+Y+hhVnDF2VStM4=";
  };

  prePatch = ''
    mkdir -p $out/bin
    sed -e "s@/usr@$out@" -i Makefile
    sed -e "s@/usr@$out@" -i Theme.h
  '';

  patches = [
    # Fix crash at startup: theme sound paths in the Nix store overflow a 100-byte buffer
    # https://github.com/ctrl-z-bg/gav/pull/1
    ./fix-sound-path-overflow.patch
  ];

  buildInputs = [
    SDL
    SDL_image
    SDL_mixer
    SDL_net
  ];

  meta = {
    description = "Remake of AV Arcade Volleyball";
    mainProgram = "gav";
    homepage = "https://github.com/ctrl-z-bg/gav";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ iedame ];
    platforms = lib.platforms.linux;
  };
})
