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
  libXtst,
  qtbase,
  qtsvg,
  qtwebengine,
  qttools,
  qtwayland,
  qt5compat,
  qtmultimedia,
  wrapQtAppsHook,
  wrapGAppsHook3,
}:

stdenv.mkDerivation {
  pname = "goldendict-ng";
  version = "25.05.0";

  src = fetchFromGitHub {
    owner = "xiaoyifang";
    repo = "goldendict-ng";
    tag = "v25.05.0-Release.2a2b0e16";
    hash = "sha256-PBqkVac867xE4ZcvwTysAK6rQSoEZelKrV9USvFsaLk=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    wrapQtAppsHook
    wrapGAppsHook3
  ];
  buildInputs = [
    qtbase
    qtsvg
    qttools
    qtwebengine
    qt5compat
    qtmultimedia
    qtwayland
    libvorbis
    tomlplusplus
    fmt
    hunspell
    xz
    lzo
    libXtst
    bzip2
    libiconv
    opencc
    libeb
    xapian
    libzim
  ];

  # to prevent double wrapping of wrapQtApps and wrapGApps
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

  meta = with lib; {
    homepage = "https://xiaoyifang.github.io/goldendict-ng/";
    description = "Advanced multi-dictionary lookup program";
    platforms = platforms.linux;
    mainProgram = "goldendict";
    maintainers = with maintainers; [
      slbtty
      michojel
      linsui
    ];
    license = licenses.gpl3Plus;
  };
}
