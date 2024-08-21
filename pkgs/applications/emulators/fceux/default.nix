{ lib
, SDL2
, cmake
, fetchFromGitHub
, lua
, minizip
, pkg-config
, stdenv
, wrapQtAppsHook
, x264
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fceux";
  version = "2.6.6-unstable-2024-01-19";

  src = fetchFromGitHub {
    owner = "TASEmulators";
    repo = "fceux";
    rev = "2fce5ffe745bb89be471e450d9cd6284cd5614d9";
    hash = "sha256-5uUTw7ZkmBrGuntSQFNAp1Xz69ANmmIxNGd0/enPoW8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    SDL2
    lua
    minizip
    x264
  ];

  meta = {
    homepage = "http://www.fceux.com/";
    description = "Nintendo Entertainment System (NES) Emulator";
    mainProgram = "fceux";
    changelog = "https://github.com/TASEmulators/blob/fceux/${finalAttrs.src.rev}/changelog.txt";
    license = with lib.licenses; [ gpl2Plus ];
    maintainers = with lib.maintainers; [ AndersonTorres sbruder ];
    platforms = lib.platforms.linux;
  };
})
