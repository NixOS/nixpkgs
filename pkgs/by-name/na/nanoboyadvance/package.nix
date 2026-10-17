{
  lib,
  stdenv,
  fetchFromCodeberg,
  cmake,
  python3Packages,
  SDL2,
  qt6,
  zlib,
  bzip2,
  xz,
  gtk3,
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

  postPatch = ''
    # don’t install unarr library to the package output
    substituteInPlace thirdparty/CMakeLists.txt \
      --replace-fail 'add_subdirectory(unarr-1.1.1-patch)' 'add_subdirectory(unarr-1.1.1-patch EXCLUDE_FROM_ALL)'
  '';

  nativeBuildInputs = [
    cmake
    python3Packages.jinja2
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    SDL2
    qt6.qtsvg
    qt6.qtbase
    zlib
    bzip2
    xz
    gtk3
  ];

  preConfigure = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    export AR="gcc-ar"
    export RANLIB="gcc-ranlib"
  '';

  cmakeFlags = [
    (lib.cmakeBool "PORTABLE_MODE" false)
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeBool "MACOS_BUILD_APP_BUNDLE" true)
    (lib.cmakeBool "MACOS_BUNDLE_QT" false)
  ];

  # Make it runnable from the terminal on Darwin
  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir "$out/bin"
    ln -s "$out/Applications/NanoBoyAdvance.app/Contents/MacOS/NanoBoyAdvance" "$out/bin/NanoBoyAdvance"
  '';

  preFixup = ''
    qtWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}"
      --set QT_QPA_PLATFORM xcb
      --set SDL_VIDEODRIVER x11
    )
  '';

  meta = {
    description = "Cycle-accurate Nintendo Game Boy Advance emulator";
    homepage = "https://nanoboyadvance.eu/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "NanoBoyAdvance";
    maintainers = with lib.maintainers; [
      tomasajt
      lukas-sgx
    ];
    platforms = lib.platforms.all;
  };
})
