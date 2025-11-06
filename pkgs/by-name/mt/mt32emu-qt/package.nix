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

  postPatch = ''
    sed -i -e '/add_subdirectory(mt32emu)/d' CMakeLists.txt
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
    "-Dmt32emu-qt_USE_PULSEAUDIO_DYNAMIC_LOADING=OFF"
    "-Dmunt_WITH_MT32EMU_QT=ON"
    "-Dmunt_WITH_MT32EMU_SMF2WAV=OFF"
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
