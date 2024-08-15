{ alsa-lib
, boost
, catch2_3
, cmake
, cryptopp
, cpp-jwt
, doxygen
, enet
, fetchzip
, fetchurl
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

  compat-list = fetchurl {
    name = "lime3ds-compat-list";
    url = "https://raw.githubusercontent.com/Lime3DS/compatibility-list/fa9d49d22e698df2f238e53f2b34acda08b947f6/compatibility_list.json";
    hash = "sha256-dNZuU8uFXJ5gw/rmtF6bAjtrvVBXP8aUNXVdBY1dT34=";
  };
in stdenv.mkDerivation (finalAttrs: {
  pname = "lime3ds";
  version = "2116";

  src = fetchzip {
    url = "https://github.com/Lime3DS/Lime3DS/releases/download/${finalAttrs.version}/lime3ds-unified-source-${finalAttrs.version}.tar.xz";
    hash = "sha256-ff4An+ZdxlY4H90Yep4lpKROOMEkDijb3dVFIgSPvWQ=";
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

    # Prep compatibilitylist
    rm ./dist/compatibility_list/compatibility_list.json
    ln -s ${compat-list} ./dist/compatibility_list/compatibility_list.json

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
    for binfile in lime3ds-gui lime3ds-cli lime3ds-room
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
    (cmakeBool "CITRA_USE_PRECOMPILED_HEADERS" false)
    (cmakeBool "ENABLE_QT_TRANSLATION" enableQtTranslations)
    (cmakeBool "USE_SYSTEM_LIBS" true)
    (cmakeBool "DISABLE_SYSTEM_DYNARMIC" true)
    (cmakeBool "DISABLE_SYSTEM_GLSLANG" true)
    (cmakeBool "DISABLE_SYSTEM_LODEPNG" true)
    (cmakeBool "DISABLE_SYSTEM_VMA" true)
    (cmakeBool "DISABLE_SYSTEM_XBYAK" true)
    (cmakeBool "CITRA_ENABLE_COMPATIBILITY_REPORTING" true)
    (cmakeBool "ENABLE_COMPATIBILITY_LIST_DOWNLOAD" false)
    (cmakeBool "ENABLE_SDL2_FRONTEND" enableSdl2Frontend)
    (cmakeBool "ENABLE_CUBEB" enableCubeb)
    (cmakeBool "USE_DISCORD_PRESENCE" useDiscordRichPresence)
  ];

  meta = {
    description = "A Nintendo 3DS emulator based on Citra";
    homepage = "https://github.com/Lime3DS/Lime3DS";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ arthsmn ];
    mainProgram = if enableQt then "lime3ds-gui" else "lime3ds-cli";
    platforms = lib.platforms.linux;
  };
})
