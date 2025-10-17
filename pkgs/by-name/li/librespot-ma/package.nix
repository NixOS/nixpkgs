{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage {
  pname = "librespot-ma";
  version = "0.6.0-unstable-2025-08-10";

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "librespot";
    rev = "accecb60a16334013c0c99a5ded553794ee871b7";
    hash = "sha256-vPiI8llXB6+ahX+iad/Ut81D3iZcTSVmYGDXXwApk/w=";
  };

  cargoHash = "sha256-Lujz2revTAok9B0hzdl8NVQ5XMRY9ACJzoQHIkIgKMg=";

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
