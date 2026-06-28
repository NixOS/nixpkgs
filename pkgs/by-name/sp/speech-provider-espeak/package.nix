{
  lib,
  stdenv,
  fetchFromGitHub,
  cargo,
  meson,
  ninja,
  pkg-config,
  rustPlatform,
  rustc,
  glib,
  espeak-ng,
  libspeechprovider,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "speech-provider-espeak";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "project-spiel";
    repo = "speech-provider-espeak";
    rev = "SPEECH_PROVIDER_ESPEAK_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}}";
    hash = "sha256-mzlW6ooA8isYqL5BF/iuVtRRbBJIwTNbe68kVksJeVQ=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "glib-sys-0.20.0" = "sha256-eh5vMqx53xjrK/+DuVJO5qiPz5B0AtLA5bgY68VLLzo=";
      "speechprovider-0.1.0" = "sha256-Z+Fzec5uE87SfHCt5h/Hnts2RJ08twgm13HDvgLRiZ0=";
    };
  };

  nativeBuildInputs = [
    cargo
    meson
    ninja
    pkg-config
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustc
  ];

  buildInputs = [
    glib
    espeak-ng
    libspeechprovider
  ];

  strictDeps = true;

  meta = {
    description = "Spiel speech provider using eSpeak-NG engine";
    homepage = "https://github.com/project-spiel/speech-provider-espeak";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ jtojnar ];
    mainProgram = "speech-provider-espeak";
    platforms = lib.platforms.unix;
  };
})
