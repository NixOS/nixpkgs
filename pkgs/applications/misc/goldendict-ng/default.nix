{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, cmake
, libvorbis
, ffmpeg
, libeb
, hunspell
, opencc
, xapian
, libzim
, lzo
, xz
, tomlplusplus
, fmt
, bzip2
, libiconv
, libXtst
, qtbase
, qtsvg
, qtwebengine
, qttools
, qtwayland
, qt5compat
, qtmultimedia
, qtspeech
, wrapQtAppsHook
, wrapGAppsHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "goldendict-ng";
  version = "24.01.22";

  src = fetchFromGitHub {
    owner = "xiaoyifang";
    repo = "goldendict-ng";
    rev = "v${finalAttrs.version}-LoongYear.3dddb3be";
    hash = "sha256-+OiZEkhNV06fZXPXv9zDzgJS5M3isHlcOXee3p/ejpw=";
  };

  nativeBuildInputs = [ pkg-config cmake wrapQtAppsHook wrapGAppsHook ];
  buildInputs = [
    qtbase
    qtsvg
    qttools
    qtwebengine
    qt5compat
    qtmultimedia
    qtspeech
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
    ffmpeg
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
    "-DWITH_FFMPEG_PLAYER=ON"
    "-DWITH_EPWING_SUPPORT=ON"
    "-DUSE_SYSTEM_FMT=ON"
    "-DUSE_SYSTEM_TOML=ON"
  ];

  meta = with lib; {
    homepage = "https://xiaoyifang.github.io/goldendict-ng/";
    description = "An advanced multi-dictionary lookup program";
    platforms = platforms.linux;
    mainProgram = "goldendict";
    maintainers = with maintainers; [ slbtty michojel ];
    license = licenses.gpl3Plus;
  };
})
