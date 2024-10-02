{ alsa-lib
, boost
, catch2_3
, cmake
, cryptopp
, cpp-jwt
, doxygen
, enet
, fetchzip
, fmt
, ffmpeg-headless
, gamemode
, httplib
, inih
, lib
, libGL
, libjack2
, libpulseaudio
, libunwind
, libusb1
, nlohmann_json
, openal
, openssl
, pipewire
, pkg-config
, portaudio
, sndio
, spirv-tools
, soundtouch
, stdenv
, vulkan-headers
, vulkan-loader
, xorg
, zstd
, enableSdl2Frontend ? true , SDL2
, enableQt ? true , kdePackages
, enableQtTranslations ? enableQt
, enableCubeb ? true , cubeb
, useDiscordRichPresence ? false , rapidjson
}: let
  inherit (lib) optional optionals cmakeBool optionalString getLib makeLibraryPath;
in stdenv.mkDerivation (finalAttrs: {
  pname = "lime3ds";
  version = "2118.2";

  src = fetchzip {
    url = "https://github.com/Lime3DS/Lime3DS/releases/download/${finalAttrs.version}/lime3ds-unified-source-${finalAttrs.version}.tar.xz";
    hash = "sha256-DovVkk5QolOizV3mfxtMNMeIJWYs3xAu96icrTcQN68=";
  };

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
  ] ++ lib.optionals enableQt [kdePackages.wrapQtAppsHook];

  buildInputs = [
    alsa-lib
    boost
    catch2_3
    cryptopp
    cpp-jwt
    enet
    fmt
    ffmpeg-headless
    httplib
    inih
    libGL
    libjack2
    libpulseaudio
    libunwind
    libusb1
    nlohmann_json
    openal
    openssl
    pipewire
    portaudio
    SDL2
    soundtouch
    sndio
    spirv-tools
    vulkan-headers
    xorg.libX11
    xorg.libXext
    zstd
  ] ++ optionals enableQt (with kdePackages; [
    qtbase
    qtmultimedia
    qttools
    qtwayland
  ]) ++ optionals enableQtTranslations [kdePackages.qttools]
  ++ optionals enableCubeb [cubeb]
  ++ optional useDiscordRichPresence rapidjson;

  postPatch = ''
    # Fix file not found when looking in var/empty instead of opt
    mkdir externals/dynarmic/src/dynarmic/ir/var
    ln -s ../opt externals/dynarmic/src/dynarmic/ir/var/empty

    # We already know the submodules are present
    substituteInPlace CMakeLists.txt \
      --replace-fail "check_submodules_present()" ""

    # Add gamemode
    substituteInPlace externals/gamemode/include/gamemode_client.h \
      --replace-fail "libgamemode.so.0" "${getLib gamemode}/lib/libgamemode.so.0"
  '';

  postInstall = let
    libs = makeLibraryPath [ vulkan-loader ];
  in optionalString enableSdl2Frontend ''
    for binfile in lime3ds lime3ds-room
    do
      wrapProgram "$out/bin/$binfile" \
        --prefix LD_LIBRARY_PATH : ${libs}
      '' + optionalString enableQt ''
      qtWrapperArgs+=(
        --prefix LD_LIBRARY_PATH : ${libs}
      )
    done
  '';

  cmakeFlags = [
    (cmakeBool "LIME3DS_USE_PRECOMPILED_HEADERS" false)
    (cmakeBool "USE_SYSTEM_LIBS" true)
    (cmakeBool "DISABLE_SYSTEM_DYNARMIC" true)
    (cmakeBool "DISABLE_SYSTEM_GLSLANG" true)
    (cmakeBool "DISABLE_SYSTEM_LODEPNG" true)
    (cmakeBool "DISABLE_SYSTEM_VMA" true)
    (cmakeBool "DISABLE_SYSTEM_XBYAK" true)
    (cmakeBool "ENABLE_QT" enableQt)
    (cmakeBool "ENABLE_SDL2_FRONTEND" enableSdl2Frontend)
    (cmakeBool "ENABLE_CUBEB" enableCubeb)
    (cmakeBool "USE_DISCORD_PRESENCE" useDiscordRichPresence)
  ] ++ optionals enableQt [
    (cmakeBool "ENABLE_QT_TRANSLATION" enableQtTranslations)
  ];

  meta = {
    description = "A Nintendo 3DS emulator based on Citra";
    homepage = "https://github.com/Lime3DS/Lime3DS";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ arthsmn ];
    mainProgram = "lime3ds";
    platforms = lib.platforms.linux;
  };
})
