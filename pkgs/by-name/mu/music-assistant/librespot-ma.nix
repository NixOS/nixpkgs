{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  openssl,
}:

rustPlatform.buildRustPackage {
  pname = "librespot";
  version = "ma-fork";

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "librespot";
    rev = "accecb60a16334013c0c99a5ded553794ee871b7";
    hash = "sha256-vPiI8llXB6+ahX+iad/Ut81D3iZcTSVmYGDXXwApk/w=";
  };

  cargoHash = "sha256-Lujz2revTAok9B0hzdl8NVQ5XMRY9ACJzoQHIkIgKMg=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [ openssl ];

  meta = {
    description = "Music Assistant fork of librespot, an open source Spotify client library";
    homepage = "https://github.com/music-assistant/librespot";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sweenu ];
    mainProgram = "librespot";
    platforms = lib.platforms.unix;
  };
}
