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
  version = "25.10.2";

  src = fetchFromGitHub {
    owner = "xiaoyifang";
    repo = "goldendict-ng";
    tag = "v${finalAttrs.version}-Release.673d1b90";
    hash = "sha256-afzMUko09vGmQvu6sob8jYfVUvQECoUdAmIbLIoh1Dw=";
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
