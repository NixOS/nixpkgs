{
  lib,
  stdenv,
  fetchFromCodeberg,
  cmake,
  python3Packages,
  qt6,
  sdl3,
  fmt,
  toml11,
  libunarr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nanoboyadvance";
  version = "1.8.3-unstable-2026-05-17";

  src = fetchFromCodeberg {
    owner = "nba-emu";
    repo = "NanoBoyAdvance";
    # There are fixes for Wayland (as well as SDL3) after the last release
    # that need to be included to get something that runs on Wayland
    #rev = "v${finalAttrs.version}";
    rev = "e09c3c1a753c6f85c86568a0b88ba79e230b6a07";
    hash = "sha256-ud/Fau0VKKpTi6PEji/7hdhL1kbI6BD5KUdqzLqDkfU=";
  };

  # As the environment variable can be overridden, until the Wayland + EGL
  # issue is resolved "xcb" must be forced over "wayland". Upstream notes that
  # this affects other emulators + Steam too.
  qtWrapperArgs = lib.optional stdenv.hostPlatform.isLinux [
    "--set QT_QPA_PLATFORM xcb"
  ];

  nativeBuildInputs = [
    cmake
    python3Packages.jinja2
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    sdl3
    fmt
    toml11
    libunarr
  ];

  cmakeFlags = [
    (lib.cmakeBool "PORTABLE_MODE" false)
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeBool "MACOS_BUILD_APP_BUNDLE" true)
    (lib.cmakeBool "MACOS_BUNDLE_QT" false)
  ];

  postPatch = ''
    substituteInPlace thirdparty/unarr-1.1.1-patch/CMakeLists.txt \
      --replace-fail "-flto" ""
  '';

  # Make it runnable from the terminal on Darwin
  postInstall = lib.optionals stdenv.hostPlatform.isDarwin /* bash */ ''
    mkdir "$out/bin"
    ln -s "$out/Applications/NanoBoyAdvance.app/Contents/MacOS/NanoBoyAdvance" "$out/bin/NanoBoyAdvance"
  '';

  meta = {
    description = "Cycle-accurate Nintendo Game Boy Advance emulator";
    homepage = "https://nanoboyadvance.eu/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "NanoBoyAdvance";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.all;
  };
})
