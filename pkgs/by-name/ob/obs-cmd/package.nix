{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "obs-cmd";
  version = "0.17.9";

  src = fetchFromGitHub {
    owner = "grigio";
    repo = "obs-cmd";
    rev = "v${version}";
    hash = "sha256-R3zGYVa5ux3pcniuXzKwxJK/5/7YrVOrqC2H42P2fK0=";
  };

  cargoHash = "sha256-bFOaR48xdc4+DvlFnXCWtzqMbE1cTo7xrsf/aIBlRX0=";

  meta = with lib; {
    description = "Minimal CLI to control OBS Studio via obs-websocket";
    homepage = "https://github.com/grigio/obs-cmd";
    changelog = "https://github.com/grigio/obs-cmd/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "obs-cmd";
  };
}
