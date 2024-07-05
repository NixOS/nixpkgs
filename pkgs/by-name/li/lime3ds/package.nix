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
  compat-list = fetchurl {
    name = "lime3ds-compat-list";
    url = "https://raw.githubusercontent.com/Lime3DS/compatibility-list/b0c8b6b80d716db6b957ba103c7a9e17ead24d55/compatibility_list.json";
    hash = "sha256-2wNqtorcQo3o09tisikW+cj6cVLLQEiJ1Zcai5ptGEU=";
  };
in stdenv.mkDerivation (finalAttrs: {
  pname = "lime3ds";
  version = "2114";

  src = fetchzip {
    url = "https://github.com/Lime3DS/Lime3DS/releases/download/${finalAttrs.version}/lime3ds-unified-source-${finalAttrs.version}.tar.xz";
    hash = "sha256-PGrKh10dBFAWn37G8m/2/ymqcgtAuxB+5Xib0FI+IMQ=";
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
  ] ++ lib.optionals enableQt (with kdePackages; [
    qtbase
    qtmultimedia
    qttools
    qtwayland
  ]) ++ lib.optionals enableQtTranslations [kdePackages.qttools]
  ++ lib.optionals enableCubeb [cubeb]
  ++ lib.optional useDiscordRichPresence rapidjson;

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
      --replace-fail "libgamemode.so.0" "${lib.getLib gamemode}/lib/libgamemode.so.0"
  '';

  postInstall = let
    libs = lib.makeLibraryPath [ vulkan-loader ];
  in lib.optionalString enableSdl2Frontend ''
    for binfile in lime3ds-gui lime3ds-cli lime3ds-room
    do
      wrapProgram "$out/bin/$binfile" \
        --prefix LD_LIBRARY_PATH : ${libs}
      '' + lib.optionalString enableQt ''
      qtWrapperArgs+=(
        --prefix LD_LIBRARY_PATH : ${libs}
      )
    done
  '';

  cmakeFlags = with lib; [
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

  meta = with lib; {
    description = "A Nintendo 3DS emulator based on Citra";
    homepage = "https://github.com/Lime3DS/Lime3DS";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ arthsmn ];
    mainProgram = if enableQt then "lime3ds-gui" else "lime3ds-cli";
    platforms = platforms.linux;
  };
})
