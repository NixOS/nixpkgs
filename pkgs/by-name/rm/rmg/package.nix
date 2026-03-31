{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
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
  withDiscordRpc ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rmg";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "Rosalie241";
    repo = "RMG";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XMYHzPE5h9gD1fpN8b5YwOpY5zYCsYYQnof2MHDHa3E=";
  };

  # Fixes include errors from including minizip libraries
  patches = [
    (fetchpatch2 {
      name = "0000-fix-minizip-include-archive";
      url = "https://github.com/Rosalie241/RMG/commit/7e4e402f277803d3a998e96ea04064063bd1551a.patch";
      hash = "sha256-uyEYv2r7J2nou9AHkezEX0LS/mOnIa6lbQqhxHY9ibo=";
    })
    (fetchpatch2 {
      name = "0001-fix-minizip-include-mupen64plus-core";
      url = "https://github.com/Rosalie241/RMG/commit/8ee3410680c247dcfee806562073626a0b7bf46b.patch";
      hash = "sha256-29zg90ScPNizWq3BzNuM6yfCwmMXRYFfbjOg3YpCrGI=";
    })
  ];

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
    minizip
    SDL2
    SDL2_net
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
    maintainers = with lib.maintainers; [ slam-bert ];
  };
})
