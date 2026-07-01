{
  lib,
  stdenv,
  fetchFromCodeberg,
  cmake,
  python3Packages,
  qt6,
  SDL2,
  fmt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nanoboyadvance";
  version = "1.8.3";

  src = fetchFromCodeberg {
    owner = "nba-emu";
    repo = "NanoBoyAdvance";
    rev = "v${finalAttrs.version}";
    hash = "sha256-G/STYu8vOTqoGAGfpPelYV/m0Cth4xMMD1QJ6TbqAF4=";
  };

  nativeBuildInputs = [
    cmake
    python3Packages.jinja2
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    SDL2
    fmt
    # NOTE: using these vendored libraries while they contain minor patches
    # libunarr
    # toml11
  ];

  cmakeFlags = [
    (lib.cmakeBool "PORTABLE_MODE" false)
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeBool "MACOS_BUILD_APP_BUNDLE" true)
    (lib.cmakeBool "MACOS_BUNDLE_QT" false)
  ];

  postPatch = ''
    # LTO won’t work with this toolchain in Nixpkgs
    substituteInPlace thirdparty/unarr-1.1.1-patch/CMakeLists.txt \
      --replace-fail "-flto" ""

    # don’t install unarr library to the package output
    substituteInPlace thirdparty/CMakeLists.txt \
      --replace-fail 'add_subdirectory(unarr-1.1.1-patch)' 'add_subdirectory(unarr-1.1.1-patch EXCLUDE_FROM_ALL)'
  '';

  # Make it runnable from the terminal on Darwin
  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin /* bash */ ''
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
