{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  cmake,
  libvorbis,
  libeb,
  hunspell,
  opencc,
  xapian,
  libzim,
  lzo,
  xz,
  tomlplusplus,
  fmt,
  bzip2,
  libiconv,
  libxtst,
  qt6,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "goldendict-ng";
  version = "26.11.0";

  src = fetchFromGitHub {
    owner = "xiaoyifang";
    repo = "goldendict-ng";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EbG/K43OKCceU4VmFnAvim3KYQ2V+h/6xu1Mfxs1RoI=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    cmake
    qt6.wrapQtAppsHook
    wrapGAppsHook3
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qttools
    qt6.qtwebengine
    qt6.qt5compat
    qt6.qtmultimedia
    qt6.qtwayland
    libvorbis
    tomlplusplus
    fmt
    hunspell
    xz
    lzo
    libxtst
    bzip2
    libiconv
    opencc
    libeb
    xapian
    libzim
  ];

  # Prevent double wrapping of wrapQtApps and wrapGApps
  dontWrapGApps = true;

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  cmakeFlags = [
    "-DWITH_XAPIAN=ON"
    "-DWITH_ZIM=ON"
    "-DWITH_FFMPEG_PLAYER=OFF"
    "-DWITH_EPWING_SUPPORT=ON"
    "-DUSE_SYSTEM_FMT=ON"
    "-DUSE_SYSTEM_TOML=ON"
  ];

  meta = {
    homepage = "https://xiaoyifang.github.io/goldendict-ng/";
    description = "Advanced multi-dictionary lookup program";
    platforms = lib.platforms.linux;
    mainProgram = "goldendict";
    maintainers = with lib.maintainers; [
      slbtty
      michojel
      linsui
    ];
    license = lib.licenses.gpl3Plus;
  };
})
