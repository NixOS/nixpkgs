{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  ninja,
  pkg-config,
  python3,
  makeBinaryWrapper,

  SDL2,
  SDL2_mixer,
  the-foundation,
  ncurses,
  glbinding,
  assimp,
  glib,
  qt5,
  xorg,

  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "doomsday-engine";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "skyjake";
    repo = "Doomsday-Engine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7jLL8ho3JL4amSTTu9ICmK1rcXIlJ9XWzh/rE6jT1zI=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
    makeBinaryWrapper

    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    SDL2
    SDL2_mixer
    the-foundation
    ncurses
    glbinding
    assimp
    glib

    qt5.qtbase
    qt5.qtx11extras
    xorg.libXrandr
    xorg.libXxf86vm
  ];

  # TODO: enable FMOD support by setting FMOD_DIR
  cmakeFlags = [
    (lib.cmakeBool "DENG_ASSIMP_EMBEDDED" false) # Use system assimp
    (lib.cmakeFeature "DE_PREFIX" (placeholder "out")) # Legacy output prefix
  ];

  preConfigure = ''
    # Doomsday builds PK3 files for these games by default - PK3 files are really just ZIP files,
    # whose contents must have a modification date not earlier than 1980.
    find doomsday/{apps/client/data,apps/plugins/{doom,heretic,hexen,doom64}/{defs,data}} \
      -exec touch -d '1980-01-01T00:00:00Z' {} +
  '';

  # Doomsday Engine does not like Wayland (will SIGSEGV upon launch)
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/doomsday \
      --set "QT_QPA_PLATFORM" "xcb"
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "v([0-9.]+)$"
    ];
  };

  meta = {
    description = "Doom / Heretic / Hexen port with enhanced graphics";
    homepage = "https://dengine.net/";
    changelog = "https://manual.dengine.net/version/${finalAttrs.version}";
    license = with lib.licenses; [
      gpl3 # Applications
      lgpl3 # Core libraries
    ];
    maintainers = with lib.maintainers; [ pluiedev ];
    platforms = with lib.platforms; unix ++ windows;
    # Doomsday 2 relies on QTKit which is deprecated and no longer exists on aarch64-darwin
    # See https://github.com/NixOS/nixpkgs/pull/318552#issuecomment-2157550507
    badPlatforms = [ "aarch64-darwin" ];
    mainProgram = "doomsday";
  };
})
