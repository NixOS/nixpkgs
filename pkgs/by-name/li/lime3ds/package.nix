{
  alsa-lib,
  boost,
  catch2_3,
  cmake,
  cryptopp,
  cpp-jwt,
  doxygen,
  enet,
  fetchpatch,
  fetchzip,
  fmt,
  ffmpeg_6-headless,
  gamemode,
  httplib,
  inih,
  lib,
  libGL,
  libjack2,
  libpulseaudio,
  libunwind,
  libusb1,
  nlohmann_json,
  openal,
  openssl,
  pipewire,
  pkg-config,
  portaudio,
  sndio,
  spirv-tools,
  soundtouch,
  stdenv,
  vulkan-headers,
  vulkan-loader,
  xorg,
  zstd,
  enableSdl2Frontend ? true,
  SDL2,
  enableQt ? true,
  kdePackages,
  enableQtTranslations ? enableQt,
  enableCubeb ? true,
  cubeb,
  useDiscordRichPresence ? false,
  rapidjson,
}:
let
  inherit (lib)
    optional
    optionals
    cmakeBool
    optionalString
    getLib
    makeLibraryPath
    ;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lime3ds";
  version = "2119.1";

  src = fetchzip {
    url = "https://github.com/Lime3DS/Lime3ds-archive/releases/download/${finalAttrs.version}/lime3ds-unified-source-${finalAttrs.version}.tar.xz";
    hash = "sha256-37KFGCVyc4QW+D00CzN1+lpNYZxCWRkflt7rkIFcdM8=";
  };

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
  ] ++ lib.optionals enableQt [ kdePackages.wrapQtAppsHook ];

  buildInputs =
    [
      alsa-lib
      boost
      catch2_3
      cryptopp
      cpp-jwt
      enet
      fmt
      ffmpeg_6-headless
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
      soundtouch
      sndio
      spirv-tools
      vulkan-headers
      xorg.libX11
      xorg.libXext
      zstd
    ]
    ++ optionals enableQt (
      with kdePackages;
      [
        qtbase
        qtmultimedia
        qttools
        qtwayland
      ]
    )
    ++ optionals enableSdl2Frontend [ SDL2 ]
    ++ optionals enableQtTranslations [ kdePackages.qttools ]
    ++ optionals enableCubeb [ cubeb ]
    ++ optional useDiscordRichPresence rapidjson;

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
  ];

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

  postInstall =
    let
      libs = makeLibraryPath [ vulkan-loader ];
    in
    optionalString enableSdl2Frontend ''
      for binfile in lime3ds lime3ds-room
      do
        wrapProgram "$out/bin/$binfile" \
          --prefix LD_LIBRARY_PATH : ${libs}
    ''
    + optionalString enableQt ''
        qtWrapperArgs+=(
          --prefix LD_LIBRARY_PATH : ${libs}
        )
      done
    '';

  cmakeFlags =
    [
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
    ]
    ++ optionals enableQt [
      (cmakeBool "ENABLE_QT_TRANSLATION" enableQtTranslations)
    ];

  meta = {
    description = "A Nintendo 3DS emulator based on Citra";
    homepage = "https://github.com/Lime3DS/Lime3ds-archive";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ arthsmn ];
    mainProgram = "lime3ds";
    platforms = lib.platforms.linux;
  };
})
