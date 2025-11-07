{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage {
  pname = "librespot-ma";
  version = "0.7.1-unstable-2025-11-06";

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "librespot";
    rev = "2af61256649d6c1ed149791a53a20a595b617704";
    hash = "sha256-sarxS6YArK5luX4TRXJUKhreMqhZbsS/3fCVWHxPNpY=";
  };

  cargoHash = "sha256-CI2BFmQNK1+J2qaKg6u6WM83jwBuWjeh9dROnrF3Kv0=";

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
