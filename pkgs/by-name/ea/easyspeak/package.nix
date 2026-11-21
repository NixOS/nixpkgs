{
  lib,
  python314Packages,
  fetchFromGitHub,

  pulseaudio,
  piper-tts,
  sound-theme-freedesktop,
  easyspeak-lang-en,

  makeWrapper,
}:

python314Packages.buildPythonPackage (finalAttrs: {
  pname = "easyspeak";
  version = "0.8.0";
  __structuredAttrs = true;
  strictDeps = true;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ctsdownloads";
    repo = "easyspeak";
    tag = "${finalAttrs.version}";
    hash = "sha256-gITbTDSqOt0g+ofvvfO1idQM4Mfz7kEh9T43X2IyRvo=";
  };

  build-system = with python314Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python314Packages; [
    evdev
    faster-whisper
    jeepney
    numpy
    onnxruntime
    opencv4
    pyaudio
    pyopen-wakeword
  ];

  pythonRemoveDeps = [
    "evdev-binary"
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  postFixup = ''
    wrapProgram $out/bin/easyspeak \
      --prefix PATH : ${
        lib.makeBinPath [
          pulseaudio
          piper-tts
        ]
      } \
      --prefix XDG_DATA_DIRS : "${sound-theme-freedesktop}/share" \
      --set LC_ALL C.UTF-8 \
      --set EASYSPEAK_SOUNDS_DIR "${sound-theme-freedesktop}/share/sounds/freedesktop/stereo" \
      --set EASYSPEAK_WHISPER_MODEL "${easyspeak-lang-en}/${easyspeak-lang-en.models.whisper}" \
      --set EASYSPEAK_PIPER_MODEL "${easyspeak-lang-en}/${easyspeak-lang-en.models.piper}"
  '';

  meta = {
    description = "Voice control for Linux desktops. Fully local, no cloud, Wayland-native.";
    homepage = "https://easyspeak.dev";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.ahoneybun ];
    platforms = lib.platforms.linux;
    mainProgram = "easyspeak";
  };
})
