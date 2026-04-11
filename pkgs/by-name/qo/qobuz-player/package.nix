{
  alsa-lib,
  fetchFromGitHub,
  lib,
  openssl,
  pkg-config,
  protobuf,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "qobuz-player";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "SofusA";
    repo = "qobuz-player";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uslU/HQognLMNz/w9hMdtpzby2neE+VC8Y+RV2XMd7Q=";
  };

  cargoHash = "sha256-vcII4SDE5zOgzS83CCLhffc7OEksmcMtXYb76r6M1JM=";

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = [
    alsa-lib
    openssl
  ];

  meta = {
    description = "Tui, web and rfid player for Qobuz";
    homepage = "https://github.com/SofusA/qobuz-player";
    changelog = "https://github.com/SofusA/qobuz-player/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      felixsinger
    ];
    platforms = lib.platforms.linux;
    mainProgram = "qobuz-player";
  };
})
