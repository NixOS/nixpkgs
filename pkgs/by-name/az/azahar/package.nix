{
  boost,
  catch2_3,
  cmake,
  cryptopp,
  cpp-jwt,
  doxygen,
  dynarmic,
  enet,
  fetchzip,
  fmt,
  ffmpeg_6-headless,
  glslang,
  httplib,
  inih,
  lib,
  libGL,
  libunwind,
  libusb1,
  moltenvk,
  nlohmann_json,
  openal,
  openssl,
  pipewire,
  pkg-config,
  portaudio,
  python3,
  robin-map,
  SDL2,
  soundtouch,
  stdenv,
  vulkan-headers,
  xbyak,
  xorg,
  enableQtTranslations ? true,
  qt6,
  enableCubeb ? true,
  cubeb,
  useDiscordRichPresence ? true,
  rapidjson,
  enableSSE42 ? true, # Disable if your hardware doesn't support SSE 4.2 (mainly CPUs before 2011)
  gamemode,
  enableGamemode ? lib.meta.availableOn stdenv.hostPlatform gamemode,
  nix-update-script,
  darwinMinVersionHook,
  apple-sdk_12,
}:
let
  inherit (lib)
    optionals
    optionalString
    cmakeBool
    getLib
    ;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "azahar";
  version = "2123.1";

  src = fetchzip {
    url = "https://github.com/azahar-emu/azahar/releases/download/${finalAttrs.version}/azahar-unified-source-${finalAttrs.version}.tar.xz";
    hash = "sha256-Rwq1fkRCzOna04d71w175iSQnH26z7gQfwfIZhFW/90=";
  };

  patches = [
    # https://github.com/azahar-emu/azahar/pull/1305
    ./fix-zstd-seekable-include.patch
  ];

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    doxygen
    python3
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    boost
    catch2_3
    cryptopp
    cpp-jwt
    dynarmic
    enet
    fmt
    ffmpeg_6-headless
    glslang
    httplib
    inih
    libGL
    libunwind
    libusb1
    nlohmann_json
    openal
    openssl
    portaudio
    robin-map
    qt6.qtbase
    qt6.qtmultimedia
    qt6.qttools
    soundtouch
    SDL2
    vulkan-headers
    xbyak

    # https://github.com/azahar-emu/azahar/pull/1281
    # spirv-tools

    # Azahar uses zstd_seekable which is not currently packaged in nixpkgs
    # zstd
  ]
  ++ optionals enableQtTranslations [ qt6.qttools ]
  ++ optionals enableCubeb [ cubeb ]
  ++ optionals useDiscordRichPresence [ rapidjson ]
  ++ optionals stdenv.hostPlatform.isLinux [
    pipewire
    qt6.qtwayland
    xorg.libX11
    xorg.libxcb
    xorg.libXext
  ]
  ++ optionals stdenv.hostPlatform.isDarwin [
    moltenvk

    # error: 'lowPowerModeEnabled' is unavailable: not available on macOS
    apple-sdk_12
    (darwinMinVersionHook "12.0")
  ];

  postPatch = ''
    # We already know the submodules are present
    substituteInPlace CMakeLists.txt \
      --replace-fail "check_submodules_present()" ""
  ''
  # Add gamemode
  + optionalString enableGamemode ''
    substituteInPlace externals/gamemode/include/gamemode_client.h \
      --replace-fail "libgamemode.so.0" "${getLib gamemode}/lib/libgamemode.so.0"
  '';

  cmakeFlags = [
    (cmakeBool "USE_SYSTEM_LIBS" true)
    (cmakeBool "DISABLE_SYSTEM_LODEPNG" true)
    (cmakeBool "DISABLE_SYSTEM_VMA" true)
    (cmakeBool "DISABLE_SYSTEM_ZSTD" true)
    (cmakeBool "DISABLE_SYSTEM_SPIRV_HEADERS" true)
    (cmakeBool "ENABLE_QT_TRANSLATION" enableQtTranslations)
    (cmakeBool "ENABLE_CUBEB" enableCubeb)
    (cmakeBool "USE_DISCORD_PRESENCE" useDiscordRichPresence)
    (cmakeBool "ENABLE_SSE42" enableSSE42)
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source 3DS emulator project based on Citra";
    homepage = "https://github.com/azahar-emu/azahar";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      arthsmn
      marcin-serwin
    ];
    mainProgram = "azahar";
    platforms = with lib.platforms; linux ++ darwin;
  };
})
