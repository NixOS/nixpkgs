{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  boost,
  cmake,
  discord-rpc,
  freetype,
  hidapi,
  libpng,
  libsamplerate,
  minizip,
  nasm,
  pkg-config,
  qt6Packages,
  SDL2,
  SDL2_net,
  speexdsp,
  vulkan-headers,
  vulkan-loader,
  which,
  xdg-user-dirs,
  zlib,
  withWayland ? false,
  # Affects final license
  withAngrylionRdpPlus ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rmg";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "Rosalie241";
    repo = "RMG";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sjjGFV2Pse1sNWYpmu5+Y0ePB738S7jPOzFCmmeCPXA=";
  };

  nativeBuildInputs = [
    cmake
    nasm
    pkg-config
    qt6Packages.wrapQtAppsHook
    which
  ];

  buildInputs =
    [
      boost
      discord-rpc
      freetype
      hidapi
      libpng
      libsamplerate
      minizip
      SDL2
      SDL2_net
      speexdsp
      vulkan-headers
      vulkan-loader
      xdg-user-dirs
      zlib
    ]
    ++ (
      with qt6Packages;
      [
        qtbase
        qtsvg
        qtwebsockets
      ]
      ++ lib.optional withWayland qtwayland
    );

  cmakeFlags = [
    (lib.cmakeBool "PORTABLE_INSTALL" false)
    # mupen64plus-input-gca is written in Rust, so we can't build it with
    # everything else.
    (lib.cmakeBool "NO_RUST" true)
    (lib.cmakeBool "USE_ANGRYLION" withAngrylionRdpPlus)
  ];

  qtWrapperArgs =
    lib.optionals stdenv.hostPlatform.isLinux [
      "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]}"
    ]
    ++ lib.optional withWayland "--set RMG_ALLOW_WAYLAND 1";

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    homepage = "https://github.com/Rosalie241/RMG";
    changelog = "https://github.com/Rosalie241/RMG/releases/tag/v${finalAttrs.version}";
    description = "Rosalie's Mupen GUI";
    longDescription = ''
      Rosalie's Mupen GUI is a free and open-source mupen64plus front-end
      written in C++. It offers a simple-to-use user interface.
    '';
    license = if withAngrylionRdpPlus then lib.licenses.unfree else lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "RMG";
    maintainers = with lib.maintainers; [ slam-bert ];
  };
})
