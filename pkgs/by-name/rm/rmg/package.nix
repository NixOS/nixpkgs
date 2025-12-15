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
  libusb1,
  minizip,
  nasm,
  pkg-config,
  qt6Packages,
  sdl3,
  speexdsp,
  vulkan-headers,
  vulkan-loader,
  which,
  xdg-user-dirs,
  zlib,
  withWayland ? false,
  # Affects final license
  withAngrylionRdpPlus ? false,
  withDiscordRpc ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rmg";
  version = "0.8.8";

  src = fetchFromGitHub {
    owner = "Rosalie241";
    repo = "RMG";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d2kUUJTZhm5m7MIZ8Ym0wyBvX2+h/FsrRQoyLTi0/N8=";
  };

  nativeBuildInputs = [
    cmake
    nasm
    pkg-config
    qt6Packages.wrapQtAppsHook
    which
  ];

  buildInputs = [
    boost
    freetype
    hidapi
    libpng
    libsamplerate
    libusb1
    minizip
    sdl3
    speexdsp
    vulkan-headers
    vulkan-loader
    xdg-user-dirs
    zlib
  ]
  ++ lib.optional withDiscordRpc discord-rpc
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
    (lib.cmakeBool "DISCORD_RPC" withDiscordRpc) # Remove with 0.8.4 update
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
  };
})
