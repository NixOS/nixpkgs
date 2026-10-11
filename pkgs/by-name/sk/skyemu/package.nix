{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  alsa-lib,
  cmake,
  copyDesktopItems,
  curl,
  libGL,
  libx11,
  libxcursor,
  libxi,
  makeDesktopItem,
  ninja,
  nix-update-script,
  openssl,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "skyemu";
  version = "5";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "skylersaleh";
    repo = "SkyEmu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-x8WWJpP16CrdFlN67HEap6m9yWdFrK76qumLGub5ODE=";
  };

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    ninja
    pkg-config
  ];

  buildInputs = [
    curl
    openssl
    SDL2
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    libGL
    libx11
    libxcursor
    libxi
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_CURL" true)
    (lib.cmakeBool "USE_SYSTEM_OPENSSL" true)
    (lib.cmakeBool "USE_SYSTEM_SDL2" true)
    (lib.cmakeBool "ENABLE_RETRO_ACHIEVEMENTS" true)
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeFeature "CMAKE_OSX_ARCHITECTURES" stdenv.hostPlatform.darwinArch)
  ];

  postInstall = ''
    install -Dm444 ../src/resources/icons/icon.svg $out/share/icons/hicolor/scalable/apps/skyemu.svg
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Low level GameBoy, GameBoy Color, Game Boy Advance, and DS emulator";
    homepage = "https://github.com/skylersaleh/SkyEmu";
    changelog = "https://github.com/skylersaleh/SkyEmu/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ liberodark ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "SkyEmu";
  };
})
