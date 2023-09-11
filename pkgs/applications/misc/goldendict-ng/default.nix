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
  version = "23.07.23";

  src = fetchFromGitHub {
    owner = "xiaoyifang";
    repo = "goldendict-ng";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZKbrO5L4KFmr2NsGDihRWBeW0OXHoPRwZGj6kt1Anc8=";
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
    description = "Advanced multi-dictionary lookup program.";
    platforms = platforms.linux;
    maintainers = with maintainers; [ slbtty ];
    license = licenses.gpl3Plus;
  };
})
