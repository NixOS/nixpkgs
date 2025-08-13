{
  boost,
  catch2_3,
  cmake,
  cryptopp,
  cpp-jwt,
  doxygen,
  dynarmic,
  enet,
  fetchpatch,
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
  robin-map,
  SDL2,
  spirv-tools,
  soundtouch,
  stdenv,
  vulkan-headers,
  xbyak,
  xorg,
  zstd,
  enableQtTranslations ? true,
  qt6,
  enableCubeb ? true,
  cubeb,
  useDiscordRichPresence ? true,
  rapidjson,
  enableSSE42 ? true, # Disable if your hardware doesn't support SSE 4.2 (mainly CPUs before 2011)
  gamemode,
  enableGamemode ? lib.meta.availableOn stdenv.hostPlatform gamemode,
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
  version = "2122.1";

  src = fetchzip {
    url = "https://github.com/azahar-emu/azahar/releases/download/${finalAttrs.version}/azahar-unified-source-${finalAttrs.version}.tar.xz";
    hash = "sha256-RQ8dgD09cWyVWGSLzHz1oJOKia1OKr2jHqYwKaVGfxE=";
  };

  nativeBuildInputs = [
    cmake
    doxygen
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
    spirv-tools
    vulkan-headers
    xbyak
    zstd
  ]
  ++ optionals enableQtTranslations [ qt6.qttools ]
  ++ optionals enableCubeb [ cubeb ]
  ++ optionals useDiscordRichPresence [ rapidjson ]
  ++ optionals stdenv.hostPlatform.isLinux [
    pipewire
    qt6.qtwayland
    xorg.libX11
    xorg.libXext
  ]
  ++ optionals stdenv.hostPlatform.isDarwin [
    moltenvk
  ];

  patches = [
    # Fix boost errors
    (fetchpatch {
      url = "https://raw.githubusercontent.com/Tatsh/tatsh-overlay/fa2f92b888f8c0aab70414ca560b823ffb33b122/games-emulation/lime3ds/files/lime3ds-0002-boost-fix.patch";
      hash = "sha256-XJogqvQE7I5lVHtvQja0woVlO40blhFOqnoYftIQwJs=";
    })

    # Fix boost 1.87
    (fetchpatch {
      url = "https://raw.githubusercontent.com/Tatsh/tatsh-overlay/5c4497d9b67fa6f2fa327b2f2ce4cb5be8c9f2f7/games-emulation/lime3ds/files/lime3ds-0003-boost-1.87-fixes.patch";
      hash = "sha256-mwfI7fTx9aWF/EjMW3bxoz++A+6ONbNA70tT5nkhDUU=";
    })

    # https://github.com/azahar-emu/azahar/pull/1165
    ./update-cmake-lists.patch
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
    (cmakeBool "ENABLE_QT_TRANSLATION" enableQtTranslations)
    (cmakeBool "ENABLE_CUBEB" enableCubeb)
    (cmakeBool "USE_DISCORD_PRESENCE" useDiscordRichPresence)
    (cmakeBool "ENABLE_SSE42" enableSSE42)
  ];

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
