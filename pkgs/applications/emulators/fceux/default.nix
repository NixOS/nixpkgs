{ lib
, stdenv
, fetchFromGitHub
, SDL2
, cmake
, lua
, minizip
, pkg-config
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

  meta = with lib; {
    homepage = "http://www.fceux.com/";
    description = "A Nintendo Entertainment System (NES) Emulator";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sbruder scubed2 ];
    platforms = platforms.linux;
  };
})
