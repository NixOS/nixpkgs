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
  libogg,
  libvorbis,
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

stdenv.mkDerivation (finalAttrs: rec {
  pname = "q2pro";
  version = "0-unstable-2025-03-08";

  src = fetchFromGitHub {
    owner = "skullernet";
    repo = "q2pro";
    rev = "700559cd4669c1e2f899a4eae869395c33dd4933";
    hash = "sha256-zJYEeVPyppVISjKC0L8zfjfoG0c8TjmSAML4gPryT0A=";
  };

  # build date and rev number is displayed in the game's console
  revCount = "3697"; # git rev-list --count ${src.rev}
  SOURCE_DATE_EPOCH = "1741434552"; # git show -s --format=%ct ${src.rev}

  nativeBuildInputs =
    [
      meson
      pkg-config
      ninja
      makeBinaryWrapper
      copyDesktopItems
    ]
    ++ lib.optional waylandSupport wayland-scanner
    ++ lib.optional stdenv.hostPlatform.isDarwin desktopToDarwinBundle;

  buildInputs =
    [
      zlib
      libpng
      libjpeg
      curl
      SDL2
      libogg
      libvorbis
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

  internalVersion = "r${revCount}~${builtins.substring 0 8 src.rev}";
  postPatch = ''
    echo '${internalVersion}' > VERSION
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

      install -D ${src}/src/unix/res/q2pro.xpm $out/share/icons/hicolor/32x32/apps/q2pro.xpm
    '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  preVersionCheck = ''
    export version='${internalVersion}'
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
