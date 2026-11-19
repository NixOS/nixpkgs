{
  lib,
  stdenv,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  # deps
  cmake,
  pkg-config,
  openssl,
  libGLU,
  libxvmc,
  libxrandr,
  libxinerama,
  libxext,
  libx11,
  alsa-lib,
  libjack2,
  libpulseaudio,
  libogg,
  shaderc,
  sse2neon,
  vulkan-headers,
  vulkan-loader,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "etterna";
  version = "0.75.1";

  src = fetchFromGitHub {
    owner = "etternagame";
    repo = "etterna";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wKXp+tjRlAsjXO/10lXoExGdTukr92qwH/jSY5T+V2s=";
  };

  patches = [
    ./fix-download-manager.patch
    ./0002-replays-dir-fix.patch
  ];

  # 0.75 links prebuilt FFmpeg 2.1.3 (movie backgrounds) and Discord Social SDK libraries
  # from the source tree on x86_64-linux. Don't use them; build like aarch64-linux, with the
  # null movie texture backend (as in 0.74) and without the Discord SDK.
  postPatch = ''
    rm -r extern/ffmpeg/linux-lib extern/discord/lib

    substituteInPlace CMakeLists.txt \
      --replace-fail 'set(SUPPORT_DISCORD_SDK ON)' 'set(SUPPORT_DISCORD_SDK OFF)'
    substituteInPlace src/Etterna/Singletons/GameState.cpp \
      --replace-fail '#error Something went wrong - Discord Social SDK' '// Something went wrong - Discord Social SDK'

    substituteInPlace extern/CMakeLists.txt \
      --replace-fail 'if(_proc STREQUAL "x86_64" AND UNIX AND NOT APPLE)' 'if(FALSE)'
    substituteInPlace CMakeLists.txt \
      --replace-fail 'if(''${CMAKE_SYSTEM_PROCESSOR} STREQUAL "x86_64")' 'if(FALSE)'
    substituteInPlace src/arch/CMakeLists.txt \
      --replace-fail 'elseif(''${CMAKE_SYSTEM_PROCESSOR} STREQUAL "x86_64") # Unix' 'elseif(FALSE) # Unix'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config

    copyDesktopItems
  ];

  buildInputs = [
    openssl
    alsa-lib
    libjack2
    libpulseaudio
    libGLU
    libogg
    shaderc
    sse2neon
    vulkan-headers
    vulkan-loader
    libxinerama
    libxrandr
    libx11
    libxext # Needed for DPMS
    libxvmc
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "etterna";
      desktopName = "Etterna";
      genericName = "Rhythm and dance game";
      icon = "etterna";
      tryExec = "etterna";
      exec = "etterna";
      categories = [
        "Application"
        "Game"
        "ArcadeGame"
      ];
      comment = "A cross-platform rhythm video game.";
      terminal = false;
    })
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,share/etterna}
    mkdir -p $out/share/applications
    # copy select necessary game files into virtual fs
    cp -r /build/source/{Announcers,Assets,BGAnimations,BackgroundEffects,BackgroundTransitions,Data,GameTools,NoteSkins,Scripts,Themes} "$out/share/etterna"

    # copy binary
    cp /build/source/Etterna $out/bin/.etterna-unwrapped

    # Install the Icon
    install -Dm644 /build/source/Docs/images/etterna-logo-light.svg "$out/share/icons/hicolor/scalable/apps/etterna.svg"

    # wacky insertion of wrapper directly into phase, so that $out is set
    cat > $out/bin/etterna << EOF
    #!${stdenv.shell}
    export ETTERNA_ROOT_DIR="\$HOME/.local/share/etterna"
    export ETTERNA_ADDITIONAL_ROOT_DIRS="$out/share/etterna"
    echo "HOME: \$HOME"
    echo "PWD: \$(pwd)"
    echo "ETTERNA_ADDITIONAL_ROOT_DIRS: \$ETTERNA_ADDITIONAL_ROOT_DIRS"
    exec $out/bin/.etterna-unwrapped "\$@"
    EOF
    chmod +x $out/bin/etterna
    runHook postInstall
  '';

  # vk-bootstrap dlopens libvulkan at runtime
  postFixup = ''
    patchelf --add-rpath ${lib.makeLibraryPath [ vulkan-loader ]} $out/bin/.etterna-unwrapped
  '';

  cmakeFlags = [
    "-D WITH_CRASHPAD=OFF"
    # Use the shared shaderc; the nixpkgs static shaderc_combined does not bundle glslang and SPIRV-Tools
    (lib.cmakeFeature "Vulkan_shaderc_combined_LIBRARY" "${lib.getLib shaderc}/lib/libshaderc_shared${stdenv.hostPlatform.extensions.sharedLibrary}")
  ];

  meta = {
    description = "Advanced cross-platform rhythm game focused on keyboard play";
    homepage = "https://etternaonline.com";
    changelog = "https://github.com/etternagame/etterna/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alikindsys ];
    mainProgram = "etterna";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
