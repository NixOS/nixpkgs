{
  alsa-lib,
  fetchFromGitHub,
  lib,
  openssl,
  pkg-config,
  protobuf,
  rustPlatform,

  # needed for GUI client
  gtk4,
  libadwaita,
  webkitgtk_6_0,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "qobine";
  version = "2026-08-28";

  src = fetchFromGitHub {
    owner = "SofusA";
    repo = "qobine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C1GbLRuur1p5h/nGl9X5cYQCNAjai/u9Qo+XqkpJfzI=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  cargoHash = "sha256-OidPG2oJdr2IBZGYw46500//EdlmK8kDRFm6lPOeD3M=";

  doCheck = false;

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = [
    alsa-lib
    gtk4
    libadwaita
    openssl
    webkitgtk_6_0
  ];

  meta = {
    description = "Tui, web and rfid player for Qobuz";
    homepage = "https://github.com/SofusA/qobine";
    changelog = "https://github.com/SofusA/qobine/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      felixsinger
    ];
    platforms = lib.platforms.linux;
    mainProgram = "qobine-tui";
  };
})
