{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "obs-do";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "jonhoo";
    repo = "obs-do";
    rev = "refs/tags/v${version}";
    hash = "sha256-Wqz+oR/FIShSgF4xbXMMCxFUscOnoQr1aHQBCCacJgo=";
  };

  cargoHash = "sha256-J1bj4TQzEB8qoR6cNyW/fK9Vi0l+wRZlP/2smzbYhVg=";

  meta = with lib; {
    description = "CLI for common OBS operations while streaming using WebSocket";
    homepage = "https://github.com/jonhoo/obs-do";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ GaetanLepage ];
    mainProgram = "obs-do";
  };
}
