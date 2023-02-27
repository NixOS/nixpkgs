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
  version = "2.6.4";

  src = fetchFromGitHub {
    owner = "TASEmulators";
    repo = "fceux";
    rev = "fceux-${finalAttrs.version}";
    hash = "sha256-Q6r/iBlmi0z40+U6OLZCahS0io4IBBGZMP1mJH7szRM=";
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
