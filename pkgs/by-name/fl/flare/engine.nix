{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    ./desktop.patch

    # cmake-4 compatibility patch
    (fetchpatch {
      name = "cmake-4.patch";
      url = "https://github.com/flareteam/flare-engine/commit/9500379f886484382bba2f893faf49865de9f2c0.patch";
      hash = "sha256-nUn54ZBEvvFkIhzE/UBbsvF0rFC9JAeQACTAPtsc1VI=";
    })
  ];

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
