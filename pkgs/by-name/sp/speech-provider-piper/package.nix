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
  onnxruntime,
  darwin,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "speech-provider-piper";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "project-spiel";
    repo = "speech-provider-piper";
    rev = "SPEECH_PROVIDER_PIPER_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-vkKZ75yJeoAditIFZ0RvsCF/chDYzJwqC4WpdZTHEyM=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "audio-ops-1.0.0" = "sha256-P27R4S3HwI1FJJsSLc0q+j082MTpVmNrf8JuAhPsUxo=";
      "glib-sys-0.20.0" = "sha256-ICNIuE3/6dLBBOTbIW9DjaEg1+tCmHZmgQw/zv/1bIU=";
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

  buildInputs =
    [
      glib
      onnxruntime
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

  strictDeps = true;

  mesonFlags = [
    "-Doffline=true"
  ];

  env = {
    ORT_PREFER_DYNAMIC_LINK = "1";
  };

  meta = {
    description = "Spiel speech provider for neural TTS models like Piper";
    homepage = "https://github.com/project-spiel/speech-provider-piper";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ jtojnar ];
    mainProgram = "speech-provider-piper";
    platforms = lib.platforms.unix;
  };
})
