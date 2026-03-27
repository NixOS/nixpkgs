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
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "SofusA";
    repo = "qobuz-player";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qAGaosIsS7IodzIJL/7kd5MNC/CW2fY7iYD6CrYSdmw=";
  };

  cargoHash = "sha256-428sWFx+DYyf8RrsY6hzytGmtmO7lmIJIoS2TfnGoh4=";

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
