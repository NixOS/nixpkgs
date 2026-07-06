{
  lib,
  stdenv,
  replaceVars,
  fetchFromGitHub,
  cmake,
  pkg-config,
  alsa-lib,
  ftgl,
  freetype,
  libGLU,
  rtmidi,
  libjack2,
  fluidsynth,
  soundfont-fluid,
  soundFonts ? [ soundfont-fluid ],
  dejavu_fonts,
  unzip,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pianobooster";
  version = "1.0.0-unstable-2023-01-22"; # use unstable version for Qt 6 support

  src = fetchFromGitHub {
    owner = "pianobooster";
    repo = "PianoBooster";
    rev = "6dafdcbdfc5d35d12cecb051c30632d0f5be5806";
    hash = "sha256-ZOgTgN1CWiPHe9of8NjgoPP5xzAY1k2v9xSAY1m2Bu0=";
  };

  patches = [
    # more sensible soundfont discovery
    (replaceVars ./soundfont.patch {
      possibleSoundFontFolders = lib.concatMapStringsSep ", " (
        p: "\"${p}/share/soundfonts\", \"${p}/share/sounds/sf2\""
      ) soundFonts;
    })
  ];

  postPatch = ''
    substituteInPlace src/CMakeLists.txt --replace-fail "ADD_DEFINITIONS(-std=c++11)" ""
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    ftgl
    freetype # required by ftgl; somehow qt provides freetype on linux but not on darwin
    libGLU
    qt6.qtbase
    qt6.qt5compat
    rtmidi
    libjack2
    fluidsynth
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux alsa-lib;

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
    (lib.cmakeFeature "OpenGL_GL_PREFERENCE" "GLVND")
    (lib.cmakeFeature "QT_PACKAGE_NAME" "Qt6")
    (lib.cmakeBool "WITH_MAN" true)
    (lib.cmakeBool "USE_BUNDLED_RTMIDI" false)
    (lib.cmakeBool "USE_JACK" true)
    (lib.cmakeBool "USE_SYSTEM_FONT" true)
    (lib.cmakeFeature "MACOSX_BUNDLE_GUI_IDENTIFIER" "pianobooster")
    (lib.cmakeFeature "MACOSX_BUNDLE_SHORT_VERSION_STRING" finalAttrs.version)
    (lib.cmakeFeature "MACOSX_BUNDLE_BUNDLE_VERSION" finalAttrs.version)
  ];

  postInstall = ''
    qtWrapperArgs+=(--prefix PATH : "${lib.makeBinPath [ unzip ]}")
  ''
  + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    mkdir -p $out/share/games/pianobooster/fonts
    # use readlink to avoid referencing dejavu-fonts but dejavu-fonts-minimal instead
    ln -s $(readlink -f ${dejavu_fonts}/share/fonts/truetype/DejaVuSans.ttf) $out/share/games/pianobooster/fonts/DejaVuSans.ttf
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin}
    cp -r build/pianobooster.app $out/Applications
    ln -s $out/Applications/pianobooster.app/Contents/MacOS/pianobooster $out/bin/pianobooster
  '';

  meta = {
    description = "MIDI file player that teaches you how to play the piano";
    mainProgram = "pianobooster";
    homepage = "https://www.pianobooster.org";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ulysseszhan ];
  };
})
