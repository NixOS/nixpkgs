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
  openalSoft,
  libGL,
  libogg,
  libvorbis,
  libX11,
  libXi,
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
  pname = "q2pro";
  version = "0-unstable-2025-07-21";

  src = fetchFromGitHub {
    owner = "skullernet";
    repo = "q2pro";
    rev = "3aa0d40ba58935154b0d2a02116021bfbb4f17e8";
    hash = "sha256-aqpOoECNKozbCWnCFpyTCbUlTx8tdpqjMAES7x9yEM0=";
  };

  # build date and rev number is displayed in the game's console
  revCount = "3832"; # git rev-list --count ${src.rev}
  SOURCE_DATE_EPOCH = "1753090158"; # git show -s --format=%ct ${src.rev}

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
    libogg
    libvorbis
    libX11
    ffmpeg
    openalSoft
  ]
  ++ lib.optionals waylandSupport [
    wayland
    wayland-protocols
    libdecor
  ]
  ++ lib.optional x11Support libXi;

  mesonBuildType = "release";

  mesonFlags = [
    (lib.mesonBool "anticheat-server" true)
    (lib.mesonBool "client-gtv" true)
    (lib.mesonBool "packetdup-hack" true)
    (lib.mesonBool "variable-fps" true)
    (lib.mesonEnable "wayland" waylandSupport)
    (lib.mesonEnable "x11" x11Support)
    (lib.mesonEnable "icmp-errors" stdenv.hostPlatform.isLinux)
    (lib.mesonEnable "windows-crash-dumps" false)
  ];

  internalVersion = "r${finalAttrs.revCount}~${builtins.substring 0 8 finalAttrs.src.rev}";
  postPatch = ''
    echo '${finalAttrs.internalVersion}' > VERSION
  '';

  postInstall =
    let
      ldLibraryPathEnvName =
        if stdenv.hostPlatform.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH";
    in
    ''
      mv -v $out/bin/q2pro $out/bin/q2pro-unwrapped
      makeWrapper $out/bin/q2pro-unwrapped $out/bin/q2pro \
        --prefix ${ldLibraryPathEnvName} : "${lib.makeLibraryPath finalAttrs.buildInputs}"

      install -D ${finalAttrs.src}/src/unix/res/q2pro.xpm $out/share/icons/hicolor/32x32/apps/q2pro.xpm
    '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  preVersionCheck = ''
    export version='${finalAttrs.internalVersion}'
  '';
  doInstallCheck = true;

  desktopItems = [
    (makeDesktopItem {
      name = "q2pro";
      desktopName = "Q2PRO";
      exec = if stdenv.hostPlatform.isDarwin then "q2pro" else "q2pro +connect %u";
      icon = "q2pro";
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
    description = "Enhanced Quake 2 client and server focused on multiplayer";
    homepage = "https://github.com/skullernet/q2pro";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ carlossless ];
    platforms = lib.platforms.unix;
    mainProgram = "q2pro";
  };
})
