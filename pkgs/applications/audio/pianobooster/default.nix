{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qttools,
  alsa-lib,
  ftgl,
  libGLU,
  qtbase,
  rtmidi,
  libjack2,
  fluidsynth,
  soundfont-fluid,
  unzip,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "pianobooster";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "pianobooster";
    repo = "PianoBooster";
    rev = "v${version}";
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
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    ftgl
    libGLU
    qtbase
    rtmidi
    libjack2
    fluidsynth
  ];

  cmakeFlags = [
    "-DOpenGL_GL_PREFERENCE=GLVND"
    "-DUSE_JACK=ON"
  ];

  postInstall = ''
    qtWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ unzip ]}"
    )
  '';

  meta = with lib; {
    description = "A MIDI file player that teaches you how to play the piano";
    mainProgram = "pianobooster";
    homepage = "https://github.com/pianobooster/PianoBooster";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      goibhniu
      orivej
    ];
  };
}
