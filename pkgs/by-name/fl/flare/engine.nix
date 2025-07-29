{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  SDL2_ttf,
}:

stdenv.mkDerivation rec {
  pname = "flare-engine";
  version = "1.14";

  src = fetchFromGitHub {
    owner = "flareteam";
    repo = "flare-engine";
    tag = "v${version}";
    hash = "sha256-DIzfTqwZJ8NAPB/TWzvPjepHb7hIbIr+Kk+doXJmpLc=";
  };

  patches = [ ./desktop.patch ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
  ];

  meta = {
    description = "Free/Libre Action Roleplaying Engine";
    homepage = "https://github.com/flareteam/flare-engine";
    maintainers = with lib.maintainers; [
      aanderse
      McSinyx
    ];
    license = [ lib.licenses.gpl3Plus ];
    platforms = lib.platforms.unix;
  };
}
