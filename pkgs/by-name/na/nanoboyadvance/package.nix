{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  python3Packages,
  libsForQt5,
  SDL2,
  fmt,
  toml11,
  libunarr,
}:

let
  gladSrc = fetchFromGitHub {
    owner = "Dav1dde";
    repo = "glad";
    rev = "v2.0.5";
    hash = "sha256-Ba7nbd0DxDHfNXXu9DLfnxTQTiJIQYSES9CP5Bfq4K0=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "nanoboyadvance";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "nba-emu";
    repo = "NanoBoyAdvance";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IH2X0B3HwEG0/wvKacLVPBQad14W0HBy5VFHjk8vgJk=";
  };

  patches = [
    # <https://github.com/nba-emu/NanoBoyAdvance/pull/410>
    ./fix-toml11-4.0.patch
  ];

  nativeBuildInputs = [
    cmake
    python3Packages.jinja2
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtbase
    SDL2
    fmt
    toml11
    libunarr
  ];

  cmakeFlags = [
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_GLAD" "${gladSrc}")
    (lib.cmakeBool "USE_SYSTEM_FMT" true)
    (lib.cmakeBool "USE_SYSTEM_TOML11" true)
    (lib.cmakeBool "USE_SYSTEM_UNARR" true)
    (lib.cmakeBool "PORTABLE_MODE" false)
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeBool "MACOS_BUILD_APP_BUNDLE" true)
    (lib.cmakeBool "MACOS_BUNDLE_QT" false)
  ];

  # Make it runnable from the terminal on Darwin
  postInstall = lib.optionals stdenv.hostPlatform.isDarwin ''
    mkdir "$out/bin"
    ln -s "$out/Applications/NanoBoyAdvance.app/Contents/MacOS/NanoBoyAdvance" "$out/bin/NanoBoyAdvance"
  '';

  meta = {
    description = "Cycle-accurate Nintendo Game Boy Advance emulator";
    homepage = "https://github.com/nba-emu/NanoBoyAdvance";
    license = lib.licenses.gpl3Plus;
    mainProgram = "NanoBoyAdvance";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.all;
  };
})
