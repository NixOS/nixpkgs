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
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "SofusA";
    repo = "qobuz-player";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PQhuMGUKKquxZn/Tru8rYapzcoWiZR2Q7q6R+XT2z1s=";
  };

  cargoHash = "sha256-H2dZJgNTMqLvQ4PMF0JRngTBK4hFF8a/Z/8jAhL7NDM=";

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
