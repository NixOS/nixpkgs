{ lib
, stdenv
, mkDerivation
, fetchFromGitHub
, alsa-lib
, cmake
, libpulseaudio
, libmt32emu
, pkg-config
, portaudio
, qtbase
, qtmultimedia
, withJack ? stdenv.hostPlatform.isUnix, libjack2
}:

mkDerivation rec {
  pname = "mt32emu-qt";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "munt";
    repo = "munt";
    rev = "mt32emu_qt_${lib.replaceChars [ "." ] [ "_" ] version}";
    hash = "sha256-9vapBKpl1NC3mIDetuCb452IHV6c7c7NCzSyiBry5oo=";
  };

  postPatch = ''
    sed -i -e '/add_subdirectory(mt32emu)/d' CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libmt32emu
    portaudio
    qtbase
    qtmultimedia
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    libpulseaudio
  ]
  ++ lib.optional withJack libjack2;

  dontFixCmake = true;

  cmakeFlags = [
    "-Dmt32emu-qt_USE_PULSEAUDIO_DYNAMIC_LOADING=OFF"
    "-Dmunt_WITH_MT32EMU_QT=ON"
    "-Dmunt_WITH_MT32EMU_SMF2WAV=OFF"
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/Applications
    mv $out/bin/${meta.mainProgram}.app $out/Applications/
    ln -s $out/{Applications/${meta.mainProgram}.app/Contents/MacOS,bin}/${meta.mainProgram}
  '';

  meta = with lib; {
    homepage = "http://munt.sourceforge.net/";
    description = "A synthesizer application built on Qt and libmt32emu";
    longDescription = ''
      mt32emu-qt is a synthesiser application that facilitates both realtime
      synthesis and conversion of pre-recorded SMF files to WAVE making use of
      the mt32emu library and the Qt framework.
    '';
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.all;
    mainProgram = "mt32emu-qt";
  };
}
