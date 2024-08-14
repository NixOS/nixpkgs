{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "microfetch";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "NotAShelf";
    repo = "microfetch";
    rev = "refs/tags/v${version}";
    hash = "sha256-iBfnui7xrx31euYnQxoJf1xXFYFiJnDMadLRAiRCN04=";
  };

  cargoHash = "sha256-J+S6XIMUcWj4jXABQinEDx6dRG5Byc2UxJoKj2y1tQU=";

  meta = {
    description = "Microscopic fetch script in Rust, for NixOS systems";
    homepage = "https://github.com/NotAShelf/microfetch";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nydragon ];
    mainProgram = "microfetch";
    platforms = lib.platforms.linux;
  };
}
