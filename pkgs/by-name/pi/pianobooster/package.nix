{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  alsa-lib,
  ftgl,
  libGLU,
  rtmidi,
  libjack2,
  fluidsynth,
  soundfont-fluid,
  unzip,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pianobooster";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "pianobooster";
    repo = "PianoBooster";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1WOlAm/HXSL6QK0Kd1mnFEZxxpMseTG+6WzgMNWt+RA=";
  };

  postPatch = ''
    substituteInPlace src/Settings.cpp src/GuiMidiSetupDialog.cpp \
      --replace "/usr/share/soundfonts" "${soundfont-fluid}/share/soundfonts" \
      --replace "FluidR3_GM.sf2" "FluidR3_GM2-2.sf2"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ (with libsForQt5; [
    qttools
    wrapQtAppsHook
  ]);

  buildInputs = [
    alsa-lib
    ftgl
    libGLU
    libsForQt5.qtbase
    rtmidi
    libjack2
    fluidsynth
  ];

  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    "-DOpenGL_GL_PREFERENCE=GLVND"
    "-DUSE_JACK=ON"
  ];

  postInstall = ''
    qtWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ unzip ]}"
    )
  '';

  meta = {
    description = "MIDI file player that teaches you how to play the piano";
    mainProgram = "pianobooster";
    homepage = "https://github.com/pianobooster/PianoBooster";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ orivej ];
  };
})
