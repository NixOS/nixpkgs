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

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "goldendict-ng";
  version = "25.10.2";
=======
stdenv.mkDerivation {
  pname = "goldendict-ng";
  version = "25.05.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "xiaoyifang";
    repo = "goldendict-ng";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}-Release.673d1b90";
    hash = "sha256-afzMUko09vGmQvu6sob8jYfVUvQECoUdAmIbLIoh1Dw=";
  };

  strictDeps = true;

=======
    tag = "v25.05.0-Release.2a2b0e16";
    hash = "sha256-PBqkVac867xE4ZcvwTysAK6rQSoEZelKrV9USvFsaLk=";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nativeBuildInputs = [
    pkg-config
    cmake
    wrapQtAppsHook
    wrapGAppsHook3
  ];
<<<<<<< HEAD

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  # Prevent double wrapping of wrapQtApps and wrapGApps
=======
  # to prevent double wrapping of wrapQtApps and wrapGApps
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    homepage = "https://xiaoyifang.github.io/goldendict-ng/";
    description = "Advanced multi-dictionary lookup program";
    platforms = lib.platforms.linux;
    mainProgram = "goldendict";
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    homepage = "https://xiaoyifang.github.io/goldendict-ng/";
    description = "Advanced multi-dictionary lookup program";
    platforms = platforms.linux;
    mainProgram = "goldendict";
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      slbtty
      michojel
      linsui
    ];
<<<<<<< HEAD
    license = lib.licenses.gpl3Plus;
  };
})
=======
    license = licenses.gpl3Plus;
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
