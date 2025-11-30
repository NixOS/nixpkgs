{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  curl,
  openssl,
  SDL2,
  alsa-lib,
  libGL,
  libGLU,
  libX11,
  libXi,
  libXcursor,
  lua,
  makeDesktopItem,
  copyDesktopItems,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "skyemu";
  version = "4";

  src = fetchFromGitHub {
    owner = "skylersaleh";
    repo = "SkyEmu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rfXHOff+PG5iA19iwEij4c5aFD9XrSF1GQhIBhWzKgg=";
  };

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    ninja
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    curl
    libGL
    libGLU
    openssl
    SDL2
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libX11
    libXi
    libXcursor
    lua
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_CURL" true)
    (lib.cmakeBool "USE_SYSTEM_OPENSSL" true)
    (lib.cmakeBool "USE_SYSTEM_SDL2" true)
    (lib.cmakeBool "ENABLE_RETRO_ACHIEVEMENTS" true)
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'set(CMAKE_OSX_ARCHITECTURES' '#set(CMAKE_OSX_ARCHITECTURES'
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "skyemu";
      exec = "SkyEmu";
      icon = "skyemu";
      comment = "GameBoy, GameBoy Color, GameBoy Advance, and DS emulator";
      desktopName = "SkyEmu";
      categories = [
        "Game"
        "Emulator"
      ];
    })
  ];

  postInstall = ''
    install -Dm644 $src/src/resources/icons/icon.png $out/share/pixmaps/skyemu.png
  '';

  meta = {
    description = "Low level GameBoy, GameBoy Color, Game Boy Advance, and DS emulator";
    homepage = "https://github.com/skylersaleh/SkyEmu";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ liberodark ];
    mainProgram = "SkyEmu";
    platforms = with lib.platforms; unix ++ windows;
  };
})
