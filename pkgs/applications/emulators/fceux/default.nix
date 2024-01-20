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
  version = "2.6.6";

  src = fetchFromGitHub {
    owner = "TASEmulators";
    repo = "fceux";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Wp23oLapMqQtL2DCkm2xX1vodtEr/XNSOErf3nrFRQs=";
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
    description = "A Nintendo Entertainment System (NES) Emulator";
    changelog = "https://github.com/TASEmulators/blob/fceux/${finalAttrs.src.rev}/changelog.txt";
    license = with lib.licenses; [ gpl2Plus ];
    maintainers = with lib.maintainers; [ AndersonTorres sbruder ];
    platforms = lib.platforms.linux;
  };
})
