{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  pkg-config,
  ninja,
  zlib,
  libpng,
  libjpeg,
  curl,
  SDL2,
  openal-soft,
  libGL,
  fmt,
  jsoncpp,
  libx11,
  libxi,
  wayland,
  wayland-protocols,
  libdecor,
  ffmpeg,
  wayland-scanner,
  makeBinaryWrapper,
  versionCheckHook,
  copyDesktopItems,
  makeDesktopItem,
  desktopToDarwinBundle,
  x11Support ? stdenv.hostPlatform.isLinux,
  waylandSupport ? stdenv.hostPlatform.isLinux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "q2repro";
  version = "0-unstable-2026-04-23";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Paril";
    repo = "q2repro";
    rev = "0765d6825f9f0c3590a71964960dda4e99d8a1fc";
    fetchSubmodules = true;
    hash = "sha256-m9kmX/nOJ1MbLJ0DWc9qW7gozna/m0eWe28T06LCooM=";
  };

  # build date and rev number is displayed in the game's console
  revCount = "4601"; # git rev-list --count ${src.rev}
  SOURCE_DATE_EPOCH = "1776977454"; # git show -s --format=%ct ${src.rev}

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    makeBinaryWrapper
    copyDesktopItems
  ]
  ++ lib.optional waylandSupport wayland-scanner
  ++ lib.optional stdenv.hostPlatform.isDarwin desktopToDarwinBundle;

  buildInputs = [
    zlib
    libpng
    libjpeg
    curl
    SDL2
    libGL
    ffmpeg
    openal-soft
    # required by the bundled re-release game DLL (subprojects/rerelease-game)
    fmt
    jsoncpp
  ]
  ++ lib.optionals waylandSupport [
    wayland
    wayland-protocols
    libdecor
  ]
  ++ lib.optionals x11Support [
    libx11
    libxi
  ];

  mesonBuildType = "release";

  mesonFlags = [
    (lib.mesonBool "anticheat-server" true)
    (lib.mesonBool "packetdup-hack" true)
    # install into the standard prefix layout (bin/, lib/, share/) instead of
    # the portable single-directory layout used by default
    (lib.mesonBool "system-wide" true)
    # client-gtv (duplicate `psFlags` member) and variable-fps (redefinition of
    # `set_server_fps`, which is now compiled in unconditionally) currently fail
    # to build, so both are left at their upstream default of disabled.
    (lib.mesonEnable "wayland" waylandSupport)
    (lib.mesonEnable "x11" x11Support)
    (lib.mesonEnable "icmp-errors" stdenv.hostPlatform.isLinux)
    (lib.mesonEnable "windows-crash-dumps" false)
  ];

  internalVersion = "r${finalAttrs.revCount}~${builtins.substring 0 8 finalAttrs.src.rev}";
  postPatch = ''
    echo '${finalAttrs.internalVersion}' > VERSION

    # The bundled re-release game library (subprojects/rerelease-game) only
    # marks its GetGameAPI entry point visible on Windows/Linux/BSD; on macOS
    # the export macro expands to nothing, so with hidden symbol visibility the
    # engine loads the dylib but cannot resolve GetGameAPI and aborts with
    # "Failed to load game library". Treat Apple like the other platforms that
    # use the visibility attribute.
    substituteInPlace subprojects/rerelease-game/rerelease/game.h \
      --replace-fail \
        'defined(__linux__) || defined(__FreeBSD__) || defined(__OpenBSD__)' \
        'defined(__linux__) || defined(__FreeBSD__) || defined(__OpenBSD__) || defined(__APPLE__)'
  '';

  postInstall =
    let
      ldLibraryPathEnvName =
        if stdenv.hostPlatform.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH";
    in
    ''
      for bin in q2repro q2reproded; do
        mv -v $out/bin/$bin $out/bin/$bin-unwrapped
        makeWrapper $out/bin/$bin-unwrapped $out/bin/$bin \
          --prefix ${ldLibraryPathEnvName} : "${lib.makeLibraryPath finalAttrs.buildInputs}"
      done

      install -D ${finalAttrs.src}/src/unix/res/q2pro.xpm $out/share/icons/hicolor/32x32/apps/q2repro.xpm
    '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  preVersionCheck = ''
    export version='${finalAttrs.internalVersion}'
  '';
  doInstallCheck = true;

  desktopItems = [
    (makeDesktopItem {
      name = "q2repro";
      desktopName = "Q2REPRO";
      exec = if stdenv.hostPlatform.isDarwin then "q2repro" else "q2repro +connect %u";
      icon = "q2repro";
      terminal = false;
      mimeTypes = [
        "x-scheme-handler/quake2"
      ];
      type = "Application";
      categories = [
        "Game"
        "ActionGame"
      ];
    })
  ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Fork of Q2PRO designed to be a drop-in replacement of the Kex Quake II re-release engine";
    homepage = "https://github.com/Paril/q2repro";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ carlossless ];
    platforms = lib.platforms.unix;
    mainProgram = "q2repro";
  };
})
