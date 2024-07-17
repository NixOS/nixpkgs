{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  makeWrapper,
  alsa-lib,
  lame,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "downonspot";
  version = "unstable-2024-04-30";

  src = fetchFromGitHub {
    owner = "oSumAtrIX";
    repo = "DownOnSpot";
    rev = "669dbb18e105129fff4886ba3710596d54a5f33a";
    hash = "sha256-sUptn+tmQoI2i9WBpJU23MkdQ9h+Lmx590+2+0XXC7w=";
  };

  # Use official public librespot version
  cargoPatches = [ ./Cargo.lock.patch ];

  cargoHash = "sha256-GHhijwgTge7jzdkn0qynQIBNYeqtY26C5BaLpQ/UWgQ=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    openssl
    alsa-lib
    lame
  ];

  meta = with lib; {
    description = "A Spotify downloader written in rust";
    homepage = "https://github.com/oSumAtrIX/DownOnSpot";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ onny ];
    mainProgram = "down_on_spot";
  };
}
