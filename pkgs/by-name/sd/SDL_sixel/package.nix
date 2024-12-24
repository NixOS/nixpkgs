{
  lib,
  fetchFromGitHub,
  libsixel,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "SDL_sixel";
  version = "0-unstable-2016-02-06";

  src = fetchFromGitHub {
    owner = "saitoha";
    repo = "SDL1.2-SIXEL";
    rev = "ab3fccac6e34260a617be511bd8c2b2beae41952";
    hash = "sha256-l5eLnfV2ozAlfiTo2pr0a2BXv/pwfpX4pycw1Z7doj4=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libsixel ];

  configureFlags = [
    (lib.enableFeature true "video-sixel")
  ];

  strictDeps = true;

  meta = {
    homepage = "https://github.com/saitoha/SDL1.2-SIXEL";
    description = "SDL 1.2 patched with libsixel support";
    license = lib.licenses.lgpl21;
    mainProgram = "sdl-config";
    maintainers = lib.teams.sdl.members ++ (with lib.maintainers; [ ]);
    platforms = lib.platforms.linux;
  };
}
