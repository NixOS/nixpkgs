{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  cmake,
  libpulseaudio,
  libmt32emu,
  pkg-config,
  portaudio,
  withJack ? stdenv.hostPlatform.isUnix,
  libjack2,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mt32emu-qt";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "munt";
    repo = "munt";
    tag = "mt32emu_qt_${lib.replaceString "." "_" finalAttrs.version}";
    hash = "sha256-PqYPYnKPlnU3PByxksBscl4GqDRllQdmD6RWpy/Ura0=";
  };

  postPatch =
    # Make sure system-installed libmt32emu is used
    # Don't depend on in-tree mt32emu to be used
    ''
      substituteInPlace CMakeLists.txt \
        --replace-fail 'add_subdirectory(mt32emu)' "" \
        --replace-fail 'add_dependencies(mt32emu-qt mt32emu)' ""
    ''
    # Bump CMake minimum to something our CMake supports
    # Fixed treewide in https://github.com/munt/munt/commit/e6af0c7e5d63680716ab350467207c938054a0df
    # Remove when version > 1.11.1
    + ''
      substituteInPlace CMakeLists.txt mt32emu_qt/CMakeLists.txt \
        --replace-fail 'cmake_minimum_required(VERSION 2.8.12)' 'cmake_minimum_required(VERSION 2.8.12...3.27)'
    '';

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libmt32emu
    portaudio
    libsForQt5.qtbase
    libsForQt5.qtmultimedia
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    libpulseaudio
  ]
  ++ lib.optional withJack libjack2;

  cmakeFlags = [
    (lib.cmakeBool "mt32emu-qt_USE_PULSEAUDIO_DYNAMIC_LOADING" false)
    (lib.cmakeBool "munt_WITH_MT32EMU_QT" true)
    (lib.cmakeBool "munt_WITH_MT32EMU_SMF2WAV" false)
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/Applications
    mv $out/bin/mt32emu-qt.app $out/Applications/
    ln -s $out/{Applications/mt32emu-qt.app/Contents/MacOS,bin}/mt32emu-qt
  '';

  meta = {
    homepage = "https://munt.sourceforge.net/";
    description = "Synthesizer application built on Qt and libmt32emu";
    mainProgram = "mt32emu-qt";
    longDescription = ''
      mt32emu-qt is a synthesiser application that facilitates both realtime
      synthesis and conversion of pre-recorded SMF files to WAVE making use of
      the mt32emu library and the Qt framework.
    '';
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.all;
  };
})
