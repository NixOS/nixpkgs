{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  bash,
  coreutils,
  util-linux,
  findutils,
  gnused,
  jq,
  curl,
  pulseaudio,
  python3,
  systemd,
  whisper-cpp,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "quill-linux";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "bindusara-reddy";
    repo = "quill-linux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OvvwXAPgF9jmkQ1Ez1t2/gvVp1i/MtiMaNi/VKqBmmg=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 quill $out/bin/quill
    install -Dm644 share/applications/quill.desktop \
      $out/share/applications/quill.desktop

    wrapProgram $out/bin/quill \
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          coreutils
          util-linux
          findutils
          gnused
          jq
          curl
          pulseaudio
          (python3.withPackages (ps: [ ps.sherpa-onnx ]))
          systemd
          whisper-cpp
        ]
      }

    runHook postInstall
  '';

  meta = {
    description = "Minimal local meeting recorder and transcriber (PipeWire + Parakeet TDT)";
    longDescription = ''
      quill records the microphone and system audio as two separate tracks via
      PipeWire's PulseAudio layer, transcribes both locally with NVIDIA
      Parakeet TDT 0.6B v3 through whisper.cpp's parakeet-cli, splits each
      track by voice with sherpa-onnx speaker diarization, and writes a
      speaker-tagged (me/them-1/them-2/...) transcript. Audio is deleted after
      successful transcription. Override whisper-cpp with whisper-cpp-vulkan
      for GPU transcription.
    '';
    homepage = "https://github.com/bindusara-reddy/quill-linux";
    changelog = "https://github.com/bindusara-reddy/quill-linux/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "quill";
    maintainers = with lib.maintainers; [ bindusara-reddy ];
  };
})
