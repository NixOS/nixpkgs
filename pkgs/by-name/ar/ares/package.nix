{
  lib,
  SDL2,
  alsa-lib,
  apple-sdk_14,
  cmake,
  fetchFromGitHub,
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
  stdenv,
  udev,
  vulkan-loader,
  wrapGAppsHook3,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ares";
  version = "143";

  src = fetchFromGitHub {
    owner = "ares-emulator";
    repo = "ares";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uuFKbS7WvxkTyyQfuQ6iKPvRt+54zUPdjUlQ/ohBAr8=";
  };

  nativeBuildInputs =
    [
      cmake
      ninja
      pkg-config
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      wrapGAppsHook3
    ];

  buildInputs =
    [
      SDL2
      libao
      librashader
      vulkan-loader
      zlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_14
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
    ./darwin-build-fixes.patch
  ];

  cmakeFlags = [
    (lib.cmakeBool "ARES_BUILD_LOCAL" false)
    (lib.cmakeBool "ARES_SKIP_DEPS" true)
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
    maintainers = with lib.maintainers; [
      Madouura
    ];
    platforms = lib.platforms.unix;
  };
})
