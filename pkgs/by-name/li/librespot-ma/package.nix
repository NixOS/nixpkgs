{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage {
  pname = "librespot-ma";
  version = "0.8.0-unstable-2025-12-05";

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "librespot";
    rev = "1d68d603027d89d1a60bf5a15f180e28382e2cfc";
    hash = "sha256-quKAiXqTwf6cgKi9qqksQRaGqV9UZjerHQZfqDVHCIs=";
  };

  cargoHash = "sha256-Kf3w6tD/MQaXXegtiCkFbUcYwr4OMw6ipLxNLxJ2NTQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [ openssl ];

  meta = {
    description = "Fork of librespot for use in Music Assistant only";
    homepage = "https://github.com/music-assistant/librespot";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sweenu
      emilylange
    ];
    mainProgram = "librespot";
    platforms = lib.platforms.linux;
  };
}
