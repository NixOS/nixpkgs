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
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "SofusA";
    repo = "qobuz-player";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1y4VvrxcUOCqOOcMgBuf7VsZ4CZTpF/3TQiVyZPZpcE=";
  };

  cargoHash = "sha256-uOQflE3dYNOrpcg1W23MN7t8CW+3h4Z3Vp00LxBP0pk=";

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
