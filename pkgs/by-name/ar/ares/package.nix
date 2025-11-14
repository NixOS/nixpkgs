{
  lib,
  alsa-lib,
  apple-sdk,
  cmake,
  fetchzip,
  gtk3,
  gtksourceview3,
  libGL,
  libGLU,
  libX11,
  libXv,
  libao,
  libpulseaudio,
  libretro-shaders-slang,
  librashader,
  ninja,
  moltenvk,
  openal,
  pkg-config,
  replaceVars,
  sdl3,
  stdenv,
  udev,
  vulkan-loader,
  wrapGAppsHook3,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ares";
  version = "146";

  src = fetchzip {
    url = "https://github.com/ares-emulator/ares/releases/download/v${finalAttrs.version}/ares-source.tar.gz";
    hash = "sha256-D4N0u9NNlhs4nMoUrAY+sg6Ybt1xQPMiH1u0cV0Qixs=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wrapGAppsHook3
  ];

  buildInputs = [
    sdl3
    libao
    librashader
    vulkan-loader
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    moltenvk
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    gtk3
    gtksourceview3
    libGL
    libGLU
    libX11
    libXv
    libpulseaudio
    openal
    udev
  ];

  patches = [
    (replaceVars ./darwin-build-fixes.patch {
      sdkVersion = apple-sdk.version;
    })
  ];

  cmakeFlags = [
    (lib.cmakeBool "ARES_BUILD_LOCAL" false)
    (lib.cmakeBool "ARES_SKIP_DEPS" true)
    (lib.cmakeBool "ARES_BUILD_OFFICIAL" true)
  ];

  postInstall =
    if stdenv.hostPlatform.isDarwin then
      ''
        mkdir $out/Applications
        cp -a desktop-ui/ares.app $out/Applications/ares.app
        # Shaders directory is already populated with Metal shaders, so can't simply symlink the slang shaders directory itself
        for f in ${libretro-shaders-slang}/share/libretro/shaders/shaders_slang/*; do
          ln -s "$f" $out/Applications/ares.app/Contents/Resources/Shaders/
        done
      ''
    else
      ''
        ln -s ${libretro-shaders-slang}/share/libretro $out/share/libretro
      '';

  postFixup =
    if stdenv.hostPlatform.isDarwin then
      ''
        install_name_tool \
          -add_rpath ${librashader}/lib \
          -add_rpath ${moltenvk}/lib \
          $out/Applications/ares.app/Contents/MacOS/ares
      ''
    else
      ''
        patchelf $out/bin/.ares-wrapped \
          --add-rpath ${
            lib.makeLibraryPath [
              librashader
              vulkan-loader
            ]
          }
      '';

  meta = {
    homepage = "https://ares-emu.net";
    description = "Open-source multi-system emulator with a focus on accuracy and preservation";
    license = lib.licenses.isc;
    mainProgram = "ares";
    platforms = lib.platforms.unix;
  };
})
